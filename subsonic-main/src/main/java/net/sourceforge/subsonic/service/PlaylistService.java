package net.sourceforge.subsonic.service;

import net.sourceforge.subsonic.domain.*;
import net.sourceforge.subsonic.*;

import java.io.*;
import java.util.*;
import java.util.regex.*;

/**
 * Provides services for loading and saving playlists to and from persistent storage.
 *
 * @see Playlist
 * @author Sindre Mehus
 */
public class PlaylistService {

    private static final Logger LOG = Logger.getLogger(PlaylistService.class);

    /**
     * Saves the given playlist to persistent storage.
     * @param playlist The playlist to save.
     * @throws IOException If an I/O error occurs.
     */
    public void savePlaylist(Playlist playlist) throws IOException {
        String name = playlist.getName();

        // Add m3u suffix if playlist name is not *.pls or *.m3u
        if (!new PlaylistFilenameFilter().accept(getPlaylistDirectory(), name)) {
            name += ".m3u";
            playlist.setName(name);
        }

        File playlistFile = new File(getPlaylistDirectory(), name);
        checkAccess(playlistFile);

        PrintWriter writer = new PrintWriter(new FileWriter(playlistFile));
        try {
            PlaylistFormat format = PlaylistFormat.getFilelistFormat(playlistFile);
            format.savePlaylist(playlist, writer);
        } finally {
            writer.close();
        }
    }

    /**
     * Loads a named playlist from persistent storage and into the provided playlist instance.
     * @param playlist The playlist to populate. Any existing entries in the playlist will
     * be removed.
     * @param name The name of a previously persisted playlist.
     * @throws IOException If an I/O error occurs.
     */
    public void loadPlaylist(Playlist playlist, String name) throws IOException {
        File playlistFile = new File(getPlaylistDirectory(), name);
        checkAccess(playlistFile);

        playlist.setName(name);

        BufferedReader reader = new BufferedReader(new FileReader(playlistFile));
        try {
            PlaylistFormat format = PlaylistFormat.getFilelistFormat(playlistFile);
            format.loadPlaylist(playlist, reader);
        } finally {
            reader.close();
        }
    }

    /**
     * Returns a list of all previously saved playlists.
     * @return A list of all previously saved playlists.
     */
    public File[] getSavedPlaylists() {
        List<File> result = new ArrayList<File>();
        File[] candidates = getPlaylistDirectory().listFiles(new PlaylistFilenameFilter());

        // Happens if playlist directory is non-existing.
        if (candidates == null) {
            return new File[0];
        }

        for (File candidate : candidates) {
            result.add(candidate);
        }
        return result.toArray(new File[0]);
    }

    /**
     * Deletes the named playlist from persistent storage.
     * @param name The name of the playlist to delete.
     * @throws IOException If an I/O error occurs.
     */
    public void deletePlaylist(String name) throws IOException {
        File file = new File(getPlaylistDirectory(), name);
        checkAccess(file);
        file.delete();
    }

    /**
     * Returns the directory where playlists are stored.
     * @return The directory where playlists are stored.
     */
    public File getPlaylistDirectory() {
        return new File(ServiceFactory.getSettingsService().getPlaylistFolder());
    }

    private void checkAccess(File file) {
        if (!ServiceFactory.getSecurityService().isWriteAllowed(file)) {
            throw new SecurityException("Access denied to file " + file);
        }
    }

    private static class PlaylistFilenameFilter implements FilenameFilter {
        public boolean accept(File dir, String name) {
            name = name.toLowerCase();
            return name.endsWith(".m3u") || name.endsWith(".pls");
        }
    }

    /**
     * Abstract superclass for playlist formats.
     */
    private static abstract class PlaylistFormat {
        public abstract void loadPlaylist(Playlist playlist, BufferedReader reader) throws IOException;
        public abstract void savePlaylist(Playlist playlist, PrintWriter writer) throws IOException;
        public static PlaylistFormat getFilelistFormat(File file) {
            String name = file.getName().toLowerCase();
            if (name.endsWith(".m3u")) {
                return new M3UFormat();
            }
            if (name.endsWith(".pls")) {
                return new PLSFormat();
            }
            return null;
        }
    }

    /**
     * Implementation of M3U playlist format.
     */
    private static class M3UFormat extends PlaylistFormat {
        public void loadPlaylist(Playlist playlist, BufferedReader reader) throws IOException {
            playlist.clear();
            String line = reader.readLine();
            while (line != null) {
                if (!line.startsWith("#")) {
                    try {
                        MusicFile file = new MusicFile(new File(line));
                        if (file.exists()) {
                            playlist.addFile(file);
                        }
                    } catch (SecurityException x) {
                        LOG.warn(x.getMessage(), x);
                    }
                }
                line = reader.readLine();
            }
        }

        public void savePlaylist(Playlist playlist, PrintWriter writer) throws IOException {
            writer.println("#EXTM3U");
            for (MusicFile file : playlist.getFiles()) {
                writer.println(file.getPath());
            }
            if (writer.checkError()) {
                throw new IOException("Error when writing playlist " + playlist.getName());
            }
        }
    }

    /**
     * Implementation of PLS playlist format.
     */
    private static class PLSFormat extends PlaylistFormat {
        public void loadPlaylist(Playlist playlist, BufferedReader reader) throws IOException {
            playlist.clear();

            Pattern pattern = Pattern.compile("^File\\d+=(.*)$");
            String line = reader.readLine();
            while (line != null) {

                Matcher matcher = pattern.matcher(line);
                if (matcher.find()) {
                    try {
                        MusicFile file = new MusicFile(new File(matcher.group(1)));
                        if (file.exists()) {
                            playlist.addFile(file);
                        }
                    } catch (SecurityException x) {
                        LOG.warn(x.getMessage(), x);
                    }
                }
                line = reader.readLine();
            }
        }

        public void savePlaylist(Playlist playlist, PrintWriter writer) throws IOException {
            writer.println("[playlist]");
            int counter = 0;

            for (MusicFile file : playlist.getFiles()) {
                counter++;
                writer.println("File" + counter + '=' + file.getPath());
            }
            writer.println("NumberOfEntries=" + counter);
            writer.println("Version=2");

            if (writer.checkError()) {
                throw new IOException("Error when writing playlist " + playlist.getName());
            }
        }
    }
}
