package com.orktek.quebragalho.repository;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Usuario;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PrestadorRepository extends JpaRepository<Prestador, Long> {
        boolean existsByUsuario(Usuario usuario);

        Optional<Prestador> findByUsuarioId(Long usuarioId);

        @Query("SELECT p FROM Prestador p JOIN p.usuario u LEFT JOIN p.tags t " +
                        "WHERE (:nome IS NULL OR :nome = '' OR LOWER(u.nome) LIKE LOWER(CONCAT('%', :nome, '%'))) " +
                        "AND (:tags IS NULL OR LOWER(t.nome) IN :tags) " +
                        "GROUP BY p.id")
        Page<Prestador> buscarPorNomeEPorTags(
                        @Param("nome") String nome,
                        @Param("tags") List<String> tags,
                        Pageable pageable);
}
