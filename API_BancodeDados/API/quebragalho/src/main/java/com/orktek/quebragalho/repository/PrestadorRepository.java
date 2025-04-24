package com.orktek.quebragalho.repository;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Usuario;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PrestadorRepository extends JpaRepository<Prestador, Long> {
    boolean existsByUsuario(Usuario usuario);
    Optional<Prestador> findByUsuarioId(Long usuarioId);
}