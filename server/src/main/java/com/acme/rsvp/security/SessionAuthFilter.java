package com.acme.rsvp.security;

import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SessionToken;
import com.acme.rsvp.repository.SessionTokenRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Component
public class SessionAuthFilter extends OncePerRequestFilter {

  public static final String COOKIE_NAME = "RSVP_SESSION";

  private final SessionTokenRepository tokenRepo;

  public SessionAuthFilter(SessionTokenRepository tokenRepo) {
    this.tokenRepo = tokenRepo;
  }

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
      throws ServletException, IOException {

    if (SecurityContextHolder.getContext().getAuthentication() == null) {
      String token = readCookie(request, COOKIE_NAME);
      if (token != null && !token.isBlank()) {
        try {
          UUID id = UUID.fromString(token);
          Optional<SessionToken> st = tokenRepo.findActive(id, OffsetDateTime.now());
          if (st.isPresent()) {
            Person p = st.get().getPerson();
            List<GrantedAuthority> auths = List.of(new SimpleGrantedAuthority("ROLE_USER"));
            var auth = new UsernamePasswordAuthenticationToken(p, null, auths);
            SecurityContextHolder.getContext().setAuthentication(auth);
          }
        } catch (IllegalArgumentException ignored) {
        }
      }
    }
    filterChain.doFilter(request, response);
  }

  private static String readCookie(HttpServletRequest req, String name) {
    Cookie[] cookies = req.getCookies();
    if (cookies == null) return null;
    for (Cookie c : cookies) {
      if (name.equals(c.getName())) return c.getValue();
    }
    return null;
  }
}
