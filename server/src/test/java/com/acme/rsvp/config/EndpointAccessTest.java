package com.acme.rsvp.config;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.request;

import java.sql.Connection;
import java.sql.Savepoint;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.hibernate.Session;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;

import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import com.acme.rsvp.model.Person;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

/**
 * Calls every endpoint as every kind of user and checks who is refused.
 *
 * <p>"Refused" means HTTP 403 from the security rules. Anything else (200, 400, 404, or an
 * exception thrown by the controller for the dummy input) means the request got past the rules.
 *
 * <p>When you add an endpoint, add a line here. An endpoint with no rule is ADMIN only.
 */
class EndpointAccessTest extends PostgresIntegrationTest {

  static final String ANON = "(not logged in)";
  static final String USER = "USER";
  static final String SUPER = "SUPER_USER";
  static final String ADMIN = "ADMIN";
  static final String NIYAZ = "NIYAZ_COORDINATOR";
  static final String THAALI = "THAALI_COORDINATOR";
  static final String MENU = "MENU_COORDINATOR";
  static final String SHOPPING = "SHOPPING_COORDINATOR";
  static final String DANA = "DANA_COORDINATOR";
  static final String WEBINAR = "WEBINAR_COORDINATOR";

  static final List<String> COORDINATORS = List.of(NIYAZ, THAALI, MENU, SHOPPING, DANA, WEBINAR);
  static final List<String> EVERY_IDENTITY =
      List.of(ANON, USER, SUPER, ADMIN, NIYAZ, THAALI, MENU, SHOPPING, DANA, WEBINAR);

  // Who may call an endpoint
  static final Set<String> PUBLIC = Set.copyOf(EVERY_IDENTITY);
  static final Set<String> MEMBER = Set.of(USER, SUPER, ADMIN, NIYAZ, THAALI, MENU, SHOPPING, DANA, WEBINAR);
  static final Set<String> STAFF = Set.of(ADMIN, NIYAZ, THAALI, MENU, SHOPPING, DANA, WEBINAR);
  static final Set<String> ADMIN_ONLY = Set.of(ADMIN);

  record Rule(HttpMethod method, String path, Set<String> allowed) {}

  static final List<Rule> RULES = new ArrayList<>();

  static void get(String path, Set<String> allowed) { RULES.add(new Rule(HttpMethod.GET, path, allowed)); }
  static void post(String path, Set<String> allowed) { RULES.add(new Rule(HttpMethod.POST, path, allowed)); }
  static void put(String path, Set<String> allowed) { RULES.add(new Rule(HttpMethod.PUT, path, allowed)); }
  static void delete(String path, Set<String> allowed) { RULES.add(new Rule(HttpMethod.DELETE, path, allowed)); }

