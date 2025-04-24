package com.orktek.quebragalho.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.orktek.quebragalho.model.Chat;

@Repository
public interface ChatRepository extends JpaRepository<Chat, Long> {

    List<Chat> findByUsuarioIdAndPrestadorIdOrderByData(Long usuarioId, Long prestadorId);

    List<Chat> findByUsuarioIdOrderByData(Long usuarioId);

    List<Chat> findByPrestadorIdOrderByData(Long prestadorId);

}
