package net.sourceforge.subsonic.controller;

import net.sourceforge.subsonic.*;
import net.sourceforge.subsonic.service.*;
import org.springframework.web.servlet.*;
import org.springframework.web.servlet.mvc.*;

import javax.servlet.http.*;
import java.util.*;

/**
 * Controller for the help page.
 *
 * @author Sindre Mehus
 */
public class HelpController extends AbstractController {
    private VersionService versionService;

    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();

        map.put("localVersion", versionService.getLocalVersion());
        map.put("latestVersion", versionService.getLatestVersion());
        map.put("buildDate", versionService.getLocalBuildDate());
        map.put("buildNumber", versionService.getLocalBuildNumber());
        map.put("newVersionAvailable", versionService.isNewVersionAvailable());
        map.put("logEntries", Logger.getLatestLogEntries());

        return new ModelAndView("help", "model", map);
    }

    public void setVersionService(VersionService versionService) {
        this.versionService = versionService;
    }
}
