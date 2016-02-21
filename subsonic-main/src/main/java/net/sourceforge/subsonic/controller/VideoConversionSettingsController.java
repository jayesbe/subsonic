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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.ParameterizableViewController;

import net.sourceforge.subsonic.domain.MediaFile;
import net.sourceforge.subsonic.domain.VideoConversion;
import net.sourceforge.subsonic.service.MediaFileService;
import net.sourceforge.subsonic.service.SettingsService;
import net.sourceforge.subsonic.service.VideoConversionService;

/**
 * Controller for the page used to administrate the video conversions.
 *
 * @author Sindre Mehus
 */
public class VideoConversionSettingsController extends ParameterizableViewController {

    private VideoConversionService videoConversionService;
    private SettingsService settingsService;
    private MediaFileService mediaFileService;

    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String, Object> map = new HashMap<String, Object>();

        if (isFormSubmission(request)) {
            handleParameters(request);
            map.put("toast", true);
        }

        ModelAndView result = super.handleRequestInternal(request, response);

        map.put("conversionInfos", getVideoConversionInfo());
        map.put("directory", settingsService.getVideoConversionDirectory());
        map.put("licenseInfo", settingsService.getLicenseInfo());

        result.addObject("model", map);
        return result;
    }

    private List<VideoConversionInfo> getVideoConversionInfo() {
        List<VideoConversionInfo> result = new ArrayList<VideoConversionInfo>();
        for (VideoConversion conversion : videoConversionService.getAllVideoConversions()) {
            result.add(new VideoConversionInfo(conversion, mediaFileService.getMediaFile(conversion.getMediaFileId())));
        }
        return result;
    }

    /**
     * Determine if the given request represents a form submission.
     *
     * @param request current HTTP request
     * @return if the request represents a form submission
     */
    private boolean isFormSubmission(HttpServletRequest request) {
        return "POST".equals(request.getMethod());
    }

    private void handleParameters(HttpServletRequest request) {
        for (VideoConversion conversion : videoConversionService.getAllVideoConversions()) {
            boolean delete = getParameter(request, "delete", conversion.getId()) != null;
            if (delete) {
                videoConversionService.deleteVideoConversion(conversion);
            }
        }

        String directory = StringUtils.trimToNull(request.getParameter("directory"));
        if (directory != null) {
            settingsService.setVideoConversionDirectory(directory);
            settingsService.save();
        }
    }

    private String getParameter(HttpServletRequest request, String name, int id) {
        return StringUtils.trimToNull(request.getParameter(name + "[" + id + "]"));
    }

    public void setMediaFileService(MediaFileService mediaFileService) {
        this.mediaFileService = mediaFileService;
    }

    public static class VideoConversionInfo {
        private final VideoConversion conversion;
        private final MediaFile video;

        public VideoConversionInfo(VideoConversion conversion, MediaFile video) {
            this.conversion = conversion;
            this.video = video;
        }

        public VideoConversion getConversion() {
            return conversion;
        }

        public MediaFile getVideo() {
            return video;
        }
    }

    public void setVideoConversionService(VideoConversionService videoConversionService) {
        this.videoConversionService = videoConversionService;
    }

    public void setSettingsService(SettingsService settingsService) {
        this.settingsService = settingsService;
    }
}
