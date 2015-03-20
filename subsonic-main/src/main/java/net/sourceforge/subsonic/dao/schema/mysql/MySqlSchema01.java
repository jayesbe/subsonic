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
package net.sourceforge.subsonic.dao.schema.mysql;

import java.io.InputStream;

import org.apache.commons.io.IOUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.google.common.base.Splitter;

import net.sourceforge.subsonic.Logger;
import net.sourceforge.subsonic.dao.schema.Schema;
import net.sourceforge.subsonic.util.StringUtil;

/**
 * Used for creating and evolving the database schema.
 * This class implementes the database schema for MySQL.
 *
 * @author Sindre Mehus
 */
public class MySqlSchema01 extends Schema {
    private static final Logger LOG = Logger.getLogger(MySqlSchema01.class);

    public void execute(JdbcTemplate template) throws Exception {
        if (!tableExists(template, "version")) {
            LOG.info("Database table 'version' not found.  Creating it.");
            template.execute("create table version (version int not null)");
            template.execute("insert into version values (1)");
            LOG.info("Database table 'version' was created successfully.");

            InputStream in = getClass().getResourceAsStream("mysql_schema_01.sql");
            String statements = IOUtils.toString(in, StringUtil.ENCODING_UTF8);
            for (String statement : Splitter.on(";").omitEmptyStrings().trimResults().split(statements)) {
                template.execute(statement);
                LOG.info(statement);
            }
        }
    }
}
