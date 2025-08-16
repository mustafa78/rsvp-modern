package com.acme.rsvp.dto;
import com.acme.rsvp.model.PickupZone;
import java.util.Set;
public class PersonDtos {
  public record PersonDto(Long id, String itsNumber, String firstName, String lastName, String email, String phone, Set<String> roles, PickupZone pickupZone) {}
}
