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
package net.sourceforge.subsonic.util;

import java.awt.Dimension;

import junit.framework.TestCase;
import net.sourceforge.subsonic.controller.StreamController;

/**
 * Unit test of {@link Util}.
 *
 * @author Sindre Mehus
 */
public class UtilTestCase extends TestCase {

    public void testGetSuitableVideoSize() {

        // 4:3 aspect rate
        doTestGetSuitableVideoSize(1280, 960, 200, 400, 300);
        doTestGetSuitableVideoSize(1280, 960, 300, 400, 300);
        doTestGetSuitableVideoSize(1280, 960, 400, 480, 360);
        doTestGetSuitableVideoSize(1280, 960, 500, 480, 360);
        doTestGetSuitableVideoSize(1280, 960, 600, 640, 480);
        doTestGetSuitableVideoSize(1280, 960, 700, 640, 480);
        doTestGetSuitableVideoSize(1280, 960, 800, 640, 480);
        doTestGetSuitableVideoSize(1280, 960, 900, 640, 480);
        doTestGetSuitableVideoSize(1280, 960, 1000, 640, 480);
        doTestGetSuitableVideoSize(1280, 960, 1100, 640, 480);
        doTestGetSuitableVideoSize(1280, 960, 1200, 640, 480);
        doTestGetSuitableVideoSize(1280, 960, 1500, 640, 480);
        doTestGetSuitableVideoSize(1280, 960, 1800, 960, 720);
        doTestGetSuitableVideoSize(1280, 960, 2000, 960, 720);

        // 16:9 aspect rate
        doTestGetSuitableVideoSize(1280, 720, 200, 400, 226);
        doTestGetSuitableVideoSize(1280, 720, 300, 400, 226);
        doTestGetSuitableVideoSize(1280, 720, 400, 480, 270);
        doTestGetSuitableVideoSize(1280, 720, 500, 480, 270);
        doTestGetSuitableVideoSize(1280, 720, 600, 640, 360);
        doTestGetSuitableVideoSize(1280, 720, 700, 640, 360);
        doTestGetSuitableVideoSize(1280, 720, 800, 640, 360);
        doTestGetSuitableVideoSize(1280, 720, 900, 640, 360);
        doTestGetSuitableVideoSize(1280, 720, 1000, 640, 360);
        doTestGetSuitableVideoSize(1280, 720, 1100, 640, 360);
        doTestGetSuitableVideoSize(1280, 720, 1200, 640, 360);
        doTestGetSuitableVideoSize(1280, 720, 1500, 640, 360);
        doTestGetSuitableVideoSize(1280, 720, 1800, 960, 540);
        doTestGetSuitableVideoSize(1280, 720, 2000, 960, 540);

        // Small original size.
        doTestGetSuitableVideoSize(100, 100, 1000, 100, 100);
        doTestGetSuitableVideoSize(100, 1000, 1000, 100, 1000);
        doTestGetSuitableVideoSize(1000, 100, 100, 1000, 100);

        // Unknown original size.
        doTestGetSuitableVideoSize(720, null, 200, 400, 226);
        doTestGetSuitableVideoSize(null, 540, 300, 400, 226);
        doTestGetSuitableVideoSize(null, null, 400, 480, 270);
        doTestGetSuitableVideoSize(720, null, 500, 480, 270);
        doTestGetSuitableVideoSize(null, 540, 600, 640, 360);
        doTestGetSuitableVideoSize(null, null, 700, 640, 360);
        doTestGetSuitableVideoSize(720, null, 1200, 640, 360);
        doTestGetSuitableVideoSize(null, 540, 1500, 640, 360);
        doTestGetSuitableVideoSize(null, null, 2000, 960, 540);

        // Odd original size.
        doTestGetSuitableVideoSize(203, 101, 1500, 204, 102);
        doTestGetSuitableVideoSize(464, 853, 1500, 464, 854);
    }

    private void doTestGetSuitableVideoSize(Integer existingWidth, Integer existingHeight, Integer maxBitRate, int expectedWidth, int expectedHeight) {
        StreamController controller = new StreamController();
        Dimension dimension = Util.getSuitableVideoSize(existingWidth, existingHeight, maxBitRate);
        assertEquals("Wrong width.", expectedWidth, dimension.width);
        assertEquals("Wrong height.", expectedHeight, dimension.height);
    }
}
