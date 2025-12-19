package com.acme.rsvp.dto.auth;

public record AuthResponse(Long personId, String itsNumber, String firstName, String lastName, String email, String phone) {}
