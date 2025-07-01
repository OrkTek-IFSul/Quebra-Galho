package com.orktek.quebragalho.repository;

import com.orktek.quebragalho.dto.AgendamentoDTO.AgendamentoInfoDTO;
import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Servico;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AgendamentoRepository extends JpaRepository<Agendamento, Long> {
    List<Agendamento> findByUsuarioId(Long usuarioId);

    List<Agendamento> findByServico_IdAndDataHoraBetween(Long servicoId, LocalDateTime inicio, LocalDateTime fim);

    List<Agendamento> findByServicoPrestadorId(Long prestadorId);

    boolean existsByDataHoraAndServico(LocalDateTime dataHora, Servico servico);

    List<Agendamento> findByStatusAceitoIsNull();
    @Query(value = """
        SELECT
            a.data_hora AS inicio_agendamento,
            s.duracao_minutos AS duracao_agendamento
        FROM
            agendamento a
        JOIN
            servico s ON a.id_servico_fk = s.id_servico
        WHERE
            s.id_prestador_fk = :idPrestador
            AND DATE(a.data_hora) = :data
            AND a.status_aceito = 1
        ORDER BY
            a.data_hora ASC
    """, nativeQuery = true)
    List<AgendamentoInfoDTO> findAgendamentosConfirmadosDoDia(
        @Param("idPrestador") Long idPrestador,
        @Param("data") LocalDate data
    );

}