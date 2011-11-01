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
 * Contains lyrics info for a song.
 *
 * @author Sindre Mehus
 */
public class LyricsInfo {

    private final String lyrics;
    private final String mmid;
    private final String mbid;
    private final String artist;
    private final String track;
    private final String tracker;
    private final String copyright;

    public LyricsInfo() {
        this(null, null, null, null, null, null, null);
    }

    public LyricsInfo(String lyrics, String mmid, String mbid, String artist, String track, String tracker, String copyright) {
        this.lyrics = lyrics;
        this.mmid = mmid;
        this.mbid = mbid;
        this.artist = artist;
        this.track = track;
        this.tracker = tracker;
        this.copyright = copyright;
    }

    public String getLyrics() {
        return lyrics;
    }

    public String getMMID() {
        return mmid;
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

    public String getTracker() {
        return tracker;
    }

    public String getCopyright() {
        return copyright;
    }
}
