package com.acme.rsvp.security;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

public final class CookieUtil {
  private CookieUtil(){}

  public static void addSessionCookie(HttpServletResponse resp, String name, String value, int maxAgeSeconds, boolean secure) {
    Cookie c = new Cookie(name, value);
    c.setHttpOnly(true);
    c.setSecure(secure);
    c.setPath("/");
    c.setMaxAge(maxAgeSeconds);
    resp.addCookie(c);
  }

  public static void clearCookie(HttpServletResponse resp, String name, boolean secure) {
    Cookie c = new Cookie(name, "");
    c.setHttpOnly(true);
    c.setSecure(secure);
    c.setPath("/");
    c.setMaxAge(0);
    resp.addCookie(c);
  }
}