  static {
    // ---- No login needed
    post("/api/auth/login", PUBLIC);
    post("/api/auth/register", PUBLIC);
    post("/api/auth/password/reset/request", PUBLIC);
    post("/api/auth/password/reset/confirm", PUBLIC);
    post("/api/auth/password/change-unauthenticated", PUBLIC);
    get("/api/auth/pickup-zones", PUBLIC);
    get("/api/events/public", PUBLIC);
    get("/api/events/999999", PUBLIC);
    get("/api/niyaz/999999/rsvp/summary", PUBLIC);

    // ---- Any logged-in member: own account, own RSVP, own order
    get("/api/auth/me", MEMBER);
    post("/api/auth/logout", MEMBER);
    post("/api/auth/password/change", MEMBER);
    get("/api/profile", MEMBER);
    put("/api/profile", MEMBER);
    post("/api/profile/change-password", MEMBER);
    get("/api/profile/rsvp-history", MEMBER);
    get("/api/profile/pickup-zones", MEMBER);
    get("/api/thaali/999999", MEMBER);
    get("/api/niyaz/999999", MEMBER);
    post("/api/niyaz/999999/rsvp", MEMBER);
    get("/api/niyaz/999999/rsvp/my", MEMBER);
    delete("/api/niyaz/999999/rsvp/my", MEMBER);
    post("/api/thaali/999999/orders", MEMBER);
    get("/api/thaali/999999/orders/my", MEMBER);
    delete("/api/thaali/999999/orders/my", MEMBER);
    get("/api/announcements", MEMBER);
    get("/api/announcements/unread-count", MEMBER);
    post("/api/announcements/999999/read", MEMBER);
    post("/api/announcements/read-all", MEMBER);
    get("/api/pickup-zones", MEMBER);
    get("/api/pickup-zones/active", MEMBER);
    get("/api/pickup-zones/999999", MEMBER);

    // ---- Webinars
    get("/api/webinars/public/999999", PUBLIC);
    get("/api/webinars/public/999999/launch", PUBLIC);
    get("/api/webinars", MEMBER);
    get("/api/webinars/999999/launch", MEMBER);
    Set<String> webinarDesk = Set.of(ADMIN, WEBINAR);
    get("/api/webinars/admin/zoom/preview", webinarDesk);
    post("/api/webinars/admin/zoom/import", webinarDesk);
    get("/api/webinars/admin", webinarDesk);
    post("/api/webinars/admin", webinarDesk);
    get("/api/webinars/admin/999999", webinarDesk);
    put("/api/webinars/admin/999999", webinarDesk);
    delete("/api/webinars/admin/999999", webinarDesk);
    get("/api/webinars/admin/999999/seats", webinarDesk);
    get("/api/webinars/admin/999999/assignable", webinarDesk);
    post("/api/webinars/admin/999999/seats", webinarDesk);
    delete("/api/webinars/admin/999999/seats/999999", webinarDesk);
    post("/api/webinars/admin/999999/seats/copy-from/999999", webinarDesk);
    post("/api/webinars/admin/999999/seats/999999/link", webinarDesk);
    post("/api/webinars/admin/999999/send-invites", webinarDesk);
    get("/api/webinars/admin/999999/report", webinarDesk);
    get("/api/admin/family-members/hofs", webinarDesk);
    get("/api/admin/family-members", webinarDesk);
    post("/api/admin/family-members", webinarDesk);
    put("/api/admin/family-members/999999", webinarDesk);
    put("/api/admin/family-members/999999/active", webinarDesk);

    // ---- Events
    get("/api/events", STAFF);
    post("/api/events/niyaz", Set.of(ADMIN, NIYAZ));
    put("/api/events/niyaz/999999", Set.of(ADMIN, NIYAZ));
    post("/api/events/thaali", Set.of(ADMIN, THAALI));
    put("/api/events/thaali/999999", Set.of(ADMIN, THAALI));
    post("/api/events/999999/publish", Set.of(ADMIN, NIYAZ, THAALI));
    post("/api/events/999999/cancel", Set.of(ADMIN, NIYAZ, THAALI));
    get("/api/events/999999/chefs", STAFF);
    get("/api/events/999999/menu", STAFF);
    post("/api/events/999999/chefs", Set.of(ADMIN, THAALI, MENU));
    post("/api/events/999999/menu", Set.of(ADMIN, THAALI, MENU));

    // ---- Niyaz RSVP report and RSVPs entered for a member
    Set<String> niyazDesk = Set.of(ADMIN, NIYAZ, DANA);
    get("/api/niyaz/999999/rsvp/all", niyazDesk);
    get("/api/niyaz/999999/rsvp/totals/adults", niyazDesk);
    get("/api/niyaz/999999/rsvp/totals/kids", niyazDesk);
    get("/api/niyaz/999999/rsvp/users-without-rsvps", niyazDesk);
    post("/api/niyaz/999999/rsvp/admin", niyazDesk);
    put("/api/niyaz/999999/rsvp/admin/999999", niyazDesk);
    delete("/api/niyaz/999999/rsvp/admin/999999", niyazDesk);

    // ---- Thaali reports (Shopping coordinator: totals and shopping lists only)
    Set<String> thaaliTotals = Set.of(ADMIN, THAALI, SHOPPING);
    Set<String> thaaliDesk = Set.of(ADMIN, THAALI);
    get("/api/thaali/999999/orders", thaaliDesk);
    get("/api/thaali/999999/orders/counts", thaaliTotals);
    get("/api/thaali/999999/orders/detailed-report", thaaliTotals);
    get("/api/thaali/999999/orders/shopping-list", thaaliTotals);
    get("/api/thaali/999999/orders/shopping-list-per-dish", thaaliTotals);
    get("/api/thaali/999999/orders/individual-orders", thaaliDesk);
    get("/api/thaali/999999/orders/users-without-orders", thaaliDesk);
    post("/api/thaali/999999/orders/admin", thaaliDesk);
    put("/api/thaali/999999/orders/admin/999999", thaaliDesk);
    delete("/api/thaali/999999/orders/admin/999999", thaaliDesk);

    // ---- Catalog: every staff role may read; changes depend on the list
    Set<String> menuDesk = Set.of(ADMIN, MENU);
    Set<String> kitchenDesk = Set.of(ADMIN, MENU, SHOPPING);
    Set<String> shoppingDesk = Set.of(ADMIN, SHOPPING);
    get("/api/dishes", STAFF);
    post("/api/dishes", menuDesk);
    put("/api/dishes/999999", menuDesk);
    get("/api/chefs", STAFF);
    post("/api/chefs", menuDesk);
    put("/api/chefs/999999", menuDesk);
    get("/api/ingredients", STAFF);
    get("/api/ingredients/999999", STAFF);
    post("/api/ingredients", kitchenDesk);
    put("/api/ingredients/999999", kitchenDesk);
    for (String list : List.of("categories", "units")) {
      get("/api/ingredient-lookups/" + list, STAFF);
      post("/api/ingredient-lookups/" + list, kitchenDesk);
      put("/api/ingredient-lookups/" + list + "/999999", kitchenDesk);
      delete("/api/ingredient-lookups/" + list + "/999999", kitchenDesk);
    }
    for (String list : List.of("stores", "storage-locations")) {
      get("/api/ingredient-lookups/" + list, STAFF);
      post("/api/ingredient-lookups/" + list, shoppingDesk);
      put("/api/ingredient-lookups/" + list + "/999999", shoppingDesk);
      delete("/api/ingredient-lookups/" + list + "/999999", shoppingDesk);
    }

    // ---- Announcements: managing them
    Set<String> announcers = Set.of(ADMIN, NIYAZ, THAALI);
    post("/api/announcements", announcers);
    get("/api/announcements/admin", announcers);
    put("/api/announcements/999999", announcers);
    delete("/api/announcements/999999", announcers);
    post("/api/announcements/999999/toggle-active", announcers);

    // ---- Users, roles, pickup zones
    get("/api/admin/users", Set.of(ADMIN, NIYAZ)); // Niyaz coordinator picks a host from this list
    post("/api/admin/users", ADMIN_ONLY);
    get("/api/admin/users/999999", ADMIN_ONLY);
    put("/api/admin/users/999999/roles", ADMIN_ONLY);
    put("/api/admin/users/999999/status", ADMIN_ONLY);
    put("/api/admin/users/999999/info", ADMIN_ONLY);
    put("/api/admin/users/999999/user-type", ADMIN_ONLY);
    put("/api/admin/users/999999/extend", ADMIN_ONLY);
    post("/api/admin/users/999999/convert-to-registered", ADMIN_ONLY);
    get("/api/roles", ADMIN_ONLY);
    get("/api/roles/active", ADMIN_ONLY);
    get("/api/roles/999999", ADMIN_ONLY);
    post("/api/roles", ADMIN_ONLY);
    put("/api/roles/999999", ADMIN_ONLY);
    put("/api/roles/999999/activate", ADMIN_ONLY);
    put("/api/roles/999999/deactivate", ADMIN_ONLY);
    post("/api/pickup-zones", ADMIN_ONLY);
    put("/api/pickup-zones/999999", ADMIN_ONLY);

    // ---- An endpoint nobody wrote a rule for is ADMIN only
    get("/api/some-endpoint-added-later", ADMIN_ONLY);
    post("/api/some-endpoint-added-later", ADMIN_ONLY);
  }

