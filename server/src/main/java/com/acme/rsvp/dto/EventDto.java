package com.acme.rsvp.dto;

import com.acme.rsvp.model.Event;
import java.time.*;

public record EventDto(Long id, LocalDate date, LocalTime startTime, Integer capacity, String notes) {
  public static EventDto from(Event e) { return new EventDto(e.getId(), e.getDate(), e.getStartTime(), e.getCapacity(), e.getNotes()); }
}
