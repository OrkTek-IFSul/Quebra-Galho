package com.orktek.quebragalho.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Avaliacao;

@Repository
public interface AvaliacaoRepository extends JpaRepository<Avaliacao, Long> {

    boolean existsByAgendamento(Agendamento agendamento);

    List<Avaliacao> findByAgendamentoServicoId(Long servicoId);

}
