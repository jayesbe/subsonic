/*
 This file is part of Subsonic.

 Subsonic is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Subsonic is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Subsonic.  If not, see <http://www.gnu.org/licenses/>.

 Copyright 2009 (C) Sindre Mehus
 */
package net.sourceforge.subsonic.controller;

import java.awt.Dimension;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import com.google.common.io.Files;

import net.sourceforge.subsonic.Logger;
import net.sourceforge.subsonic.domain.MediaFile;
import net.sourceforge.subsonic.domain.PlayQueue;
import net.sourceforge.subsonic.domain.Player;
import net.sourceforge.subsonic.domain.TransferStatus;
import net.sourceforge.subsonic.domain.User;
import net.sourceforge.subsonic.domain.VideoConversion;
import net.sourceforge.subsonic.domain.VideoTranscodingSettings;
import net.sourceforge.subsonic.io.PlayQueueInputStream;
import net.sourceforge.subsonic.io.ShoutCastOutputStream;
import net.sourceforge.subsonic.service.AudioScrobblerService;
import net.sourceforge.subsonic.service.MediaFileService;
import net.sourceforge.subsonic.service.PlayerService;
import net.sourceforge.subsonic.service.PlaylistService;
import net.sourceforge.subsonic.service.SearchService;
import net.sourceforge.subsonic.service.SecurityService;
import net.sourceforge.subsonic.service.SettingsService;
import net.sourceforge.subsonic.service.StatusService;
import net.sourceforge.subsonic.service.TranscodingService;
import net.sourceforge.subsonic.service.VideoConversionService;
import net.sourceforge.subsonic.service.sonos.SonosHelper;
import net.sourceforge.subsonic.util.HttpRange;
import net.sourceforge.subsonic.util.StringUtil;
import net.sourceforge.subsonic.util.Util;

/**
 * A controller which streams the content of a {@link net.sourceforge.subsonic.domain.PlayQueue} to a remote
 * {@link Player}.
 *
 * @author Sindre Mehus
 */
public class StreamController implements Controller {

    private static final Logger LOG = Logger.getLogger(StreamController.class);

