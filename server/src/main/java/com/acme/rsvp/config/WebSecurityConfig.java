package com.acme.rsvp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

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
      .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
      .authorizeHttpRequests(reg -> reg
          .requestMatchers("/api/auth/**").permitAll()
          .anyRequest().authenticated()
      )
      .httpBasic(Customizer.withDefaults());

    http.addFilterBefore(sessionAuthFilter, UsernamePasswordAuthenticationFilter.class);
	return http.build();
}

}
