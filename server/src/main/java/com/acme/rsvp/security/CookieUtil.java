package com.acme.rsvp.security;

import org.springframework.http.ResponseCookie;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public final class CookieUtil {
	private CookieUtil() {
	}

	public static void addSessionCookie(HttpServletResponse resp, String name, String value, int maxAgeSeconds,
			boolean secure) {
		// Use ResponseCookie to properly set SameSite attribute
		ResponseCookie cookie = ResponseCookie.from(name, value)
				.httpOnly(true)
				.secure(secure)
				.path("/")
				.maxAge(maxAgeSeconds)
				.sameSite(secure ? "None" : "Lax")
				.build();
		resp.addHeader("Set-Cookie", cookie.toString());
	}

	public static void clearCookie(HttpServletResponse resp, String name, boolean secure) {
		ResponseCookie cookie = ResponseCookie.from(name, "")
				.httpOnly(true)
				.secure(secure)
				.path("/")
				.maxAge(0)
				.sameSite(secure ? "None" : "Lax")
				.build();
		resp.addHeader("Set-Cookie", cookie.toString());
	}

	public static String readCookie(HttpServletRequest req, String name) {
		Cookie[] cookies = req.getCookies();
		if (cookies == null)
			return null;
		for (Cookie c : cookies) {
			if (name.equals(c.getName()))
				return c.getValue();
		}
		return null;
	}
}
