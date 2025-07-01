package com.orktek.quebragalho.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.orktek.quebragalho.model.Usuario;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    Optional<Usuario> findByEmail(String email);

    boolean existsByEmail(String email);

    boolean existsByDocumento(String documento);

    Optional<Usuario> findByDocumento(String documento);

    boolean existsByEmailAndIdNot(String email, Long id);

    boolean existsByDocumentoAndIdNot(String documento, Long id);

    @Query("SELECT u FROM Usuario u " +
            "WHERE (:nome IS NULL OR :nome = '' OR LOWER(u.nome) LIKE LOWER(CONCAT('%', :nome, '%'))) " +
            "AND (:isModerador IS NULL OR u.isModerador = :isModerador)")
    Page<Usuario> buscarPorNomeEModerador(
            @Param("nome") String nome,
            @Param("isModerador") Boolean isModerador,
            Pageable pageable);
}