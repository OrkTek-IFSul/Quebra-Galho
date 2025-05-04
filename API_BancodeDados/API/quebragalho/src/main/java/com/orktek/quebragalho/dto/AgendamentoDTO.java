package com.orktek.quebragalho.dto;

import java.time.LocalDateTime;

import com.orktek.quebragalho.model.Agendamento;
import io.swagger.v3.oas.annotations.media.Schema;

public class AgendamentoDTO {
    @Schema(description = "Identificador único do agendamento", example = "1")
    private Long id;

    @Schema(description = "Data e hora do agendamento", example = "2023-12-01T14:30:00")
    private LocalDateTime dataHora;
    
    @Schema(description = "Status do agendamento", example = "true")
    private Boolean status;

    @Schema(description = "Serviço relacionado ao agendamento")
    private ServicoDTO servico;

    @Schema(description = "Prestador que realizou o servico")
    private PrestadorDTO prestador;

    @Schema(description = "Usuário que realizou o agendamento")
    private UsuarioDTO usuario;

    public AgendamentoDTO(Agendamento agendamento) {
        this.id = agendamento.getId();
        this.dataHora = agendamento.getDataHora();
        this.status = agendamento.getStatus();
        this.servico = new ServicoDTO(agendamento.getServico());
        this.prestador = new PrestadorDTO(agendamento.getServico().getPrestador());
        this.usuario = new UsuarioDTO(agendamento.getUsuario());
    }
}
