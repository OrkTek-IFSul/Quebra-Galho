package com.orktek.quebragalho.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Avaliacao;

@Repository
public interface AvaliacaoRepository extends JpaRepository<Avaliacao, Long> {

    boolean existsByAgendamento(Agendamento agendamento);

    List<Avaliacao> findByAgendamentoServicoId(Long servicoId);

    @Query(value = "SELECT AVG(a.nota) FROM quebragalhodb.avaliacao a " +
            "JOIN quebragalhodb.agendamento ag ON a.id_agendamento_fk = ag.id_agendamento " +
            "JOIN quebragalhodb.servico s ON ag.id_servico_fk = s.id_servico " +
            "WHERE s.id_prestador_fk = :idPrestador", nativeQuery = true)
    Double calcularMediaAvaliacoesPorPrestador(@Param("idPrestador") Long idPrestador);
}
