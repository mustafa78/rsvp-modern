plugins {
  id("org.springframework.boot") version "3.5.1"
  id("io.spring.dependency-management") version "1.1.6"
  java
}

group = "com.acme"
version = "0.1.0"

java {
  toolchain { languageVersion.set(JavaLanguageVersion.of(21)) }
}

repositories { mavenCentral() }

dependencies {
  implementation("org.springframework.boot:spring-boot-starter-web")
  implementation("org.springframework.boot:spring-boot-starter-validation")
  implementation("org.springframework.boot:spring-boot-starter-data-jpa")
  implementation("org.springframework.boot:spring-boot-starter-security")
  implementation("org.flywaydb:flyway-core:11.10.0")
  implementation("org.flywaydb:flyway-database-postgresql:11.10.0")
  runtimeOnly("org.postgresql:postgresql:42.7.4")

  testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.test { useJUnitPlatform() }