    private StatusService statusService;
    private PlayerService playerService;
    private PlaylistService playlistService;
    private SecurityService securityService;
    private SettingsService settingsService;
    private TranscodingService transcodingService;
    private AudioScrobblerService audioScrobblerService;
    private MediaFileService mediaFileService;
    private SearchService searchService;
    private VideoConversionService videoConversionService;

    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return handleRequest(request, response, true);
    }

    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response, boolean authenticate) throws Exception {

        logRequest(request);

        TransferStatus status = null;
        InputStream in = null;
        Player player = playerService.getPlayer(request, response, false, true);
        User user = securityService.getUserByName(player.getUsername());

        try {

            if (!user.isStreamRole()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Streaming is forbidden for user " + user.getUsername());
                return null;
            }

            // If "playlist" request parameter is set, this is a Podcast request. In that case, create a separate
            // play queue (in order to support multiple parallel Podcast streams).
            Integer playlistId = ServletRequestUtils.getIntParameter(request, "playlist");
            boolean isPodcast = playlistId != null;
            if (isPodcast) {
                PlayQueue playQueue = new PlayQueue();
                playQueue.addFiles(false, playlistService.getFilesInPlaylist(playlistId));
                player.setPlayQueue(playQueue);
                Util.setContentLength(response, playQueue.length());
                LOG.info("Incoming Podcast request for playlist " + playlistId);
            }

            response.setHeader("Access-Control-Allow-Origin", "*");

            String contentType = StringUtil.getMimeType(request.getParameter("suffix"));
            response.setContentType(contentType);

            String preferredTargetFormat = request.getParameter("format");
            Integer maxBitRate = ServletRequestUtils.getIntParameter(request, "maxBitRate");
            if (Integer.valueOf(0).equals(maxBitRate)) {
                maxBitRate = null;
            }

            VideoTranscodingSettings videoTranscodingSettings = null;

            // Is this a request for a single file?
            // In that case, create a separate playlist (in order to support multiple parallel streams).
            // Also, enable partial download (HTTP byte range).
            MediaFile file = getSingleFile(request);
            boolean isSingleFile = file != null;
            boolean isHls = false;
            boolean isConversion = false;
            HttpRange range = null;
            VideoConversion videoConversion = null;

            if (isSingleFile) {

                if (authenticate && !securityService.isAuthenticated(file, request) ||
                    !securityService.isFolderAccessAllowed(file, user.getUsername())) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN,
                                       "Access to file " + file.getId() + " is forbidden for user " + user.getUsername());
                    return null;
                }

                videoConversion = getVideoConversion(file, request);

                PlayQueue playQueue = new PlayQueue();
                playQueue.addFiles(true, file);
                player.setPlayQueue(playQueue);

                response.setIntHeader("ETag", file.getId());
                response.setHeader("Accept-Ranges", "bytes");

                TranscodingService.Parameters parameters = transcodingService.getParameters(file, player, maxBitRate, preferredTargetFormat, null, videoConversion);
                long fileLength = getFileLength(parameters);
                isConversion = parameters.isDownsample() || parameters.isTranscode();
                boolean estimateContentLength = ServletRequestUtils.getBooleanParameter(request, "estimateContentLength", false);
                isHls = ServletRequestUtils.getBooleanParameter(request, "hls", false);

                range = HttpRange.of(request, fileLength);
                if (range != null) {
                    response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);
                    Util.setContentLength(response, range.getLength());
                    long lastBytePos = range.getLastBytePos() != null ? range.getLastBytePos() : fileLength - 1;
                    response.setHeader("Content-Range", "bytes " + range.getFirstBytePos() + "-" + lastBytePos + "/" + fileLength);
                    LOG.info("Content-Length: " + range.getLength());
                    LOG.info("Content-Range: " + range.getFirstBytePos() + "-" + lastBytePos + "/" + fileLength);
                } else if (!isHls && (!isConversion || estimateContentLength)) {
                    Util.setContentLength(response, fileLength);
                }

                if (isHls) {
                    response.setContentType(StringUtil.getMimeType("ts")); // HLS is always MPEG TS.
                } else {
                    String transcodedSuffix = videoConversion != null ? "mp4" : transcodingService.getSuffix(player, file, preferredTargetFormat);
                    boolean sonos = SonosHelper.SUBSONIC_CLIENT_ID.equals(player.getClientId());
                    response.setContentType(StringUtil.getMimeType(transcodedSuffix, sonos));
                    setContentDuration(response, file);
                }

                if (file.isVideo() || isHls) {
                    videoTranscodingSettings = createVideoTranscodingSettings(file, request);
                }
            }

            if (request.getMethod().equals("HEAD")) {
                return null;
            }

            // Terminate any other streams to this player.
            if (!isPodcast && !isSingleFile) {
                for (TransferStatus streamStatus : statusService.getStreamStatusesForPlayer(player)) {
                    if (streamStatus.isActive()) {
                        streamStatus.terminate();
                    }
                }
            }

            status = statusService.createStreamStatus(player);

            // Optimize the case where no conversion is to take place
            if (isSingleFile && !isHls && !isConversion) {
                sendFile(file, videoConversion, range, status, response, player);
                return null;
            }

            in = new PlayQueueInputStream(player, status, maxBitRate, preferredTargetFormat, videoTranscodingSettings, transcodingService,
                                          audioScrobblerService, mediaFileService, searchService);
            in = Util.sliceInputStream(in, range);
            OutputStream out = response.getOutputStream();

            // Enabled SHOUTcast, if requested.
            boolean isShoutCastRequested = "1".equals(request.getHeader("icy-metadata"));
            if (isShoutCastRequested && !isSingleFile) {
                response.setHeader("icy-metaint", "" + ShoutCastOutputStream.META_DATA_INTERVAL);
                response.setHeader("icy-notice1", "This stream is served using Subsonic");
                response.setHeader("icy-notice2", "Subsonic media streamer - subsonic.org");
                response.setHeader("icy-name", "Subsonic");
                response.setHeader("icy-genre", "Mixed");
                response.setHeader("icy-url", "http://subsonic.org/");
                out = new ShoutCastOutputStream(out, player.getPlayQueue(), settingsService);
            }

            final int BUFFER_SIZE = 2048;
            byte[] buf = new byte[BUFFER_SIZE];

            while (true) {

                // Check if stream has been terminated.
                if (status.terminated()) {
                    return null;
                }

                if (player.getPlayQueue().getStatus() == PlayQueue.Status.STOPPED) {
                    if (isPodcast || isSingleFile) {
                        break;
                    } else {
                        sendDummy(buf, out);
                    }
                } else {

                    int n = in.read(buf);
                    if (n == -1) {
                        if (isPodcast || isSingleFile) {
                            break;
                        } else {
                            sendDummy(buf, out);
                        }
                    } else {
                        out.write(buf, 0, n);
                    }
                }
            }

        } finally {
            if (status != null) {
                securityService.updateUserByteCounts(user, status.getBytesTransfered(), 0L, 0L);
                statusService.removeStreamStatus(status);
            }
            IOUtils.closeQuietly(in);
        }
        return null;
    }

    private VideoConversion getVideoConversion(MediaFile file, HttpServletRequest request) {
        if (ServletRequestUtils.getBooleanParameter(request, "converted", false)) {
            VideoConversion conversion = videoConversionService.getVideoConversionForFile(file.getId());
            if (conversion.getStatus() == VideoConversion.Status.COMPLETED) {
                return conversion;
            }
        }
        return null;
    }

    private void sendFile(MediaFile mediaFile, VideoConversion videoConversion, HttpRange range, TransferStatus transferStatus, HttpServletResponse response, Player player) throws IOException {
        File file = videoConversion != null ? new File(videoConversion.getTargetFile()) : mediaFile.getFile();

        long offset = 0;
        long length = file.length();
        if (range != null) {
            offset = range.getOffset();
            length = range.getLength();
        }

        if (range == null || range.getOffset() == 0) {
            mediaFileService.incrementPlayCount(mediaFile);
        }

        transferStatus.setFile(mediaFile);
        scrobble(mediaFile, player, false);

        long n = Files.asByteSource(file)
                      .slice(offset, length)
                      .copyTo(response.getOutputStream());

        transferStatus.addBytesTransfered(n);
        scrobble(mediaFile, player, true);
        LOG.info("Wrote " + n + " bytes of " + length + " requested");
    }

    private void scrobble(MediaFile video, Player player, boolean submission) {
        // Don't scrobble REST players (except Sonos)
        if (player.getClientId() == null || player.getClientId().equals(SonosHelper.SUBSONIC_CLIENT_ID)) {
            audioScrobblerService.register(video, player.getUsername(), submission, null);
        }
    }

    private void logRequest(HttpServletRequest request) {
        LOG.debug(request.getMethod() + " " + request.getRequestURI() + "?" + request.getQueryString()
                  + ", Range: " + request.getHeader("Range"));
    }

    private void setContentDuration(HttpServletResponse response, MediaFile file) {
        if (file.getDurationSeconds() != null) {
            response.setHeader("X-Content-Duration", String.format("%.1f", file.getDurationSeconds().doubleValue()));
        }
    }

    private MediaFile getSingleFile(HttpServletRequest request) throws ServletRequestBindingException {
        String path = request.getParameter("path");
        if (path != null) {
            return mediaFileService.getMediaFile(path);
        }
        Integer id = ServletRequestUtils.getIntParameter(request, "id");
        if (id != null) {
            return mediaFileService.getMediaFile(id);
        }
        return null;
    }

    private long getFileLength(TranscodingService.Parameters parameters) {

        VideoConversion videoConversion = parameters.getVideoConversion();
        if (videoConversion != null) {
            return new File(videoConversion.getTargetFile()).length();
        }

        MediaFile file = parameters.getMediaFile();

        if (!parameters.isDownsample() && !parameters.isTranscode()) {
            return file.getFileSize();
        }
        Integer duration = file.getDurationSeconds();
        Integer maxBitRate = parameters.getMaxBitRate();

        if (duration == null) {
            LOG.warn("Unknown duration for " + file + ". Unable to estimate transcoded size.");
            return file.getFileSize();
        }

        if (maxBitRate == null) {
            LOG.error("Unknown bit rate for " + file + ". Unable to estimate transcoded size.");
            return file.getFileSize();
        }

        return duration * maxBitRate * 1000L / 8L;
    }

    private VideoTranscodingSettings createVideoTranscodingSettings(MediaFile file, HttpServletRequest request) throws ServletRequestBindingException {
        Integer existingWidth = file.getWidth();
        Integer existingHeight = file.getHeight();
        Integer maxBitRate = ServletRequestUtils.getIntParameter(request, "maxBitRate");
        int timeOffset = ServletRequestUtils.getIntParameter(request, "timeOffset", 0);
        int defaultDuration = file.getDurationSeconds() == null ? Integer.MAX_VALUE : file.getDurationSeconds() - timeOffset;
        int duration = ServletRequestUtils.getIntParameter(request, "duration", defaultDuration);
        boolean hls = ServletRequestUtils.getBooleanParameter(request, "hls", false);

        Dimension dim = getRequestedVideoSize(request.getParameter("size"));
        if (dim == null) {
            dim = Util.getSuitableVideoSize(existingWidth, existingHeight, maxBitRate);
        }

        return new VideoTranscodingSettings(dim.width, dim.height, timeOffset, duration, hls);
    }

    protected Dimension getRequestedVideoSize(String sizeSpec) {
        if (sizeSpec == null) {
            return null;
        }

        Pattern pattern = Pattern.compile("^(\\d+)x(\\d+)$");
        Matcher matcher = pattern.matcher(sizeSpec);
        if (matcher.find()) {
            int w = Integer.parseInt(matcher.group(1));
            int h = Integer.parseInt(matcher.group(2));
            if (w >= 0 && h >= 0 && w <= 2000 && h <= 2000) {
                return new Dimension(w, h);
            }
        }
        return null;
    }

    /**
     * Feed the other end with some dummy data to keep it from reconnecting.
     */
    private void sendDummy(byte[] buf, OutputStream out) throws IOException {
        try {
            Thread.sleep(2000);
        } catch (InterruptedException x) {
            LOG.warn("Interrupted in sleep.", x);
        }
        Arrays.fill(buf, (byte) 0xFF);
        out.write(buf);
        out.flush();
    }

    public void setStatusService(StatusService statusService) {
        this.statusService = statusService;
    }

    public void setPlayerService(PlayerService playerService) {
        this.playerService = playerService;
    }

    public void setPlaylistService(PlaylistService playlistService) {
        this.playlistService = playlistService;
    }

    public void setSecurityService(SecurityService securityService) {
        this.securityService = securityService;
    }

    public void setSettingsService(SettingsService settingsService) {
        this.settingsService = settingsService;
    }

    public void setTranscodingService(TranscodingService transcodingService) {
        this.transcodingService = transcodingService;
    }

    public void setAudioScrobblerService(AudioScrobblerService audioScrobblerService) {
        this.audioScrobblerService = audioScrobblerService;
    }

    public void setMediaFileService(MediaFileService mediaFileService) {
        this.mediaFileService = mediaFileService;
    }

    public void setSearchService(SearchService searchService) {
        this.searchService = searchService;
    }

    public void setVideoConversionService(VideoConversionService videoConversionService) {
        this.videoConversionService = videoConversionService;
    }
}
