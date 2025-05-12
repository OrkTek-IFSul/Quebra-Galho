package com.orktek.quebragalho.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.orktek.quebragalho.model.Usuario;

import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    Optional<Usuario> findByEmail(String email);

    boolean existsByEmail(String email);

    boolean existsByDocumento(String documento);

    Optional<Usuario> findByDocumento(String documento);

    boolean existsByEmailAndIdNot(String email, Long id);
    
    boolean existsByDocumentoAndIdNot(String documento, Long id);
}