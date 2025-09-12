package com.acme.rsvp.web;

import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.auth.AuthResponse;
import com.acme.rsvp.dto.auth.LoginRequest;
import com.acme.rsvp.dto.auth.PasswordChangeRequest;
import com.acme.rsvp.dto.auth.PasswordConfirmRequest;
import com.acme.rsvp.dto.auth.PasswordResetRequest;
import com.acme.rsvp.dto.auth.RegisterRequest;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SessionToken;
import com.acme.rsvp.repository.PickupZoneRepository;
import com.acme.rsvp.security.CookieUtil;
import com.acme.rsvp.security.SessionAuthFilter;
import com.acme.rsvp.service.AuthService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

	private final AuthService auth;
	private final PickupZoneRepository zones;

	public AuthController(AuthService auth, PickupZoneRepository zones) {
		this.auth = auth;
		this.zones = zones;
	}

	public record PickupZoneDto(Long id, String name) {
	}

	@GetMapping("/pickup-zones")
	public List<PickupZoneDto> pickupZones() {
		return zones.findAllByActiveTrueOrderByNameAsc().stream().map(z -> new PickupZoneDto(z.getId(), z.getName()))
				.toList();
	}

	@PostMapping("/register")
	public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest req) {
		var res = auth.register(req);
		return ResponseEntity.created(URI.create("/api/auth/me")).body(res);
	}

	@PostMapping("/login")
	public ResponseEntity<?> login(@Valid @RequestBody LoginRequest req, HttpServletRequest httpReq,
			HttpServletResponse httpResp) {
		System.out.println("Inside AuthController...........");
		
		try {
			SessionToken t = auth.login(req);
			boolean secure = "https".equalsIgnoreCase(httpReq.getHeader("X-Forwarded-Proto")) || httpReq.isSecure();
			CookieUtil.addSessionCookie(httpResp, SessionAuthFilter.COOKIE_NAME, t.getId().toString(), 7 * 24 * 3600,
					secure);
			return ResponseEntity.ok(Map.of("ok", true));
		} catch (BadCredentialsException e) {
			// invalid user/pass
			return ResponseEntity.status(401).body(Map.of("error", "invalid_credentials"));
		} catch (UsernameNotFoundException e) {
			return ResponseEntity.status(401).body(Map.of("error", "invalid_credentials"));
		} catch (AccessDeniedException e) {
			// if your AuthService throws AccessDeniedException, convert it to 401
			return ResponseEntity.status(401).body(Map.of("error", "invalid_credentials"));
		}
	}

	@PostMapping("/logout")
	public ResponseEntity<?> logout(HttpServletRequest httpReq, HttpServletResponse httpResp,
			@CookieValue(name = SessionAuthFilter.COOKIE_NAME, required = false) String cookie) {
		if (cookie != null && !cookie.isBlank()) {
			try {
				auth.logout(UUID.fromString(cookie));
			} catch (IllegalArgumentException ignored) {
			}
		}
		boolean secure = "https".equalsIgnoreCase(httpReq.getHeader("X-Forwarded-Proto")) || httpReq.isSecure();
		CookieUtil.clearCookie(httpResp, SessionAuthFilter.COOKIE_NAME, secure);
		return ResponseEntity.ok(Map.of("ok", true));
	}

	@GetMapping("/me")
	public ResponseEntity<?> me(@AuthenticationPrincipal Person me) {
		if (me == null)
			return ResponseEntity.status(401).build();
		return ResponseEntity.ok(
				new AuthResponse(me.getId(), me.getItsNumber(), me.getFirstName(), me.getLastName(), me.getEmail()));
	}

	@PostMapping("/password/change")
	public ResponseEntity<?> changePassword(@AuthenticationPrincipal Person me,
			@Valid @RequestBody PasswordChangeRequest req) {
		if (me == null)
			return ResponseEntity.status(401).build();
		auth.changePassword(me, req);
		return ResponseEntity.ok(Map.of("ok", true));
	}

	@PostMapping("/password/reset/request")
	public ResponseEntity<?> resetRequest(@Valid @RequestBody PasswordResetRequest req, HttpServletRequest httpReq) {
		String base = getBaseUrl(httpReq);
		auth.sendReset(req.itsNumberOrEmail(), base);
		return ResponseEntity.ok(Map.of("ok", true));
	}

	@PostMapping("/password/reset/confirm")
	public ResponseEntity<?> resetConfirm(@Valid @RequestBody PasswordConfirmRequest req) {
		auth.confirmReset(req);
		return ResponseEntity.ok(Map.of("ok", true));
	}

	private static String getBaseUrl(HttpServletRequest req) {
		String proto = req.getHeader("X-Forwarded-Proto");
		String host = req.getHeader("X-Forwarded-Host");
		if (proto != null && host != null)
			return proto + "://" + host;
		String scheme = req.getScheme();
		String server = req.getServerName();
		int port = req.getServerPort();
		if ((scheme.equals("http") && port == 80) || (scheme.equals("https") && port == 443)) {
			return scheme + "://" + server;
		}
		return scheme + "://" + server + ":" + port;
	}
}
