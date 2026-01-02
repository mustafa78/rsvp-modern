package com.acme.rsvp.model;

/**
 * User type classification for membership management.
 *
 * REGISTERED - Permanent member with no expiration
 * STUDENT - Temporary user with 2-month default expiration
 * MEHMAAN - Guest user with 1-month default expiration
 */
public enum UserType {
    REGISTERED,
    STUDENT,
    MEHMAAN
}
