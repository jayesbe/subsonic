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

package net.sourceforge.subsonic.service.sonos;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.bind.ServletRequestUtils;

import com.google.common.base.Predicate;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.sonos.services._1.AbstractMedia;
import com.sonos.services._1.AlbumArtUrl;
import com.sonos.services._1.ItemType;
import com.sonos.services._1.MediaCollection;
import com.sonos.services._1.MediaList;
import com.sonos.services._1.MediaMetadata;
import com.sonos.services._1.TrackMetadata;

import net.sourceforge.subsonic.controller.CoverArtController;
import net.sourceforge.subsonic.dao.MediaFileDao;
import net.sourceforge.subsonic.domain.AlbumListType;
import net.sourceforge.subsonic.domain.ArtistBio;
import net.sourceforge.subsonic.domain.CoverArtScheme;
import net.sourceforge.subsonic.domain.Genre;
import net.sourceforge.subsonic.domain.MediaFile;
import net.sourceforge.subsonic.domain.MusicFolder;
import net.sourceforge.subsonic.domain.MusicFolderContent;
import net.sourceforge.subsonic.domain.MusicIndex;
import net.sourceforge.subsonic.domain.Player;
import net.sourceforge.subsonic.domain.PlayerTechnology;
import net.sourceforge.subsonic.domain.Playlist;
import net.sourceforge.subsonic.domain.PodcastChannel;
import net.sourceforge.subsonic.domain.PodcastEpisode;
import net.sourceforge.subsonic.domain.PodcastStatus;
import net.sourceforge.subsonic.domain.SearchCriteria;
import net.sourceforge.subsonic.domain.SearchResult;
import net.sourceforge.subsonic.service.LastFmService;
import net.sourceforge.subsonic.service.MediaFileService;
import net.sourceforge.subsonic.service.MusicIndexService;
import net.sourceforge.subsonic.service.PlayerService;
import net.sourceforge.subsonic.service.PlaylistService;
import net.sourceforge.subsonic.service.PodcastService;
import net.sourceforge.subsonic.service.RatingService;
import net.sourceforge.subsonic.service.SearchService;
import net.sourceforge.subsonic.service.SettingsService;
import net.sourceforge.subsonic.service.SonosService;
import net.sourceforge.subsonic.service.TranscodingService;
import net.sourceforge.subsonic.util.StringUtil;
import net.sourceforge.subsonic.util.Util;

/**
 * @author Sindre Mehus
 * @version $Id$
 */
public class SonosHelper {

    public static final String SUBSONIC_CLIENT_ID = "sonos";

    private MediaFileService mediaFileService;
    private PlaylistService playlistService;
    private PlayerService playerService;
    private TranscodingService transcodingService;
    private SettingsService settingsService;
    private MusicIndexService musicIndexService;
    private SearchService searchService;
    private MediaFileDao mediaFileDao;
    private RatingService ratingService;
    private LastFmService lastFmService;
    private PodcastService podcastService;

    public List<AbstractMedia> forRoot() {
        MediaMetadata shuffle = new MediaMetadata();
        shuffle.setItemType(ItemType.PROGRAM);
        shuffle.setId(SonosService.ID_SHUFFLE);
        shuffle.setTitle("Shuffle Play");

        MediaCollection library = new MediaCollection();
        library.setItemType(ItemType.COLLECTION);
        library.setId(SonosService.ID_LIBRARY);
        library.setTitle("Browse Library");

        MediaCollection playlists = new MediaCollection();
        playlists.setItemType(ItemType.ALBUM_LIST);
        playlists.setId(SonosService.ID_PLAYLISTS);
        playlists.setTitle("Playlists");
        playlists.setUserContent(true);
        playlists.setReadOnly(false);

        MediaCollection starred = new MediaCollection();
        starred.setItemType(ItemType.FAVORITES);
        starred.setId(SonosService.ID_STARRED);
        starred.setTitle("Starred");

        MediaCollection albumlists = new MediaCollection();
        albumlists.setItemType(ItemType.COLLECTION);
        albumlists.setId(SonosService.ID_ALBUMLISTS);
        albumlists.setTitle("Album Lists");

        MediaCollection podcasts = new MediaCollection();
        podcasts.setItemType(ItemType.ALBUM_LIST);
        podcasts.setId(SonosService.ID_PODCASTS);
        podcasts.setTitle("Podcasts");

        return Arrays.asList(shuffle, library, playlists, starred, albumlists, podcasts);
    }

