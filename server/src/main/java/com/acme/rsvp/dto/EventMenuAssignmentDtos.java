package com.acme.rsvp.dto;

import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class EventMenuAssignmentDtos {
  public record MenuAssignment(@NotNull Long dishId, BigDecimal quartsPerThaaliUnitOverride, Integer position) {}
}
