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
package net.sourceforge.subsonic.androidapp.util;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Handler;
import android.support.v4.app.NotificationCompat;
import android.util.Log;
import android.view.KeyEvent;
import android.widget.RemoteViews;
import net.sourceforge.subsonic.androidapp.R;
import net.sourceforge.subsonic.androidapp.activity.DownloadActivity;
import net.sourceforge.subsonic.androidapp.domain.MusicDirectory;
import net.sourceforge.subsonic.androidapp.provider.SubsonicAppWidgetProvider;
import net.sourceforge.subsonic.androidapp.service.DownloadServiceImpl;

/**
 * @author Sindre Mehus
 * @version $Id$
 */
public final class NotificationUtil {

    private static final String TAG = NotificationUtil.class.getSimpleName();

    public static void updateNotification(final Context context, final DownloadServiceImpl downloadService, Handler handler,
            MusicDirectory.Entry song, boolean playing) {

        if (song == null) {
            hideNotification(downloadService, handler);

        } else {
            Bitmap albumArt;

            // Get the album art.
            try {
                albumArt = FileUtil.getUnscaledAlbumArtBitmap(context, song);
                if (albumArt == null) {
                    albumArt = BitmapFactory.decodeResource(null, R.drawable.unknown_album_large);
                }
            } catch (Exception x) {
                Log.w(TAG, "Failed to get notification cover art", x);
                albumArt = BitmapFactory.decodeResource(null, R.drawable.unknown_album_large);
            }

            Intent notificationIntent = new Intent(context, DownloadActivity.class);


            // TODO: Hide notification if not playing old platforms.

            // On older platforms, show a notification without buttons.
            final Notification notification = useSimpleNotification() ?
                    createSimpleNotification(context, song, albumArt, notificationIntent) :
                    createCustomNotification(context, song, albumArt, notificationIntent, playing);

            // Send the notification and put the service in the foreground.
            handler.post(new Runnable() {
                @Override
                public void run() {
                    downloadService.startForeground(Constants.NOTIFICATION_ID_PLAYING, notification);
                }
            });
        }

        // Update widget
        SubsonicAppWidgetProvider.getInstance().notifyChange(context, downloadService, playing);
    }

    private static void hideNotification(final DownloadServiceImpl downloadService, Handler handler) {

        // Remove notification and remove the service from the foreground
        handler.post(new Runnable() {
            @Override
            public void run() {
                downloadService.stopForeground(true);
            }
        });
    }

    private static Notification createSimpleNotification(Context context, MusicDirectory.Entry song, Bitmap albumArt, Intent notificationIntent) {
        return new NotificationCompat.Builder(context).setOngoing(true)
                .setSmallIcon(R.drawable.stat_notify_playing)
                .setContentTitle(song.getTitle())
                .setContentText(song.getArtist())
                .setContentIntent(PendingIntent.getActivity(context, 0, notificationIntent, 0))
                .setLargeIcon(albumArt)
                .build();
    }

    private static Notification createCustomNotification(Context context, MusicDirectory.Entry song, Bitmap albumArt, Intent notificationIntent, boolean playing) {
        RemoteViews contentView = new RemoteViews(context.getPackageName(), R.layout.notification);
        contentView.setTextViewText(R.id.notification_title, song.getTitle());
        contentView.setTextViewText(R.id.notification_artist, song.getArtist());
        contentView.setImageViewBitmap(R.id.notification_image, albumArt);
        contentView.setImageViewResource(R.id.notification_playpause, playing ? R.drawable.media_pause : R.drawable.media_start);

        Intent intent = new Intent("1");
        intent.setComponent(new ComponentName(context, DownloadServiceImpl.class));
        intent.putExtra(Intent.EXTRA_KEY_EVENT, new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE));
        contentView.setOnClickPendingIntent(R.id.notification_playpause, PendingIntent.getService(context, 0, intent, 0));

        intent = new Intent("2");
        intent.setComponent(new ComponentName(context, DownloadServiceImpl.class));
        intent.putExtra(Intent.EXTRA_KEY_EVENT, new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_MEDIA_NEXT));
        contentView.setOnClickPendingIntent(R.id.notification_next, PendingIntent.getService(context, 0, intent, 0));

        Notification notification = new NotificationCompat.Builder(context)
                .setOngoing(true)
                .setSmallIcon(R.drawable.stat_notify_playing)
                .setContent(contentView)
                .setContentIntent(PendingIntent.getActivity(context, 0, notificationIntent, 0))
                .build();
        if (Build.VERSION.SDK_INT >= 16) {
            notification.bigContentView = createBigContentView(context, song, albumArt, playing);
        }
        return notification;
    }

    private static RemoteViews createBigContentView(Context context, MusicDirectory.Entry song, Bitmap albumArt, boolean playing) {

        RemoteViews contentView = new RemoteViews(context.getPackageName(), R.layout.notification_expanded);
        contentView.setTextViewText(R.id.notification_title, song.getTitle());
        contentView.setTextViewText(R.id.notification_artist, song.getArtist());
        contentView.setTextViewText(R.id.notification_album, song.getAlbum());
        contentView.setImageViewBitmap(R.id.notification_image, albumArt);
        contentView.setImageViewResource(R.id.notification_playpause, playing ? R.drawable.media_pause : R.drawable.media_start);

        Intent intent = new Intent("1");
        intent.setComponent(new ComponentName(context, DownloadServiceImpl.class));
        intent.putExtra(Intent.EXTRA_KEY_EVENT, new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE));
        contentView.setOnClickPendingIntent(R.id.notification_playpause, PendingIntent.getService(context, 0, intent, 0));

        intent = new Intent("2");
        intent.setComponent(new ComponentName(context, DownloadServiceImpl.class));
        intent.putExtra(Intent.EXTRA_KEY_EVENT, new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_MEDIA_NEXT));
        contentView.setOnClickPendingIntent(R.id.notification_next, PendingIntent.getService(context, 0, intent, 0));

        intent = new Intent("3");
        intent.setComponent(new ComponentName(context, DownloadServiceImpl.class));
        intent.putExtra(Intent.EXTRA_KEY_EVENT, new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_MEDIA_PREVIOUS));
        contentView.setOnClickPendingIntent(R.id.notification_prev, PendingIntent.getService(context, 0, intent, 0));

        return contentView;
    }

    private static boolean useSimpleNotification() {
        return Build.VERSION.SDK_INT < 11;
    }
}