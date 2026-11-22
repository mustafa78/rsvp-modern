package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.Set;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.dto.AdminUserDtos.CreateUserRequest;
import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.HofDto;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.UserType;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class FamilyMemberServiceTest extends PostgresIntegrationTest {

  @Autowired FamilyMemberService service;
  @Autowired AdminUserService adminUsers;
  @Autowired TestData data;

  private SaveFamilyMemberRequest req(Person hof, String its) {
    return new SaveFamilyMemberRequest(hof.getId(), " Fatema ", "Kanchwala", its, null);
  }

  @Test
  void createsUnderAnHofAndTrimsNames() {
    Person hof = data.person(true);
    FamilyMemberDto dto = service.create(req(hof, TestData.nextIts()));
    assertThat(dto.firstName()).isEqualTo("Fatema");
    assertThat(dto.active()).isTrue();
    assertThat(service.listByHof(hof.getId())).hasSize(1);
  }

  @Test
  void rejectsNonHofOwner() {
    Person notHof = data.person(false);
    assertThatThrownBy(() -> service.create(req(notHof, TestData.nextIts())))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("head of family");
  }

  @Test
  void rejectsBadOrDuplicateIts() {
    Person hof = data.person(true);
    assertThatThrownBy(() -> service.create(req(hof, "1234567")))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("8 digits");
    assertThatThrownBy(() -> service.create(req(hof, "1234567a")))
        .isInstanceOf(IllegalArgumentException.class);

    String its = TestData.nextIts();
    service.create(req(hof, its));
    assertThatThrownBy(() -> service.create(req(hof, its)))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("already saved");
  }

  @Test
  void rejectsItsBelongingToAnExistingUser() {
    Person hof = data.person(true);
    Person other = data.person(false);
    assertThatThrownBy(() -> service.create(req(hof, other.getItsNumber())))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("existing user");
  }

  @Test
  void updateAllowsKeepingOwnIts() {
    Person hof = data.person(true);
    String its = TestData.nextIts();
    FamilyMemberDto dto = service.create(req(hof, its));
    FamilyMemberDto updated = service.update(dto.id(),
        new SaveFamilyMemberRequest(hof.getId(), "Fatima", "Kanchwala", its, null));
    assertThat(updated.firstName()).isEqualTo("Fatima");
  }

  @Test
  void deactivateKeepsTheRow() {
    Person hof = data.person(true);
    FamilyMemberDto dto = service.create(req(hof, TestData.nextIts()));
    assertThat(service.setActive(dto.id(), false).active()).isFalse();
    assertThat(service.listByHof(hof.getId())).hasSize(1);
  }

  @Test
  void adminUserCreationRejectsAFamilyMemberIts() {
    Person hof = data.person(true);
    String its = TestData.nextIts();
    service.create(req(hof, its));
    CreateUserRequest create = new CreateUserRequest(its, "New", "User", "new" + its + "@example.com",
        null, "password1", null, Set.of("USER"), UserType.REGISTERED, null, true);
    assertThatThrownBy(() -> adminUsers.createUser(create))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("family member");
  }

  @Test
  void searchHofsFindsByNameAndCountsFamily() {
    Person hof = data.person(true);
    service.create(req(hof, TestData.nextIts()));
    assertThat(service.searchHofs(hof.getLastName()).stream().filter(h -> h.id().equals(hof.getId())))
        .singleElement().extracting(HofDto::familyMemberCount).isEqualTo(1L);
    assertThat(service.searchHofs("x")).isEmpty(); // fewer than 2 characters
  }
}
