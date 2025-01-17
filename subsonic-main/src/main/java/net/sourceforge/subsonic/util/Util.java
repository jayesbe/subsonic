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
import java.io.IOException;
import java.io.InputStream;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import com.google.common.io.ByteStreams;

import net.sourceforge.subsonic.Logger;
import net.sourceforge.subsonic.service.SettingsService;

/**
 * Miscellaneous general utility methods.
 *
 * @author Sindre Mehus
 */
public final class Util {

    private static final Logger LOG = Logger.getLogger(Util.class);
    private static final Random RANDOM = new Random(System.currentTimeMillis());

    /**
     * Disallow external instantiation.
     */
    private Util() {
    }

    public static String getDefaultMusicFolder() {
        String def = isWindows() ? "c:\\music" : "/var/music";
        return System.getProperty("subsonic.defaultMusicFolder", def);
    }

    public static String getDefaultPodcastFolder() {
        String def = isWindows() ? "c:\\music\\Podcast" : "/var/music/Podcast";
        return System.getProperty("subsonic.defaultPodcastFolder", def);
    }

    public static String getDefaultPlaylistFolder() {
        String def = isWindows() ? "c:\\playlists" : "/var/playlists";
        return System.getProperty("subsonic.defaultPlaylistFolder", def);
    }

    public static boolean isWindows() {
        return System.getProperty("os.name", "Windows").toLowerCase().startsWith("windows");
    }

    public static boolean isWindowsInstall() {
        return "true".equals(System.getProperty("subsonic.windowsInstall"));
    }

    /**
     * Similar to {@link ServletResponse#setContentLength(int)}, but this
     * method supports lengths bigger than 2GB.
     * <p/>
     * See http://blogger.ziesemer.com/2008/03/suns-version-of-640k-2gb.html
     *
     * @param response The HTTP response.
     * @param length   The content length.
     */
    public static void setContentLength(HttpServletResponse response, long length) {
        if (length <= Integer.MAX_VALUE) {
            response.setContentLength((int) length);
        } else {
            response.setHeader("Content-Length", String.valueOf(length));
        }
    }

    /**
     * Returns the local IP address.  Honours the "subsonic.host" system property.
     * <p/>
     * NOTE: For improved performance, use {@link SettingsService#getLocalIpAddress()} instead.
     *
     * @return The local IP, or the loopback address (127.0.0.1) if not found.
     */
    public static String getLocalIpAddress() {
        List<String> ipAddresses = getLocalIpAddresses();
        String subsonicHost = System.getProperty("subsonic.host");
        if (subsonicHost != null && ipAddresses.contains(subsonicHost)) {
            return subsonicHost;
        }
        return ipAddresses.get(0);
    }

    private static List<String> getLocalIpAddresses() {
        List<String> result = new ArrayList<String>();

        // Try the simple way first.
        try {
            InetAddress address = InetAddress.getLocalHost();
            if (!address.isLoopbackAddress()) {
                result.add(address.getHostAddress());
            }
        } catch (Throwable x) {
            LOG.warn("Failed to resolve local IP address.", x);
        }

        // Iterate through all network interfaces, looking for a suitable IP.
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces.hasMoreElements()) {
                NetworkInterface iface = interfaces.nextElement();
                Enumeration<InetAddress> addresses = iface.getInetAddresses();
                while (addresses.hasMoreElements()) {
                    InetAddress addr = addresses.nextElement();
                    if (addr instanceof Inet4Address && !addr.isLoopbackAddress()) {
                        result.add(addr.getHostAddress());
                    }
                }
            }
        } catch (Throwable x) {
            LOG.warn("Failed to resolve local IP address.", x);
        }

        if (result.isEmpty()) {
            result.add("127.0.0.1");
        }

        return result;
    }

    public static int randomInt(int min, int max) {
        if (min >= max) {
            return 0;
        }
        return min + RANDOM.nextInt(max - min);
    }

    public static <T> Iterable<T> toIterable(final Enumeration<?> e) {
        return new Iterable<T>() {
            public Iterator<T> iterator() {
                return toIterator(e);
            }
        };
    }

    public static <T> Iterator<T> toIterator(final Enumeration<?> e) {
        return new Iterator<T>() {
            public boolean hasNext() {
                return e.hasMoreElements();
            }

            public T next() {
                return (T) e.nextElement();
            }

            public void remove() {
                throw new UnsupportedOperationException();
            }
        };
    }

    public static <T> List<T> subList(List<T> list, long offset, long max) {
        return list.subList((int) offset, Math.min(list.size(), (int) (offset + max)));
    }

    public static List<Integer> toIntegerList(int[] values) {
        if (values == null) {
            return Collections.emptyList();
        }
        List<Integer> result = new ArrayList<Integer>(values.length);
        for (int value : values) {
            result.add(value);
        }
        return result;
    }

    public static int[] toIntArray(List<Integer> values) {
        if (values == null) {
            return new int[0];
        }
        int[] result = new int[values.size()];
        for (int i = 0; i < result.length; i++) {
            result[i] = values.get(i);
        }
        return result;
    }

    public static void sleep(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException e) {
            LOG.error("Sleep interrupted.", e);
        }
    }

    public static InputStream sliceInputStream(InputStream in, HttpRange range) throws IOException {
        if (range == null) {
            return in;
        }
        ByteStreams.skipFully(in, range.getOffset());
        return ByteStreams.limit(in, range.getLength());
    }

    public static Dimension getSuitableVideoSize(Integer existingWidth, Integer existingHeight, Integer maxBitRate) {
        if (maxBitRate == null) {
            return new Dimension(400, 224);
        }

        int w;
        if (maxBitRate < 400) {
            w = 400;
        } else if (maxBitRate < 600) {
            w = 480;
        } else if (maxBitRate < 1800) {
            w = 640;
        } else {
            w = 960;
        }
        int h = even(w * 9 / 16);

        if (existingWidth == null || existingHeight == null) {
            return new Dimension(w, h);
        }

        if (existingWidth < w || existingHeight < h) {
            return new Dimension(even(existingWidth), even(existingHeight));
        }

        double aspectRate = existingWidth.doubleValue() / existingHeight.doubleValue();
        h = (int) Math.round(w / aspectRate);

        return new Dimension(even(w), even(h));
    }

    // Make sure width and height are multiples of two, as some versions of ffmpeg require it.
    private static int even(int size) {
        return size + (size % 2);
    }

}