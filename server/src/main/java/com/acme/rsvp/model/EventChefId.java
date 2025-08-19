package com.acme.rsvp.model;
import java.io.Serializable;
import java.util.Objects;
public class EventChefId implements Serializable {
  private Long event;
  private Long chef;
  public EventChefId(){}
  public EventChefId(Long event, Long chef){ this.event = event; this.chef = chef; }
  @Override public boolean equals(Object o){ if(this==o) return true; if(o==null||getClass()!=o.getClass()) return false; EventChefId that=(EventChefId)o; return java.util.Objects.equals(event,that.event)&&java.util.Objects.equals(chef,that.chef); }
  @Override public int hashCode(){ return java.util.Objects.hash(event,chef); }
}
