package com.orktek.quebragalho.repository;

import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Servico;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AgendamentoRepository extends JpaRepository<Agendamento, Long> {
    List<Agendamento> findByUsuarioId(Long usuarioId);

    List<Agendamento> findByServico_IdAndDataHoraBetween(Long servicoId, LocalDateTime inicio, LocalDateTime fim);

    List<Agendamento> findByServicoPrestadorId(Long prestadorId);

    boolean existsByDataHoraAndServico(LocalDateTime dataHora, Servico servico);

    List<Agendamento> findByStatusAceitoIsNull();
}