  @Autowired MockMvc mvc;
  @Autowired TestData data;
  @Autowired PersonRepository persons;
  @Autowired @Qualifier("requestMappingHandlerMapping") RequestMappingHandlerMapping handlerMapping;
  @PersistenceContext EntityManager entityManager;

  @Test
  void everyEndpointRefusesExactlyTheRolesThatMustNotUseIt() {
    Map<String, Person> people = new LinkedHashMap<>();
    for (String identity : EVERY_IDENTITY) {
      if (!ANON.equals(identity)) {
        people.put(identity, data.person(true, identity));
      }
    }

    List<String> wrong = new ArrayList<>();
    for (Rule rule : RULES) {
      for (String identity : EVERY_IDENTITY) {
        boolean refused = isRefused(rule, people.get(identity));
        boolean shouldBeRefused = !rule.allowed().contains(identity);
        if (refused != shouldBeRefused) {
          wrong.add("%s %s as %s: expected %s but was %s".formatted(rule.method(), rule.path(), identity,
              shouldBeRefused ? "REFUSED" : "allowed", refused ? "REFUSED" : "allowed"));
        }
      }
    }
    assertThat(wrong).as("endpoints with the wrong access").isEmpty();
  }

  /** Fails when someone adds an endpoint without deciding who may use it. */
  @Test
  void everyControllerEndpointHasALineInThisTest() {
    Set<String> listed = new HashSet<>();
    RULES.forEach(r -> listed.add(r.method() + " " + r.path()));

    List<String> missing = new ArrayList<>();
    handlerMapping.getHandlerMethods().forEach((info, handler) -> {
      for (String pattern : info.getPatternValues()) {
        for (RequestMethod method : info.getMethodsCondition().getMethods()) {
          String line = method + " " + pattern.replaceAll("\\{[^}]+}", "999999");
          if (pattern.startsWith("/api/") && !listed.contains(line)) {
            missing.add(line + "  (" + handler.getBeanType().getSimpleName() + ")");
          }
        }
      }
    });
    assertThat(missing).as("endpoints with no line in EndpointAccessTest").isEmpty();
  }

