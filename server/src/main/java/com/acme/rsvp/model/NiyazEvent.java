package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@DiscriminatorValue("NIYAZ")
public class NiyazEvent extends Event {

    @Column(name = "miqaat_name", nullable = false, length = 200)
    private String miqaatName;

    @Column(name = "show_rsvp_summary", nullable = false)
    private boolean showRsvpSummary = false;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "niyaz_event_hosts", joinColumns = @JoinColumn(name = "event_id"), inverseJoinColumns = @JoinColumn(name = "person_id"))
    private Set<Person> hosts = new HashSet<>();

    // Getters and setters
    public String getMiqaatName() {
        return miqaatName;
    }

    public void setMiqaatName(String miqaatName) {
        this.miqaatName = miqaatName;
    }

    public boolean isShowRsvpSummary() {
        return showRsvpSummary;
    }

    public void setShowRsvpSummary(boolean showRsvpSummary) {
        this.showRsvpSummary = showRsvpSummary;
    }

    public Set<Person> getHosts() {
        return hosts;
    }

    public void setHosts(Set<Person> hosts) {
        this.hosts = hosts;
    }

    // Helper methods
    public void addHost(Person person) {
        hosts.add(person);
    }

    public void removeHost(Person person) {
        hosts.remove(person);
    }
}