    public List<AbstractMedia> forShuffle(int count, String username, HttpServletRequest request) {
        return forShuffleMusicFolder(settingsService.getMusicFoldersForUser(username), count, username, request);
    }

    public List<AbstractMedia> forShuffleMusicFolder(int id, int count, String username, HttpServletRequest request) {
        return forShuffleMusicFolder(settingsService.getMusicFoldersForUser(username, id), count, username, request);
    }

    private List<AbstractMedia> forShuffleMusicFolder(List<MusicFolder> musicFolders, int count, String username, HttpServletRequest request) {
        List<MediaFile> albums = searchService.getRandomAlbums(40, musicFolders);
        List<MediaFile> songs = new ArrayList<MediaFile>();
        for (MediaFile album : albums) {
            for (MediaFile file : filterMusic(mediaFileService.getChildrenOf(album, true, false, false))) {
                songs.add(file);
            }
        }
        Collections.shuffle(songs);
        songs = songs.subList(0, Math.min(count, songs.size()));
        return forMediaFiles(songs, username, request);
    }

    public List<AbstractMedia> forShuffleArtist(int mediaFileId, int count, String username, HttpServletRequest request) {
        MediaFile artist = mediaFileService.getMediaFile(mediaFileId);
        List<MediaFile> songs = filterMusic(mediaFileService.getDescendantsOf(artist, false));
        Collections.shuffle(songs);
        songs = songs.subList(0, Math.min(count, songs.size()));
        return forMediaFiles(songs, username, request);
    }

    public List<AbstractMedia> forShuffleAlbumList(AlbumListType albumListType, int count, String username, HttpServletRequest request) {
        AlbumList albumList = createAlbumList(albumListType, 0, 40, username);

        List<MediaFile> songs = new ArrayList<MediaFile>();
        for (MediaFile album : albumList.getAlbums()) {
            songs.addAll(filterMusic(mediaFileService.getChildrenOf(album, true, false, false)));
        }
        Collections.shuffle(songs);
        songs = songs.subList(0, Math.min(count, songs.size()));
        return forMediaFiles(songs, username, request);
    }

    public List<AbstractMedia> forRadioArtist(int mediaFileId, int count, String username, HttpServletRequest request) {
        MediaFile artist = mediaFileService.getMediaFile(mediaFileId);
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        List<MediaFile> songs = filterMusic(lastFmService.getSimilarSongs(artist, count, musicFolders));
        Collections.shuffle(songs);
        songs = songs.subList(0, Math.min(count, songs.size()));
        return forMediaFiles(songs, username, request);
    }

    public List<AbstractMedia> forTopSongs(int mediaFileId, String username, HttpServletRequest request) {
        MediaFile artist = mediaFileService.getMediaFile(mediaFileId);
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        List<MediaFile> songs = filterMusic(lastFmService.getTopSongs(artist, 100, musicFolders));
        return forMediaFiles(songs, username, request);
    }

    public List<AbstractMedia> forLibrary(String username, HttpServletRequest request) {
        List<AbstractMedia> result = new ArrayList<AbstractMedia>();

        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        if (musicFolders.size() == 1) {
            return forMusicFolder(musicFolders.get(0), username, request);
        }

        for (MusicFolder musicFolder : musicFolders) {
            MediaCollection mediaCollection = new MediaCollection();
            mediaCollection.setItemType(ItemType.COLLECTION);
            mediaCollection.setId(SonosService.ID_MUSICFOLDER_PREFIX + musicFolder.getId());
            mediaCollection.setTitle(musicFolder.getName());
            result.add(mediaCollection);
        }
        return result;
    }

