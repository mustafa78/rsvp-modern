package com.acme.rsvp.exception;

/**
 * Exception thrown when a user attempts to login or access the system
 * with an expired account (Student or Mehmaan past their expiration date).
 */
public class AccountExpiredException extends RuntimeException {

    public AccountExpiredException(String message) {
        super(message);
    }
}
