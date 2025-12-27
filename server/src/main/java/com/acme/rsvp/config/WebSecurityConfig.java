package com.acme.rsvp.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.acme.rsvp.security.SessionAuthFilter;

@Configuration
public class WebSecurityConfig {

	private final SessionAuthFilter sessionAuthFilter;

	public WebSecurityConfig(SessionAuthFilter sessionAuthFilter) {
		this.sessionAuthFilter = sessionAuthFilter;
	}

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
	    http
	      .csrf(csrf -> csrf.disable())
	      .cors(Customizer.withDefaults())
	      .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
	      .authorizeHttpRequests(auth -> auth
	    	        .requestMatchers(HttpMethod.POST,
	    	            "/api/auth/login",
	    	            "/api/auth/register",
	    	            "/api/auth/password/reset/request",
	    	            "/api/auth/password/reset/confirm").permitAll()
	    	        .requestMatchers(HttpMethod.GET,
	    	            "/api/auth/pickup-zones",
	    	            "/api/events/public",
	    	            "/api/events/{id}").permitAll()
	    	        .anyRequest().authenticated()
	      );
	    http.addFilterBefore(sessionAuthFilter,
	        UsernamePasswordAuthenticationFilter.class);
	    return http.build();
	}

	@Bean
	public CorsConfigurationSource corsConfigurationSource() {
		CorsConfiguration cfg = new CorsConfiguration();
		// IMPORTANT: with credentials=true, do NOT use "*" here.
		cfg.setAllowedOrigins(List.of("http://localhost:5173", "http://127.0.0.1:5173"));
		cfg.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
		cfg.setAllowedHeaders(List.of("*"));
		cfg.setAllowCredentials(true);

		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", cfg);
		return source;
	}

}
