package com.acme.rsvp.model;

public enum WebinarStatus {
  DRAFT, PUBLISHED, CANCELLED;

  /** Parses a request value; an unknown value is a plain 400, never the raw "No enum constant" text. */
  public static WebinarStatus parse(String value) {
    for (WebinarStatus s : values()) {
      if (s.name().equals(value)) return s;
    }
    throw new IllegalArgumentException("Unknown status");
  }
}