  /** A coordinator who is also a plain USER (the normal case for real accounts) keeps coordinator access. */
  @Test
  void rolesAddUp() throws Exception {
    Person niyazMember = data.person(true, USER, NIYAZ);
    assertThat(isRefused(new Rule(HttpMethod.GET, "/api/niyaz/999999/rsvp/all", Set.of()), niyazMember)).isFalse();
    assertThat(isRefused(new Rule(HttpMethod.GET, "/api/thaali/999999/orders", Set.of()), niyazMember)).isTrue();
  }

  @Test
  void memberCannotGiveThemselvesARole() throws Exception {
    Person member = data.person(true, USER);
    mvc.perform(request(HttpMethod.PUT, "/api/admin/users/" + member.getId() + "/roles")
            .cookie(data.session(member))
            .contentType(MediaType.APPLICATION_JSON)
            .content("{\"roles\":[\"USER\",\"ADMIN\"]}"))
        .andExpect(r -> assertThat(r.getResponse().getStatus()).isEqualTo(403));
    assertThat(persons.findById(member.getId()).orElseThrow().getRoles()).containsExactly(USER);
  }

  @Test
  void coordinatorCannotGiveThemselvesAdmin() throws Exception {
    for (String role : COORDINATORS) {
      Person coordinator = data.person(true, role);
      mvc.perform(request(HttpMethod.PUT, "/api/admin/users/" + coordinator.getId() + "/roles")
              .cookie(data.session(coordinator))
              .contentType(MediaType.APPLICATION_JSON)
              .content("{\"roles\":[\"ADMIN\"]}"))
          .andExpect(r -> assertThat(r.getResponse().getStatus()).as(role).isEqualTo(403));
      assertThat(persons.findById(coordinator.getId()).orElseThrow().getRoles()).containsExactly(role);
    }
  }

  @Test
  void adminCanChangeRoles() throws Exception {
    Person member = data.person(true, USER);
    mvc.perform(request(HttpMethod.PUT, "/api/admin/users/" + member.getId() + "/roles")
            .cookie(data.session(data.person(true, ADMIN)))
            .contentType(MediaType.APPLICATION_JSON)
            .content("{\"roles\":[\"USER\",\"NIYAZ_COORDINATOR\"]}"))
        .andExpect(r -> assertThat(r.getResponse().getStatus()).isEqualTo(200));
    assertThat(persons.findById(member.getId()).orElseThrow().getRoles())
        .containsExactlyInAnyOrder(USER, NIYAZ);
  }

  /**
   * Makes one request as the given person (null = not logged in) and undoes whatever it did.
   *
   * <p>Each request runs inside a database savepoint that is rolled back afterwards. Some endpoints really
   * act on the dummy input (logout ends the session, a bad id can fail in the database), and without
   * the savepoint one request would spoil the ones after it.
   */
  private boolean isRefused(Rule rule, Person who) {
    Session hibernate = entityManager.unwrap(Session.class);
    Savepoint before = hibernate.doReturningWork(Connection::setSavepoint);
    try {
      MockHttpServletRequestBuilder req = request(rule.method(), rule.path());
      if (who != null) {
        req.cookie(data.session(who));
      }
      if (rule.method() != HttpMethod.GET && rule.method() != HttpMethod.DELETE) {
        req.contentType(MediaType.APPLICATION_JSON).content("{}");
      }
      return mvc.perform(req).andReturn().getResponse().getStatus() == 403;
    } catch (Exception thrownByController) {
      // The dummy input reached the controller and failed there: the security rules let it through.
      return false;
    } finally {
      entityManager.clear();
      hibernate.doWork(connection -> connection.rollback(before));
    }
  }
}
