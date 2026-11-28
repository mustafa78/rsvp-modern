package com.acme.rsvp.model;

public enum WebinarAccessMode {
  OPEN, ASSIGNED;

  /** Parses a request value; an unknown value is a plain 400, never the raw "No enum constant" text. */
  public static WebinarAccessMode parse(String value) {
    for (WebinarAccessMode m : values()) {
      if (m.name().equals(value)) return m;
    }
    throw new IllegalArgumentException("Unknown access mode");
  }
}
