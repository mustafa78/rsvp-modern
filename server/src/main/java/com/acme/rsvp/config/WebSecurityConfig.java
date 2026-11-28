package com.acme.rsvp.config;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.acme.rsvp.security.SessionAuthFilter;

@Configuration
public class WebSecurityConfig {

	private final SessionAuthFilter sessionAuthFilter;

	@Value("${cors.allowed-origins:http://localhost:5173}")
	private String allowedOrigins;

	public WebSecurityConfig(SessionAuthFilter sessionAuthFilter) {
		this.sessionAuthFilter = sessionAuthFilter;
	}

	// Role names as stored in the roles table. SessionAuthFilter turns each into ROLE_<name>.
	private static final String ADMIN = "ADMIN";
	private static final String NIYAZ = "NIYAZ_COORDINATOR";
	private static final String THAALI = "THAALI_COORDINATOR";
	private static final String MENU = "MENU_COORDINATOR";
	private static final String SHOPPING = "SHOPPING_COORDINATOR";
	private static final String DANA = "DANA_COORDINATOR";
	private static final String WEBINAR = "WEBINAR_COORDINATOR";

	/** Everyone who works in the admin area. */
	private static final String[] STAFF = { ADMIN, NIYAZ, THAALI, MENU, SHOPPING, DANA, WEBINAR };

