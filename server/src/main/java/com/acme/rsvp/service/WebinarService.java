package com.acme.rsvp.service;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.config.WebinarProperties;
import com.acme.rsvp.dto.WebinarDtos.MemberWebinar;
import com.acme.rsvp.dto.WebinarDtos.SaveWebinarRequest;
import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.WebinarRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;

@Service
public class WebinarService {

  private final WebinarRepository webinars;
  private final WebinarSeatRepository seats;
  private final WebinarProperties props;

  public WebinarService(WebinarRepository webinars, WebinarSeatRepository seats, WebinarProperties props) {
    this.webinars = webinars;
    this.seats = seats;
    this.props = props;
  }

  @Transactional
  public WebinarSummary create(SaveWebinarRequest req) {
    Webinar w = new Webinar();
    w.setJoinWindowBeforeMin(props.joinWindowBeforeMinutes());
    w.setJoinWindowAfterMin(props.joinWindowAfterMinutes());
    apply(w, req);
    return toSummary(webinars.save(w));
  }

  @Transactional
  public WebinarSummary update(Long id, SaveWebinarRequest req) {
    Webinar w = require(id);
    apply(w, req);
    return toSummary(w);
  }

  @Transactional(readOnly = true)
  public List<WebinarSummary> list() {
    return webinars.findAllByOrderByScheduledStartDesc().stream().map(this::toSummary).toList();
  }

  @Transactional(readOnly = true)
  public WebinarSummary get(Long id) {
    return toSummary(require(id));
  }

  @Transactional
  public void delete(Long id) {
    webinars.delete(require(id));
  }

  @Transactional(readOnly = true)
  public Webinar require(Long id) {
    return webinars.findById(id).orElseThrow(() -> new NotFoundException("Webinar not found"));
  }

  /** Published webinars whose join window has not closed, that are OPEN or where the person holds their own seat. */
  @Transactional(readOnly = true)
  public List<MemberWebinar> listForMember(Long personId, OffsetDateTime now) {
    return webinars.findByStatusOrderByScheduledStartAsc(WebinarStatus.PUBLISHED).stream()
        .filter(w -> !now.isAfter(w.joinWindowEnd()))
        .filter(w -> w.getAccessMode() == WebinarAccessMode.OPEN
            || seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(w.getId(), personId).isPresent())
        .map(w -> new MemberWebinar(w.getId(), w.getTitle(), w.getHostName(),
            w.getScheduledStart(), w.getScheduledEnd(), w.isJoinOpen(now)))
        .toList();
  }

  public WebinarSummary toSummary(Webinar w) {
    long seatCount = w.getId() == null ? 0 : seats.countByWebinarId(w.getId());
    return new WebinarSummary(w.getId(), w.getTitle(), w.getDescription(), w.getHostName(),
        w.getScheduledStart(), w.getScheduledEnd(), w.getStatus().name(), w.getAccessMode().name(),
        w.isManagedByZoom(), w.getJoinWindowBeforeMin(), w.getJoinWindowAfterMin(),
        w.getJoinUrl() != null && !w.getJoinUrl().isBlank(), seatCount);
  }

  private void apply(Webinar w, SaveWebinarRequest req) {
    if (req.title() == null || req.title().isBlank()) {
      throw new IllegalArgumentException("Title is required");
    }
    if (req.scheduledStart() == null || req.scheduledEnd() == null) {
      throw new IllegalArgumentException("Start and end times are required");
    }
    if (!req.scheduledEnd().isAfter(req.scheduledStart())) {
      throw new IllegalArgumentException("End time must be after start time");
    }
    w.setTitle(req.title().trim());
    w.setDescription(req.description());
    w.setHostName(req.hostName());
    w.setScheduledStart(req.scheduledStart());
    w.setScheduledEnd(req.scheduledEnd());
    if (req.status() != null && !req.status().isBlank()) {
      w.setStatus(WebinarStatus.valueOf(req.status()));
    }
    if (req.accessMode() != null && !req.accessMode().isBlank()) {
      w.setAccessMode(WebinarAccessMode.valueOf(req.accessMode()));
    }
    if (req.joinWindowBeforeMin() != null) {
      if (req.joinWindowBeforeMin() < 0) throw new IllegalArgumentException("Join window cannot be negative");
      w.setJoinWindowBeforeMin(req.joinWindowBeforeMin());
    }
    if (req.joinWindowAfterMin() != null) {
      if (req.joinWindowAfterMin() < 0) throw new IllegalArgumentException("Join window cannot be negative");
      w.setJoinWindowAfterMin(req.joinWindowAfterMin());
    }
    // A blank join URL means "keep what is stored" so the edit form never needs to receive it.
    if (req.joinUrl() != null && !req.joinUrl().isBlank()) {
      String url = req.joinUrl().trim();
      if (!url.startsWith("https://")) {
        throw new IllegalArgumentException("Zoom link must start with https://");
      }
      w.setJoinUrl(url);
    }
  }
}
