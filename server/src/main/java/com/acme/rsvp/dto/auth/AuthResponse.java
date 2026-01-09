package com.acme.rsvp.dto.auth;

import java.util.Set;

public record AuthResponse(Long personId, String itsNumber, String firstName, String lastName, String email, String phone, Set<String> roles, Long pickupZoneId) {}
