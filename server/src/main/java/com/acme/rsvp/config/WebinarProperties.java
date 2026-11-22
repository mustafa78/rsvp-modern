package com.acme.rsvp.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;

@ConfigurationProperties(prefix = "app.webinar")
public record WebinarProperties(
    @DefaultValue("10") int joinWindowBeforeMinutes,
    @DefaultValue("15") int joinWindowAfterMinutes,
    @DefaultValue("America/New_York") String displayZone) {}
