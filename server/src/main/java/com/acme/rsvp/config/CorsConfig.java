package com.acme.rsvp.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {

  @Value("${cors.allowed-origins:http://localhost:5173}")
  private String allowedOrigins;

  @Bean
  public CorsFilter corsFilter() {
    CorsConfiguration cfg = new CorsConfiguration();
    // Support multiple origins separated by comma
    for (String origin : allowedOrigins.split(",")) {
      cfg.addAllowedOrigin(origin.trim());
    }
    cfg.addAllowedMethod("*");
    cfg.addAllowedHeader("*");
    cfg.setAllowCredentials(true);
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", cfg);
    return new CorsFilter(source);
  }
}
