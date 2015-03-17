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
package net.sourceforge.subsonic.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.ParameterizableViewController;

import net.sourceforge.subsonic.dao.AudioAdDao;
import net.sourceforge.subsonic.domain.AudioAd;
import net.sourceforge.subsonic.domain.MediaFile;
import net.sourceforge.subsonic.service.MediaFileService;
import net.sourceforge.subsonic.service.SettingsService;
import net.sourceforge.subsonic.util.StringUtil;

/**
 * Controller for the page used to administrate the set of audio ads.
 *
 * @author Sindre Mehus
 */
public class AudioAdSettingsController extends ParameterizableViewController {

    private AudioAdDao audioAdDao;
    private MediaFileService mediaFileService;
    private SettingsService settingsService;

    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String, Object> map = new HashMap<String, Object>();

        if (isFormSubmission(request)) {
            String error = handleParameters(request);
            if (error != null) {
                map.put("error", error);
            } else {
                map.put("toast", true);
            }
        }

        ModelAndView result = super.handleRequestInternal(request, response);
        map.put("ads", audioAdDao.getAllAudioAds(true));
        map.put("audioAdEnabled", settingsService.isAudioAdEnabled());
        map.put("audioAdFrequency", settingsService.getAudioAdFrequency());

        result.addObject("model", map);
        return result;
    }

    /**
     * Determine if the given request represents a form submission.
     *
     * @param request current HTTP request
     * @return if the request represents a form submission
     */
    private boolean isFormSubmission(HttpServletRequest request) {
        return "POST".equals(request.getMethod());
    }

    private String handleParameters(HttpServletRequest request) throws Exception {

        Double frequency = StringUtil.parseDouble(StringUtils.trimToNull(request.getParameter("audioAdFrequency")));
        if (frequency == null || frequency < 0.0 || frequency > 1.0) {
            return "audioadsettings.nofrequency";
        }
        settingsService.setAudioAdFrequency(frequency);
        settingsService.setAudioAdEnabled(request.getParameter("audioAdEnabled") != null);
        settingsService.save();

        List<AudioAd> ads = audioAdDao.getAllAudioAds(true);
        for (AudioAd ad : ads) {
            int id = ad.getId();
            String path = getParameter(request, "path", id);
            String comment = getParameter(request, "comment", id);
            Double weight = StringUtil.parseDouble(getParameter(request, "weight", id));
            boolean enabled = getParameter(request, "enabled", id) != null;
            boolean delete = getParameter(request, "delete", id) != null;
            MediaFile mediaFile = null;
            try {
                mediaFile = mediaFileService.getMediaFile(path);
            } catch (Exception x) {
                // Ignored
            }

            if (delete) {
                audioAdDao.deleteAudioAd(id);
            } else {
                if (mediaFile == null || mediaFile.isDirectory()) {
                    return "audioadsettings.nofile";
                }
                if (weight == null || weight < 0.0 || weight > 1.0) {
                    return "audioadsettings.noweight";
                }

                audioAdDao.updateAudioAd(new AudioAd(id, mediaFile, weight, comment, enabled, ad.getCreated(), new Date()));
            }
        }

        String path = StringUtils.trimToNull(request.getParameter("path"));
        if (path != null) {
            String comment = StringUtils.trimToNull(request.getParameter("comment"));
            Double weight = StringUtil.parseDouble(StringUtils.trimToNull(request.getParameter("weight")));
            boolean enabled = StringUtils.trimToNull(request.getParameter("enabled")) != null;
            MediaFile mediaFile = null;
            try {
                mediaFile = mediaFileService.getMediaFile(path);
            } catch (Exception x) {
                // Ignored
            }

            if (mediaFile == null || mediaFile.isDirectory()) {
                return "audioadsettings.nofile";
            }
            if (weight == null || weight < 0.0 || weight > 1.0) {
                return "audioadsettings.noweight";
            }

            audioAdDao.createAudioAd(new AudioAd(null, mediaFile, weight, comment, enabled, new Date(), new Date()));
        }

        return null;
    }

    private String getParameter(HttpServletRequest request, String name, Integer id) {
        return StringUtils.trimToNull(request.getParameter(name + "[" + id + "]"));
    }

    public void setAudioAdDao(AudioAdDao audioAdDao) {
        this.audioAdDao = audioAdDao;
    }

    public void setMediaFileService(MediaFileService mediaFileService) {
        this.mediaFileService = mediaFileService;
    }

    public void setSettingsService(SettingsService settingsService) {
        this.settingsService = settingsService;
    }
}
