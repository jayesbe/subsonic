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

package net.sourceforge.subsonic.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.NavigableMap;
import java.util.Random;
import java.util.TreeMap;

import net.sourceforge.subsonic.Logger;
import net.sourceforge.subsonic.dao.AudioAdDao;
import net.sourceforge.subsonic.domain.AudioAd;
import net.sourceforge.subsonic.domain.MediaFile;

/**
 * @author Sindre Mehus
 * @version $Id$
 */
public class AudioAdService {

    private static final Logger LOG = Logger.getLogger(AudioAdService.class);

    private AudioAdDao audioAdDao;
    private SettingsService settingsService;
    private final Random random = new Random(System.currentTimeMillis());

    public void setAudioAdDao(AudioAdDao audioAdDao) {
        this.audioAdDao = audioAdDao;
    }

    public List<MediaFile> addAudioAds(List<MediaFile> files) {
        if (!settingsService.isAudioAdEnabled()) {
            return files;
        }

        List<MediaFile> result = new ArrayList<MediaFile>();
        double frequency = settingsService.getAudioAdFrequency();
        for (MediaFile file : files) {
            result.add(file);
            if (random.nextDouble() < frequency) {
                MediaFile ad = getRandomAd();
                if (ad != null) {
                    result.add(ad);
                }
            }
        }
        return result;
    }

    private MediaFile getRandomAd() {
        List<AudioAd> ads = audioAdDao.getAllAudioAds(false);
        if (ads.isEmpty()) {
            return null;
        }

        NavigableMap<Double, AudioAd> map = new TreeMap<Double, AudioAd>();
        double weightSum = 0;
        for (AudioAd ad : ads) {
            if (ad.getWeight() > 0.0) {
                weightSum += ad.getWeight();
                map.put(weightSum, ad);
            }
        }

        double rand = random.nextDouble() * weightSum;
        Map.Entry<Double, AudioAd> entry = map.ceilingEntry(rand);
        if (entry == null) {
            LOG.warn("Programming error, ceiling entry not found. " + rand + ", " + weightSum);
            return null;
        }

        MediaFile result = entry.getValue().getMediaFile();
        result.setMediaType(MediaFile.MediaType.AD);
        return result;
    }

    public void setSettingsService(SettingsService settingsService) {
        this.settingsService = settingsService;
    }
}
