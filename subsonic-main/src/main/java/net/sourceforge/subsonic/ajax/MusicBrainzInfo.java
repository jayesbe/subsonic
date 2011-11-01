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

/**
 * Contains Music Brainz info for a track.
 *
 * @author Sindre Mehus
 */
public class MusicBrainzInfo {

    private final String mbid;
    private final String artist;
    private final String track;

    public MusicBrainzInfo() {
        this(null, null, null);
    }

    public MusicBrainzInfo(String mbid, String artist, String track) {
        this.mbid = mbid;
        this.artist = artist;
        this.track = track;
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
