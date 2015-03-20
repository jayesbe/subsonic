/*
 * This file is part of Subsonic.
 *
 *  Subsonic is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Subsonic is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Subsonic.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Copyright 2015 (C) Sindre Mehus
 */

package net.sourceforge.subsonic.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;

import net.sourceforge.subsonic.domain.AudioAd;

/**
 * @author Sindre Mehus
 * @version $Id$
 */
public class AudioAdDao extends AbstractDao {

    private static final String COLUMNS = "id, media_file_id, weight, comment, enabled, created, changed";
    private final RowMapper rowMapper = new AudioAdMapper();
    private MediaFileDao mediaFileDao;

    public List<AudioAd> getAllAudioAds(boolean includeAll) {
        return query("select " + COLUMNS + " from audio_ad where enabled or ?", rowMapper, includeAll);
    }

    public void createAudioAd(AudioAd ad) {
        update("insert into audio_ad (" + COLUMNS + ") values (" + questionMarks(COLUMNS) + ")", null,
               ad.getMediaFile().getId(), ad.getWeight(), ad.getComment(), ad.isEnabled(), ad.getCreated(), ad.getChanged());
    }

    public void deleteAudioAd(int id) {
        update("delete from audio_ad where id = ? ", id);
    }

    public void updateAudioAd(AudioAd ad) {
        update("update audio_ad set media_file_id = ?, weight = ?, comment = ?, enabled = ?, created = ?, changed = ? where id = ?",
               ad.getMediaFile().getId(), ad.getWeight(), ad.getComment(), ad.isEnabled(), ad.getCreated(), ad.getChanged(), ad.getId());
    }

    public void setMediaFileDao(MediaFileDao mediaFileDao) {
        this.mediaFileDao = mediaFileDao;
    }

    private class AudioAdMapper implements ParameterizedRowMapper<AudioAd> {
        public AudioAd mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new AudioAd(rs.getInt(1),
                               mediaFileDao.getMediaFile(rs.getInt(2)),
                               rs.getDouble(3),
                               rs.getString(4),
                               rs.getBoolean(5),
                               rs.getTimestamp(6),
                               rs.getTimestamp(7));
        }
    }
}
