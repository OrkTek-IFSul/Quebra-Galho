package com.orktek.quebragalho.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.orktek.quebragalho.model.Avaliacao;
import com.orktek.quebragalho.model.Resposta;

@Repository
public interface RespostaRepository extends JpaRepository<Resposta, Long> {
    
    boolean existsByAvaliacao(Avaliacao avaliacao);
    Resposta findByAvaliacaoId(Long avaliacaoId);
   
}
