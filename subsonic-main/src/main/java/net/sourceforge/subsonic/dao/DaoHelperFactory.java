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

import net.sourceforge.subsonic.Logger;

/**
 * @author Sindre Mehus
 * @version $Id$
 */
public class DaoHelperFactory {

    private static final Logger LOG = Logger.getLogger(DaoHelperFactory.class);

    public static DaoHelper create() {
        String jdbcUrl = System.getProperty("subsonic.db");

        if (jdbcUrl == null) {
            return new HsqlDaoHelper();
        }

        if (jdbcUrl.contains("mysql")) {
            return new MySqlDaoHelper(jdbcUrl);
        }

        LOG.error("Unsupported JDBC url:" + jdbcUrl + ". Reverting to HSQL. Check system property 'subsonic.db'.");
        return new HsqlDaoHelper();
    }
}
