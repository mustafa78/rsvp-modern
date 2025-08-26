package com.acme.rsvp.dto;

import java.util.Set;

public record AuthResponse(String token, Long personId, String itsNumber, String firstName, String lastName,
		String email, Set<String> roles) {
}
