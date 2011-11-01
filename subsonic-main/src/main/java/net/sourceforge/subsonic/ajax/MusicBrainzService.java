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
package net.sourceforge.subsonic.ajax;

import net.sourceforge.subsonic.Logger;
import net.sourceforge.subsonic.util.StringUtil;

import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.params.HttpConnectionParams;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.Namespace;
import org.jdom.input.SAXBuilder;

import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/**
 * Provides AJAX-enabled services for retrieving information from musicbrainz.org.
 * <p/>
 * See http://www.musicbrainz.org/ for details.
 * <p/>
 * This class is used by the DWR framework (http://getahead.ltd.uk/dwr/).
 *
 * @author Sindre Mehus
 */
public class MusicBrainzService {

    private static final Logger LOG = Logger.getLogger(LyricsService.class);

    /**
     * Returns Music Brainz information for the given track and artist.
     *
     * @param artist The artist.
     * @param track  The track.
     * @return The Music Brainz, never <code>null</code> .
     */
    public MusicBrainzInfo getMBID(String artist, String track) {

        try {
            artist = encode(artist);
            track = encode(track);

            String url = "http://api.musixmatch.com/ws/1.1/track.search?&q_artist=" + artist + "&q_track=" + track + "&format=xml&page_size=1&f_has_lyrics=1";
            String xml = executeGetRequest(url);

            SearchTrackIDResult searchTrackIDResult = parseSearchTrackID(xml);
            if (searchTrackIDResult == null) {
                return new MusicBrainzInfo();
            }
            String status = searchTrackIDResult.getStatus();
            if (!(status.equals("200"))) {
                LOG.warn("Failed to fetch track id. Server returned status '" + status + "'.");
                return new MusicBrainzInfo();
            }

            // Short wait otherwise server refuses requests
            Thread.sleep(1000);

            return new MusicBrainzInfo(searchTrackIDResult.getMBID(), searchTrackIDResult.getArtist(), searchTrackIDResult.getTrack());

        } catch (Exception x) {
            LOG.warn("Failed to fetch track information for '" + track + "'.", x);
            return new MusicBrainzInfo();
        }
    }

    private String encode(String s) throws UnsupportedEncodingException {
        return URLEncoder.encode(s, StringUtil.ENCODING_UTF8);
    }

    private SearchTrackIDResult parseSearchTrackID(String xml) throws Exception {
        SAXBuilder builder = new SAXBuilder();
        Document document = builder.build(new StringReader(xml));

        Element root = document.getRootElement();
        Namespace ns = root.getNamespace();

        Element header = root.getChild("header", ns);
        if (header == null) {
            return null;
        }

        String status = header.getChildText("status_code", ns);
        if (!(status.equals("200"))) {
            return new SearchTrackIDResult(status, null, null, null);
        }
        
        // 200 OK

        Element body = root.getChild("body", ns);
        Element tracklist = body.getChild("track_list", ns);
        Element element = tracklist.getChild("track", ns);
        if (element == null) {
            return null;
        }

        String mbid = element.getChildText("track_mbid", ns);
        String artist = element.getChildText("artist_name", ns);
        String track = element.getChildText("track_name", ns);

        if (mbid == null || artist == null || track == null) {
            return null;
        }

        return new SearchTrackIDResult(status, mbid, artist, track);
    }

    private String executeGetRequest(String url) throws IOException {
        HttpClient client = new DefaultHttpClient();
        HttpConnectionParams.setConnectionTimeout(client.getParams(), 15000);
        HttpConnectionParams.setSoTimeout(client.getParams(), 15000);
        HttpGet method = new HttpGet(url);
        try {

            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            return client.execute(method, responseHandler);

        } finally {
            client.getConnectionManager().shutdown();
        }
    }

    private static class SearchTrackIDResult {

        private final String status;
        private final String mbid;
        private final String artist;
        private final String track;

        private SearchTrackIDResult(String status, String mbid, String artist, String track) {
            this.status = status;
            this.mbid = mbid;
            this.artist = artist;
            this.track = track;
        }

        public String getStatus() {
            return status;
        }

        public String getMBID() {
            return mbid;
        }

        public String getArtist() {
            return artist;
        }

        public String getTrack() {
            return track;
        }
    }

}
