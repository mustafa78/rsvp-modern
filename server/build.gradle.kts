plugins {
	id("org.springframework.boot") version "3.5.1"
	id("io.spring.dependency-management") version "1.1.6"
	id("org.flywaydb.flyway") version "11.10.0"
	java
}

group = "com.acme"
version = "0.1.0"

java {
	toolchain { languageVersion.set(JavaLanguageVersion.of(21)) }
}

/**
 * Put Flyway's Postgres database module on the *build classpath* so Gradle tasks like
 * flywayInfo/flywayMigrate can handle jdbc:postgresql URLs.
 */
buildscript {
    repositories { mavenCentral() }
    dependencies {
        classpath("org.flywaydb:flyway-database-postgresql:11.10.0")
        // (optional) also put the JDBC driver on the build classpath:
        classpath("org.postgresql:postgresql:42.7.4")
    }
}

repositories { mavenCentral() }

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("org.springframework.boot:spring-boot-starter-validation")
	implementation("org.springframework.boot:spring-boot-starter-data-jpa")
	implementation("org.springframework.boot:spring-boot-starter-security")
  
	// Keep app runtime in sync with the plugin 
	implementation("org.flywaydb:flyway-core:11.10.0")
    implementation("org.flywaydb:flyway-database-postgresql:11.10.0")
	
	// JDBC driver for your app
	runtimeOnly("org.postgresql:postgresql:42.7.4")
  
	testImplementation("org.springframework.boot:spring-boot-starter-test")
}

flyway {
    // keep creds out of source; these are fallbacks:
    url = System.getenv("SPRING_DATASOURCE_URL") ?: "jdbc:postgresql://localhost:5432/rsvp"
    user = System.getenv("SPRING_DATASOURCE_USERNAME") ?: "rsvp"
    password = System.getenv("SPRING_DATASOURCE_PASSWORD") ?: "rsvp"
    locations = arrayOf("filesystem:src/main/resources/db/migration")
}

tasks.test { useJUnitPlatform() }
