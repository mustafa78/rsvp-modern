package com.acme.rsvp.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
  private static final Logger log = LoggerFactory.getLogger(EmailService.class);

  public void sendPasswordResetLink(String to, String link) {
    log.info("Password reset link for {} -> {}", to, link);
  }
}
