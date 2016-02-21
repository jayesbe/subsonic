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

import junit.framework.TestCase;

/**
 * @author Sindre Mehus
 * @version $Id$
 */
public class StreamControllerTestCase extends TestCase {

    public void testGetRequestedVideoSize() {
        StreamController controller = new StreamController();

        // Valid spec.
        assertEquals("Wrong size.", new Dimension(123, 456), controller.getRequestedVideoSize("123x456"));
        assertEquals("Wrong size.", new Dimension(456, 123), controller.getRequestedVideoSize("456x123"));
        assertEquals("Wrong size.", new Dimension(1, 1), controller.getRequestedVideoSize("1x1"));

        // Missing spec.
        assertNull("Wrong size.", controller.getRequestedVideoSize(null));

        // Invalid spec.
        assertNull("Wrong size.", controller.getRequestedVideoSize("123"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("123x"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("x123"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("x"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("foo123x456bar"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("foo123x456"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("123x456bar"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("fooxbar"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("-1x1"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("1x-1"));

        // Too large.
        assertNull("Wrong size.", controller.getRequestedVideoSize("3000x100"));
        assertNull("Wrong size.", controller.getRequestedVideoSize("100x3000"));
    }
}
