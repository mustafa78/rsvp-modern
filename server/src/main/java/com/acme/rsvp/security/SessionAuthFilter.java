package com.acme.rsvp.security;

import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SessionToken;
import com.acme.rsvp.repository.SessionTokenRepository;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class SessionAuthFilter extends OncePerRequestFilter {

	public static final String COOKIE_NAME = "RSVP_SESSION";

	private final SessionTokenRepository sessions;

	public SessionAuthFilter(SessionTokenRepository sessions) {
		this.sessions = sessions;
	}

	// Public endpoints that don't need session authentication
	private static final List<String> PUBLIC_PATHS = List.of(
		"/api/auth/login",
		"/api/auth/register",
		"/api/auth/password/reset/request",
		"/api/auth/password/reset/confirm",
		"/api/auth/pickup-zones",
		"/api/events/public"
	);

	// Patterns for paths with path variables
	private static final String EVENT_DETAIL_PATTERN = "/api/events/";

	@Override
	protected void doFilterInternal(HttpServletRequest req, HttpServletResponse resp, FilterChain chain)
			throws ServletException, IOException {

		String path = req.getRequestURI();
		String method = req.getMethod();

		// Skip authentication setup for OPTIONS requests
		if ("OPTIONS".equalsIgnoreCase(method)) {
			chain.doFilter(req, resp);
			return;
		}

		// Skip for explicit public paths
		if (PUBLIC_PATHS.contains(path)) {
			chain.doFilter(req, resp);
			return;
		}

		// Skip for GET /api/events/{id} (event detail page)
		if ("GET".equalsIgnoreCase(method) && path.startsWith(EVENT_DETAIL_PATTERN) && !path.contains("/rsvp")) {
			chain.doFilter(req, resp);
			return;
		}

		String cookie = CookieUtil.readCookie(req, COOKIE_NAME);
		if (cookie != null && !cookie.isBlank()) {
			try {
				UUID id = UUID.fromString(cookie);
				Optional<SessionToken> tok = sessions.findActive(id, OffsetDateTime.now());
				if (tok.isPresent()) {
					Person user = tok.get().getPerson();
					var auth = new UsernamePasswordAuthenticationToken(user, null, List.of());
					SecurityContextHolder.getContext().setAuthentication(auth);
				}
			} catch (IllegalArgumentException ignored) {
				// bad UUID -> treat as anonymous
			}
		}
		// Never send 401/403 here — just continue
		chain.doFilter(req, resp);
	}

}