	/**
	 * Who may call what. This is the only place access is decided.
	 *
	 * <p>Rules are checked top to bottom and the first match wins, so a specific path must come
	 * before a wider one that would also match it.
	 *
	 * <p><b>Any /api endpoint without a rule here is ADMIN only.</b> When you add an endpoint that
	 * members or coordinators need, add its rule here and a line in EndpointAccessTest.
	 */
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
	    http
	      .csrf(csrf -> csrf.disable())
	      .cors(Customizer.withDefaults())
	      .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
	      .authorizeHttpRequests(auth -> auth

	        // ---- No login needed
	        .requestMatchers(HttpMethod.POST,
	            "/api/auth/login",
	            "/api/auth/register",
	            "/api/auth/password/reset/request",
	            "/api/auth/password/reset/confirm",
	            "/api/auth/password/change-unauthenticated").permitAll()
	        .requestMatchers(HttpMethod.GET,
	            "/api/auth/pickup-zones",
	            "/api/events/public",
	            "/api/events/{id}",
	            "/api/niyaz/{eventId}/rsvp/summary",
	            "/api/webinars/public/**").permitAll()   // join links: the token in the path is the credential

	        // ---- Any logged-in member: own account, own RSVP, own thaali order
	        .requestMatchers("/api/auth/**", "/api/profile/**").authenticated()
	        .requestMatchers(HttpMethod.GET,
	            "/api/thaali/{id}",
	            "/api/niyaz/{id}",
	            "/api/pickup-zones", "/api/pickup-zones/**",
	            "/api/announcements", "/api/announcements/unread-count").authenticated()
	        .requestMatchers(HttpMethod.POST,
	            "/api/niyaz/{eventId}/rsvp",
	            "/api/thaali/{eventId}/orders",
	            "/api/announcements/{id}/read", "/api/announcements/read-all").authenticated()
	        .requestMatchers("/api/niyaz/{eventId}/rsvp/my", "/api/thaali/{eventId}/orders/my").authenticated()

	        // ---- Webinars: managing them, and family members
	        .requestMatchers("/api/webinars/admin", "/api/webinars/admin/**",
	            "/api/admin/family-members", "/api/admin/family-members/**").hasAnyRole(ADMIN, WEBINAR)
	        // ---- Webinars: a member's own list and joining from the portal
	        .requestMatchers(HttpMethod.GET, "/api/webinars", "/api/webinars/{id}/launch").authenticated()

	        // ---- Events
	        .requestMatchers(HttpMethod.GET, "/api/events").hasAnyRole(STAFF)
	        .requestMatchers("/api/events/niyaz", "/api/events/niyaz/**").hasAnyRole(ADMIN, NIYAZ)
	        .requestMatchers("/api/events/thaali", "/api/events/thaali/**").hasAnyRole(ADMIN, THAALI)
	        .requestMatchers(HttpMethod.POST, "/api/events/{id}/publish", "/api/events/{id}/cancel")
	            .hasAnyRole(ADMIN, NIYAZ, THAALI)
	        .requestMatchers(HttpMethod.GET, "/api/events/{id}/chefs", "/api/events/{id}/menu").hasAnyRole(STAFF)
	        .requestMatchers(HttpMethod.POST, "/api/events/{id}/chefs", "/api/events/{id}/menu")
	            .hasAnyRole(ADMIN, THAALI, MENU)

	        // ---- Niyaz RSVP report, and RSVPs entered on a member's behalf
	        .requestMatchers("/api/niyaz/{eventId}/rsvp/**").hasAnyRole(ADMIN, NIYAZ, DANA)

	        // ---- Thaali reports. Shopping coordinator: totals and shopping lists, not individual families.
	        .requestMatchers(HttpMethod.GET,
	            "/api/thaali/{eventId}/orders/counts",
	            "/api/thaali/{eventId}/orders/detailed-report",
	            "/api/thaali/{eventId}/orders/shopping-list",
	            "/api/thaali/{eventId}/orders/shopping-list-per-dish").hasAnyRole(ADMIN, THAALI, SHOPPING)
	        .requestMatchers("/api/thaali/{eventId}/orders", "/api/thaali/{eventId}/orders/**")
	            .hasAnyRole(ADMIN, THAALI)

	        // ---- Catalog: every staff role may read; who may change depends on the list
	        .requestMatchers(HttpMethod.GET,
	            "/api/dishes", "/api/dishes/**",
	            "/api/chefs", "/api/chefs/**",
	            "/api/ingredients", "/api/ingredients/**",
	            "/api/ingredient-lookups/**").hasAnyRole(STAFF)
	        .requestMatchers("/api/dishes", "/api/dishes/**", "/api/chefs", "/api/chefs/**")
	            .hasAnyRole(ADMIN, MENU)
	        .requestMatchers("/api/ingredients", "/api/ingredients/**",
	            "/api/ingredient-lookups/categories", "/api/ingredient-lookups/categories/**",
	            "/api/ingredient-lookups/units", "/api/ingredient-lookups/units/**")
	            .hasAnyRole(ADMIN, MENU, SHOPPING)
	        .requestMatchers(
	            "/api/ingredient-lookups/stores", "/api/ingredient-lookups/stores/**",
	            "/api/ingredient-lookups/storage-locations", "/api/ingredient-lookups/storage-locations/**")
	            .hasAnyRole(ADMIN, SHOPPING)

	        // ---- Announcements: creating and managing (reading is in the member block above)
	        .requestMatchers("/api/announcements", "/api/announcements/**").hasAnyRole(ADMIN, NIYAZ, THAALI)

	        // ---- User list, read only: a Niyaz coordinator picks the event host from it
	        .requestMatchers(HttpMethod.GET, "/api/admin/users").hasAnyRole(ADMIN, NIYAZ)

	        // ---- Everything else under /api is ADMIN only: users, roles, pickup zone changes,
	        //      and any endpoint added later without a rule of its own.
	        .requestMatchers("/api/**").hasRole(ADMIN)
	        .anyRequest().authenticated()
	      );
	    http.addFilterBefore(sessionAuthFilter,
	        UsernamePasswordAuthenticationFilter.class);
	    return http.build();
	}

	@Bean
	public CorsConfigurationSource corsConfigurationSource() {
		CorsConfiguration cfg = new CorsConfiguration();
		// IMPORTANT: with credentials=true, do NOT use "*" here.
		// Parse comma-separated origins from environment variable
		List<String> origins = Arrays.stream(allowedOrigins.split(","))
				.map(String::trim)
				.toList();
		cfg.setAllowedOrigins(origins);
		cfg.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
		cfg.setAllowedHeaders(List.of("*"));
		cfg.setAllowCredentials(true);

		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", cfg);
		return source;
	}

}
