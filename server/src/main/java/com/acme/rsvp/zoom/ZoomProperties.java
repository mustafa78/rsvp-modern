package com.acme.rsvp.zoom;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;

@ConfigurationProperties(prefix = "app.zoom")
public record ZoomProperties(
    @DefaultValue("false") boolean enabled,
    @DefaultValue("") String accountId,
    @DefaultValue("") String clientId,
    @DefaultValue("") String clientSecret,
    @DefaultValue("me") String importUserId,
    @DefaultValue("") String webinarImportUserId,
    @DefaultValue("https://zoom.us/oauth/token") String oauthUrl,
    @DefaultValue("https://api.zoom.us") String baseUrl,
    @DefaultValue("FMB") String defaultHostName) {}
