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
package net.sourceforge.subsonic.androidapp.service.parser;

import java.io.Reader;

import org.xmlpull.v1.XmlPullParser;

import android.content.Context;
import android.util.Xml;
import net.sourceforge.subsonic.u1m.R;
import net.sourceforge.subsonic.androidapp.domain.MusicDirectory;
import net.sourceforge.subsonic.androidapp.util.ProgressListener;

/**
 * @author Sindre Mehus
 */
public class RandomSongsParser extends MusicDirectoryParser {

    public RandomSongsParser(Context context) {
        super(context);
    }

    public MusicDirectory parse(Reader reader, ProgressListener progressListener) throws Exception {
        if (progressListener != null) {
            progressListener.updateProgress(R.string.parser_reading);
        }

        XmlPullParser parser = Xml.newPullParser();
        parser.setInput(reader);

        MusicDirectory dir = new MusicDirectory();
        int eventType;
        do {
            eventType = parser.next();
            if (eventType == XmlPullParser.START_TAG) {
                String name = parser.getName();
                if ("song".equals(name)) {
                    dir.addChild(parseEntry(parser));
                } else if ("error".equals(name)) {
                    handleError(parser);
                }
            }
        } while (eventType != XmlPullParser.END_DOCUMENT);

        if (progressListener != null) {
            progressListener.updateProgress(R.string.parser_reading_done);
        }
        return dir;
    }

}