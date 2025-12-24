package com.acme.rsvp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.ThaaliOrderItem;

public interface ThaaliOrderItemRepository extends JpaRepository<ThaaliOrderItem, Long> {

    @Query("SELECT oi FROM ThaaliOrderItem oi WHERE oi.order.id = :orderId")
    List<ThaaliOrderItem> findByOrderId(@Param("orderId") Long orderId);

    @Query("SELECT oi FROM ThaaliOrderItem oi WHERE oi.order.event.id = :eventId")
    List<ThaaliOrderItem> findByEventId(@Param("eventId") Long eventId);

    @Query("SELECT COUNT(oi) FROM ThaaliOrderItem oi WHERE oi.order.event.id = :eventId AND oi.size = 'LARGE'")
    long countLargeByEventId(@Param("eventId") Long eventId);

    @Query("SELECT COUNT(oi) FROM ThaaliOrderItem oi WHERE oi.order.event.id = :eventId AND oi.size = 'SMALL'")
    long countSmallByEventId(@Param("eventId") Long eventId);

    @Query("SELECT COUNT(oi) FROM ThaaliOrderItem oi WHERE oi.order.event.id = :eventId AND oi.size = 'BARAKATI'")
    long countBarakatiByEventId(@Param("eventId") Long eventId);
}
