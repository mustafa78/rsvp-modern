package com.acme.rsvp.model;

import java.math.BigDecimal;

public enum MealSize {
  LARGE(new BigDecimal("1.0")),      // 32 oz => 1 quart
  SMALL(new BigDecimal("0.5")),      // 16 oz => 0.5 quart
  BARAKATI(new BigDecimal("0.25"));  // 8 oz  => 0.25 quart

  private final BigDecimal quarts;
  MealSize(BigDecimal quarts) { this.quarts = quarts; }
  public BigDecimal quarts() { return quarts; }
}