    public List<AbstractMedia> forMusicFolder(int musicFolderId, String username, HttpServletRequest request) {
        return forMusicFolder(settingsService.getMusicFolderById(musicFolderId), username, request);
    }

    public List<AbstractMedia> forMusicFolder(MusicFolder musicFolder, String username, HttpServletRequest request) {
        try {
            List<AbstractMedia> result = new ArrayList<AbstractMedia>();

            MediaMetadata shuffle = new MediaMetadata();
            shuffle.setItemType(ItemType.PROGRAM);
            shuffle.setId(SonosService.ID_SHUFFLE_MUSICFOLDER_PREFIX + musicFolder.getId());
            shuffle.setTitle("Shuffle Play");
            result.add(shuffle);

            for (MediaFile shortcut : musicIndexService.getShortcuts(Arrays.asList(musicFolder))) {
                result.add(forDirectory(shortcut, request, username));
            }

            MusicFolderContent musicFolderContent = musicIndexService.getMusicFolderContent(Arrays.asList(musicFolder), false);
            for (List<MusicIndex.SortableArtistWithMediaFiles> artists : musicFolderContent.getIndexedArtists().values()) {
                for (MusicIndex.SortableArtistWithMediaFiles artist : artists) {
                    for (MediaFile artistMediaFile : artist.getMediaFiles()) {
                        result.add(forDirectory(artistMediaFile, request, username));
                    }
                }
            }
            for (MediaFile song : musicFolderContent.getSingleSongs()) {
                if (song.isAudio()) {
                    result.add(forSong(song, username, request));
                }
            }
            return result;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<AbstractMedia> forDirectoryContent(int mediaFileId, String username, HttpServletRequest request) {
        List<AbstractMedia> result = new ArrayList<AbstractMedia>();
        MediaFile dir = mediaFileService.getMediaFile(mediaFileId);
        List<MediaFile> children = dir.isFile() ? Arrays.asList(dir) : mediaFileService.getChildrenOf(dir, true, true, true);
        boolean isArtist = true;
        for (MediaFile child : children) {
            if (child.isDirectory()) {
                result.add(forDirectory(child, request, username));
                isArtist &= child.isAlbum();
            } else if (child.isAudio()) {
                isArtist = false;
                result.add(forSong(child, username, request));
            }
        }

        if (isArtist) {
            MediaMetadata shuffle = new MediaMetadata();
            shuffle.setItemType(ItemType.PROGRAM);
            shuffle.setId(SonosService.ID_SHUFFLE_ARTIST_PREFIX + mediaFileId);
            shuffle.setTitle(String.format("Shuffle Play  - %s", dir.getName()));
            result.add(0, shuffle);

            MediaMetadata radio = new MediaMetadata();
            radio.setItemType(ItemType.PROGRAM);
            radio.setId(SonosService.ID_RADIO_ARTIST_PREFIX + mediaFileId);
            radio.setTitle(String.format("Artist Radio - %s", dir.getName()));
            result.add(1, radio);

            MediaCollection topSongs = new MediaCollection();
            topSongs.setItemType(ItemType.TRACK);
            topSongs.setCanPlay(true);
            topSongs.setId(SonosService.ID_TOP_SONGS_PREFIX + mediaFileId);
            topSongs.setTitle(String.format("Top Songs - %s", dir.getName()));
            result.add(2, topSongs);
        }

        return result;
    }

    private MediaCollection forDirectory(MediaFile dir, HttpServletRequest request, String username) {
        mediaFileService.populateStarredDate(dir, username);
        MediaCollection mediaCollection = new MediaCollection();

        mediaCollection.setId(String.valueOf(dir.getId()));
        mediaCollection.setIsFavorite(dir.getStarredDate() != null);
        if (dir.isAlbum()) {
            mediaCollection.setItemType(ItemType.ALBUM);
            mediaCollection.setArtist(dir.getArtist());
            mediaCollection.setTitle(dir.getName());
            mediaCollection.setCanPlay(true);

            AlbumArtUrl albumArtUrl = new AlbumArtUrl();
            albumArtUrl.setValue(getCoverArtUrl(dir, request));
            mediaCollection.setAlbumArtURI(albumArtUrl);
        } else {
            mediaCollection.setItemType(ItemType.ARTIST);
            mediaCollection.setTitle(dir.getName());

            if (lastFmService.isArtistBioCached(dir.getName())) {
                ArtistBio artistBio = lastFmService.getArtistBio(dir);
                if (artistBio != null && artistBio.getSmallImageUrl() != null) {
                    AlbumArtUrl artistImageUrl = new AlbumArtUrl();
                    artistImageUrl.setValue(artistBio.getMediumImageUrl());
                    mediaCollection.setAlbumArtURI(artistImageUrl);
                }
            }
        }
        return mediaCollection;
    }

    public List<MediaCollection> forPlaylists(String username, HttpServletRequest request) {
        List<MediaCollection> result = new ArrayList<MediaCollection>();
        for (Playlist playlist : playlistService.getReadablePlaylistsForUser(username)) {
            MediaCollection mediaCollection = new MediaCollection();
            AlbumArtUrl albumArtUrl = new AlbumArtUrl();
            albumArtUrl.setValue(getCoverArtUrl(CoverArtController.PLAYLIST_COVERART_PREFIX + playlist.getId(), request));

            mediaCollection.setId(SonosService.ID_PLAYLIST_PREFIX + playlist.getId());
            mediaCollection.setCanPlay(true);
            mediaCollection.setReadOnly(!username.equals(playlist.getUsername()));
            mediaCollection.setRenameable(username.equals(playlist.getUsername()));
            mediaCollection.setUserContent(false);
            mediaCollection.setItemType(ItemType.PLAYLIST);
            mediaCollection.setArtist(playlist.getUsername());
            mediaCollection.setTitle(playlist.getName());
            mediaCollection.setAlbumArtURI(albumArtUrl);
            result.add(mediaCollection);
        }
        return result;
    }

    public List<MediaCollection> forAlbumLists() {
        List<MediaCollection> result = new ArrayList<MediaCollection>();

        for (AlbumListType albumListType : AlbumListType.values()) {
            MediaCollection mediaCollection = new MediaCollection();
            mediaCollection.setId(SonosService.ID_ALBUMLIST_PREFIX + albumListType.getId());
            mediaCollection.setItemType(ItemType.ALBUM_LIST);
            mediaCollection.setTitle(albumListType.getDescription());
            result.add(mediaCollection);
        }
        return result;
    }

    public List<MediaCollection> forPodcastChannels(HttpServletRequest request) {
        List<MediaCollection> result = new ArrayList<MediaCollection>();
        for (PodcastChannel channel : podcastService.getAllChannels()) {
            AlbumArtUrl albumArtUri = new AlbumArtUrl();
            albumArtUri.setValue(getCoverArtUrl(CoverArtController.PODCAST_COVERART_PREFIX + channel.getId(), request));

            MediaCollection mediaCollection = new MediaCollection();
            mediaCollection.setId(SonosService.ID_PODCAST_CHANNEL_PREFIX + channel.getId());
            mediaCollection.setTitle(channel.getTitle());
            mediaCollection.setItemType(ItemType.TRACK);
            mediaCollection.setAlbumArtURI(albumArtUri);
            result.add(mediaCollection);
        }
        return result;
    }

    public List<AbstractMedia> forPodcastChannel(int channelId, String username, HttpServletRequest request) {
        List<AbstractMedia> result = new ArrayList<AbstractMedia>();
        for (PodcastEpisode episode : podcastService.getEpisodes(channelId)) {
            if (episode.getStatus() == PodcastStatus.COMPLETED) {
                Integer mediaFileId = episode.getMediaFileId();
                MediaFile mediaFile = mediaFileService.getMediaFile(mediaFileId);
                if (mediaFile != null) {
                    result.add(forMediaFile(mediaFile, username, request));
                }
            }
        }
        return result;
    }

    public MediaList forAlbumList(AlbumListType albumListType, int offset, int count, String username, HttpServletRequest request) {
        if (albumListType == AlbumListType.DECADE) {
            return forDecades(offset, count);
        }
        if (albumListType == AlbumListType.GENRE) {
            return forGenres(offset, count);
        }

        MediaList mediaList = new MediaList();

        boolean includeShuffle = offset == 0;
        if (includeShuffle) {
            count--;
            MediaMetadata shuffle = new MediaMetadata();
            shuffle.setItemType(ItemType.PROGRAM);
            shuffle.setId(SonosService.ID_SHUFFLE_ALBUMLIST_PREFIX + albumListType.getId());
            shuffle.setTitle(String.format("Shuffle Play - %s", albumListType.getDescription()));
            mediaList.getMediaCollectionOrMediaMetadata().add(shuffle);
        }

        AlbumList albumList = createAlbumList(albumListType, offset - (includeShuffle ? 0 : 1), count, username);
        for (MediaFile album : albumList.getAlbums()) {
            mediaList.getMediaCollectionOrMediaMetadata().add(forDirectory(album, request, username));
        }

        mediaList.setIndex(offset);
        mediaList.setCount(mediaList.getMediaCollectionOrMediaMetadata().size());
        mediaList.setTotal(albumList.getTotal() + 1);
        return mediaList;
    }

    private AlbumList createAlbumList(AlbumListType albumListType, int offset, int count, String username) {
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        List<MediaFile> albums = Collections.emptyList();
        int total = 0;
        switch (albumListType) {
            case RANDOM:
                albums = searchService.getRandomAlbums(count, musicFolders);
                total = mediaFileService.getAlbumCount(musicFolders);
                break;
            case NEWEST:
                albums = mediaFileService.getNewestAlbums(offset, count, musicFolders);
                total = mediaFileService.getAlbumCount(musicFolders);
                break;
            case STARRED:
                albums = mediaFileService.getStarredAlbums(offset, count, username, musicFolders);
                total = mediaFileService.getStarredAlbumCount(username, musicFolders);
                break;
            case HIGHEST:
                albums = ratingService.getHighestRatedAlbumsForUser(offset, count, username, musicFolders);
                total = ratingService.getRatedAlbumCount(username, musicFolders);
                break;
            case FREQUENT:
                albums = mediaFileService.getMostFrequentlyPlayedAlbums(offset, count, musicFolders);
                total = mediaFileService.getPlayedAlbumCount(musicFolders);
                break;
            case RECENT:
                albums = mediaFileService.getMostRecentlyPlayedAlbums(offset, count, musicFolders);
                total = mediaFileService.getPlayedAlbumCount(musicFolders);
                break;
            case ALPHABETICAL:
                albums = mediaFileService.getAlphabeticalAlbums(offset, count, true, musicFolders);
                total = mediaFileService.getAlbumCount(musicFolders);
                break;
        }
        return new AlbumList(albums, total);
    }

    private MediaList forDecades(int offset, int count) {
        List<MediaCollection> mediaCollections = new ArrayList<MediaCollection>();
        int currentDecade = Calendar.getInstance().get(Calendar.YEAR) / 10;
        for (int i = 0; i < 10; i++) {
            int decade = (currentDecade - i) * 10;
            MediaCollection mediaCollection = new MediaCollection();
            mediaCollection.setItemType(ItemType.ALBUM_LIST);
            mediaCollection.setId(SonosService.ID_DECADE_PREFIX + decade);
            mediaCollection.setTitle(String.valueOf(decade));
            mediaCollections.add(mediaCollection);
        }

        return createSubList(offset, count, mediaCollections);
    }

    private MediaList forGenres(int offset, int count) {
        List<MediaCollection> mediaCollections = new ArrayList<MediaCollection>();
        List<Genre> genres = mediaFileService.getGenres(true);
        for (int i = 0; i < genres.size(); i++) {
            Genre genre = genres.get(i);
            MediaCollection mediaCollection = new MediaCollection();
            mediaCollection.setItemType(ItemType.ALBUM_LIST);
            mediaCollection.setId(SonosService.ID_GENRE_PREFIX + i);
            mediaCollection.setTitle(genre.getName() + " (" + genre.getAlbumCount() + ")");
            mediaCollections.add(mediaCollection);
        }

        return createSubList(offset, count, mediaCollections);
    }

    public List<MediaCollection> forDecade(int decade, String username, HttpServletRequest request) {
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        List<MediaCollection> result = new ArrayList<MediaCollection>();
        for (MediaFile album : mediaFileService.getAlbumsByYear(0, Integer.MAX_VALUE, decade, decade + 9, musicFolders)) {
            result.add(forDirectory(album, request, username));
        }
        return result;
    }

    public List<MediaCollection> forGenre(int genreIndex, String username, HttpServletRequest request) {
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        Genre genre = mediaFileService.getGenres(true).get(genreIndex);
        List<MediaCollection> result = new ArrayList<MediaCollection>();
        for (MediaFile album : mediaFileService.getAlbumsByGenre(0, Integer.MAX_VALUE, genre.getName(), musicFolders)) {
            result.add(forDirectory(album, request, username));
        }
        return result;
    }

    public List<MediaMetadata> forPlaylist(int playlistId, String username, HttpServletRequest request) {
        List<MediaMetadata> result = new ArrayList<MediaMetadata>();
        for (MediaFile song : playlistService.getFilesInPlaylist(playlistId)) {
            if (song.isAudio()) {
                result.add(forSong(song, username, request));
            }
        }
        return result;
    }

    public List<MediaCollection> forStarred() {
        MediaCollection artists = new MediaCollection();
        artists.setItemType(ItemType.ARTIST);
        artists.setId(SonosService.ID_STARRED_ARTISTS);
        artists.setTitle("Starred Artists");

        MediaCollection albums = new MediaCollection();
        albums.setItemType(ItemType.ALBUM_LIST);
        albums.setId(SonosService.ID_STARRED_ALBUMS);
        albums.setTitle("Starred Albums");

        MediaCollection songs = new MediaCollection();
        songs.setItemType(ItemType.TRACK_LIST);
        songs.setId(SonosService.ID_STARRED_SONGS);
        songs.setCanPlay(true);
        songs.setTitle("Starred Songs");

        return Arrays.asList(artists, albums, songs);
    }

    public List<MediaCollection> forStarredArtists(String username, HttpServletRequest request) {
        List<MediaCollection> result = new ArrayList<MediaCollection>();
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        for (MediaFile artist : mediaFileDao.getStarredDirectories(0, Integer.MAX_VALUE, username, musicFolders)) {
            MediaCollection mediaCollection = forDirectory(artist, request, username);
            mediaCollection.setItemType(ItemType.ARTIST);
            result.add(mediaCollection);
        }
        return result;
    }

    public List<MediaCollection> forStarredAlbums(String username, HttpServletRequest request) {
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        List<MediaCollection> result = new ArrayList<MediaCollection>();
        for (MediaFile album : mediaFileDao.getStarredAlbums(0, Integer.MAX_VALUE, username, musicFolders)) {
            MediaCollection mediaCollection = forDirectory(album, request, username);
            mediaCollection.setItemType(ItemType.ALBUM);
            result.add(mediaCollection);
        }
        return result;
    }

    public List<MediaMetadata> forStarredSongs(String username, HttpServletRequest request) {
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        List<MediaMetadata> result = new ArrayList<MediaMetadata>();
        for (MediaFile song : mediaFileDao.getStarredFiles(0, Integer.MAX_VALUE, username, musicFolders)) {
            if (song.isAudio()) {
                result.add(forSong(song, username, request));
            }
        }
        return result;
    }

    public List<MediaCollection> forSearchCategories() {
        MediaCollection artists = new MediaCollection();
        artists.setItemType(ItemType.ARTIST);
        artists.setId(SonosService.ID_SEARCH_ARTISTS);
        artists.setTitle("Artists");

        MediaCollection albums = new MediaCollection();
        albums.setItemType(ItemType.ALBUM);
        albums.setId(SonosService.ID_SEARCH_ALBUMS);
        albums.setTitle("Albums");

        MediaCollection songs = new MediaCollection();
        songs.setItemType(ItemType.TRACK);
        songs.setId(SonosService.ID_SEARCH_SONGS);
        songs.setTitle("Songs");

        return Arrays.asList(artists, albums, songs);
    }

    public MediaList forSearch(String query, int offset, int count, SearchService.IndexType indexType, String username, HttpServletRequest request) {

        SearchCriteria searchCriteria = new SearchCriteria();
        searchCriteria.setCount(count);
        searchCriteria.setOffset(offset);
        searchCriteria.setQuery(query);
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);

        SearchResult searchResult = searchService.search(searchCriteria, musicFolders, indexType);

        MediaList result = new MediaList();
        result.setTotal(searchResult.getTotalHits());
        result.setIndex(offset);
        result.setCount(searchResult.getMediaFiles().size());
        for (MediaFile mediaFile : searchResult.getMediaFiles()) {
            result.getMediaCollectionOrMediaMetadata().add(forMediaFile(mediaFile, username, request));
        }

        return result;
    }

    public List<AbstractMedia> forSimilarArtists(int mediaFileId, String username, HttpServletRequest request) {
        MediaFile mediaFile = mediaFileService.getMediaFile(mediaFileId);
        List<MusicFolder> musicFolders = settingsService.getMusicFoldersForUser(username);
        List<MediaFile> similarArtists = lastFmService.getSimilarArtists(mediaFile, 100, false, musicFolders);
        return forMediaFiles(similarArtists, username, request);
    }

    private List<AbstractMedia> forMediaFiles(List<MediaFile> mediaFiles, String username, HttpServletRequest request) {
        List<AbstractMedia> result = new ArrayList<AbstractMedia>();
        for (MediaFile mediaFile : mediaFiles) {
            result.add(forMediaFile(mediaFile, username, request));
        }
        return result;
    }

    public AbstractMedia forMediaFile(MediaFile mediaFile, String username, HttpServletRequest request) {
        return mediaFile.isFile() ? forSong(mediaFile, username, request) : forDirectory(mediaFile, request, username);
    }

    public MediaMetadata forSong(MediaFile song, String username, HttpServletRequest request) {
        Player player = createPlayerIfNecessary(username);
        String suffix = transcodingService.getSuffix(player, song, null);
        mediaFileService.populateStarredDate(song, username);

        MediaMetadata result = new MediaMetadata();
        result.setId(String.valueOf(song.getId()));
        result.setItemType(ItemType.TRACK);
        result.setMimeType(StringUtil.getMimeType(suffix, true));
        result.setTitle(song.getTitle());
        result.setGenre(song.getGenre());
        result.setIsFavorite(song.getStarredDate() != null);
//        result.setDynamic();// TODO: For starred songs

        AlbumArtUrl albumArtUrl = new AlbumArtUrl();
        albumArtUrl.setValue(getCoverArtUrl(song, request));

        TrackMetadata trackMetadata = new TrackMetadata();
        trackMetadata.setArtist(song.getArtist());
        trackMetadata.setAlbumArtist(song.getAlbumArtist());
        trackMetadata.setAlbum(song.getAlbumName());
        trackMetadata.setAlbumArtURI(albumArtUrl);
        trackMetadata.setDuration(song.getDurationSeconds());
        trackMetadata.setTrackNumber(song.getTrackNumber());

        MediaFile parent = mediaFileService.getParentOf(song);
        if (parent != null && parent.isAlbum()) {
            trackMetadata.setAlbumId(String.valueOf(parent.getId()));
        }
        result.setTrackMetadata(trackMetadata);

        return result;
    }

    public void star(int id, String username) {
        mediaFileDao.starMediaFile(id, username);
    }

    public void unstar(int id, String username) {
        mediaFileDao.unstarMediaFile(id, username);
    }

    private String getCoverArtUrl(String id, HttpServletRequest request) {
        return getBaseUrl(request) + "coverArt.view?id=" + id + "&size=" + CoverArtScheme.LARGE.getSize();
    }

    private String getCoverArtUrl(MediaFile file, HttpServletRequest request) {
        return getBaseUrl(request) + "coverArt.view?id=" + file.getId() + "&auth=" + file.getHash() + "&size=" + CoverArtScheme.LARGE.getSize();
    }

    public static MediaList createSubList(int index, int count, List<? extends AbstractMedia> media) {
        MediaList result = new MediaList();
        List<? extends AbstractMedia> selectedMedia = Util.subList(media, index, count);

        result.setIndex(index);
        result.setCount(selectedMedia.size());
        result.setTotal(media.size());
        result.getMediaCollectionOrMediaMetadata().addAll(selectedMedia);

        return result;
    }

    private List<MediaFile> filterMusic(List<MediaFile> files) {
        return Lists.newArrayList(Iterables.filter(files, new Predicate<MediaFile>() {
            @Override
            public boolean apply(MediaFile input) {
                return input.getMediaType() == MediaFile.MediaType.MUSIC;
            }
        }));
    }

    public void setPlaylistService(PlaylistService playlistService) {
        this.playlistService = playlistService;
    }

    public void setPlayerService(PlayerService playerService) {
        this.playerService = playerService;
    }

    public void setTranscodingService(TranscodingService transcodingService) {
        this.transcodingService = transcodingService;
    }

    public String getMediaURI(int mediaFileId, String username, HttpServletRequest request) {
        Player player = createPlayerIfNecessary(username);
        MediaFile song = mediaFileService.getMediaFile(mediaFileId);

        return getBaseUrl(request) + "stream?id=" + song.getId() + "&auth=" + song.getHash() + "&player=" + player.getId();
    }

    private Player createPlayerIfNecessary(String username) {
        List<Player> players = playerService.getPlayersForUserAndClientId(username, SUBSONIC_CLIENT_ID);

        // If not found, create it.
        if (players.isEmpty()) {
            Player player = new Player();
            player.setUsername(username);
            player.setClientId(SUBSONIC_CLIENT_ID);
            player.setName("Sonos");
            player.setTechnology(PlayerTechnology.EXTERNAL_WITH_PLAYLIST);
            playerService.createPlayer(player);
            players = playerService.getPlayersForUserAndClientId(username, SUBSONIC_CLIENT_ID);
        }

        return players.get(0);
    }

    public String getBaseUrl(HttpServletRequest request) {
        int port = settingsService.getPort();
        String contextPath = settingsService.getUrlRedirectContextPath();

        // Note that the server IP can be overridden by the "ip" parameter. Used when Subsonic and Sonos are
        // on different networks.
        String ip = settingsService.getLocalIpAddress();
        if (request != null) {
            ip = ServletRequestUtils.getStringParameter(request, "ip", ip);
        }

        // Note: Serving media and cover art with http (as opposed to https) works when using jetty and SubsonicDeployer.
        StringBuilder url = new StringBuilder("http://")
                .append(ip)
                .append(":")
                .append(port)
                .append("/");

        if (StringUtils.isNotEmpty(contextPath)) {
            url.append(contextPath).append("/");
        }
        return url.toString();
    }

    public void setMediaFileService(MediaFileService mediaFileService) {
        this.mediaFileService = mediaFileService;
    }

    public void setSettingsService(SettingsService settingsService) {
        this.settingsService = settingsService;
    }

    public void setMusicIndexService(MusicIndexService musicIndexService) {
        this.musicIndexService = musicIndexService;
    }

    public void setMediaFileDao(MediaFileDao mediaFileDao) {
        this.mediaFileDao = mediaFileDao;
    }

    public void setSearchService(SearchService searchService) {
        this.searchService = searchService;
    }

    public void setRatingService(RatingService ratingService) {
        this.ratingService = ratingService;
    }

    public void setLastFmService(LastFmService lastFmService) {
        this.lastFmService = lastFmService;
    }

    public void setPodcastService(PodcastService podcastService) {
        this.podcastService = podcastService;
    }
}
