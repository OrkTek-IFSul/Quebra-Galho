package com.orktek.quebragalho.repository;

import com.orktek.quebragalho.model.Servico;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ServicoRepository extends JpaRepository<Servico, Long> {
    List<Servico> findByPrestadorId(Long prestadorId);
    List<Servico> findByPrecoBetween(Double precoMin, Double precoMax);
    Optional<Servico> findByIdAndPrestadorId(Long idServico, Long idPrestador);
    List<Servico> findByPrestadorIdAndAtivo(Long prestadorId, boolean ativo);
}