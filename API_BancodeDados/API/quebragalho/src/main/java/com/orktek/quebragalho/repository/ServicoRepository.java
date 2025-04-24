package com.orktek.quebragalho.repository;

import com.orktek.quebragalho.model.Servico;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ServicoRepository extends JpaRepository<Servico, Long> {
    List<Servico> findByPrestadorId(Long prestadorId);
    List<Servico> findByPrecoBetween(Double precoMin, Double precoMax);
}