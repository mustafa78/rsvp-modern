package com.acme.rsvp.web;

import com.acme.rsvp.dto.RegisterRequest;
import com.acme.rsvp.dto.LoginRequest;
import com.acme.rsvp.dto.AuthResponse;
import com.acme.rsvp.dto.PasswordChangeRequest;
import com.acme.rsvp.dto.PasswordResetRequest;
import com.acme.rsvp.dto.PasswordResetConfirmRequest;
import com.acme.rsvp.dto.PasswordConfirmRequest;
import com.acme.rsvp.dto.PersonDtos.PersonDto;
import com.acme.rsvp.dto.RsvpDtos.MessageDto;
import com.acme.rsvp.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
  private final AuthService auth;
  public AuthController(AuthService auth){ this.auth = auth; }

  @PostMapping("/register")
  public ResponseEntity<PersonDto> register(@Valid @RequestBody RegisterRequest req){ return ResponseEntity.ok(auth.register(req)); }

  @PostMapping("/login")
  public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest req){ return ResponseEntity.ok(auth.login(req)); }

  @PostMapping("/password/change")
  public ResponseEntity<MessageDto> change(@Valid @RequestBody PasswordChangeRequest req){
    auth.changePassword(req); return ResponseEntity.ok(new MessageDto("Password changed."));
  }

  @PostMapping("/password/request-reset")
  public ResponseEntity<MessageDto> requestReset(@Valid @RequestBody PasswordResetRequest req){
    String t = auth.requestPasswordReset(req); return ResponseEntity.ok(new MessageDto("Reset token (stub): " + t));
  }

  @PostMapping("/password/confirm-reset")
  public ResponseEntity<MessageDto> confirmReset(@Valid @RequestBody PasswordResetConfirmRequest req){
    auth.confirmPasswordReset(req); return ResponseEntity.ok(new MessageDto("Password reset."));
  }

  @PostMapping("/password/confirm")
  public ResponseEntity<MessageDto> confirm(@Valid @RequestBody PasswordConfirmRequest req){
    auth.confirmPasswordReset(new PasswordResetConfirmRequest(req.itsNumber(), req.token(), req.newPassword()));
    return ResponseEntity.ok(new MessageDto("Password reset."));
  }
}
