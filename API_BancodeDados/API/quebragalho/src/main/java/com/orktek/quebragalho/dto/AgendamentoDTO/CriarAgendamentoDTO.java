package com.orktek.quebragalho.dto.AgendamentoDTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.orktek.quebragalho.model.Agendamento;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para criar um agendamento")
public class CriarAgendamentoDTO {
    
    @Schema(description = "Id do usuário que irá solicitar o agendamento", example = "1")
    private Long id_usuario;
    @Schema(description = "Id do prestador que irá realizar o agendamento", example = "1")
    private Long id_servico;
    @Schema(description = "Data e hora do agendamento", example = "2023-10-01T10:00:00")
    private String horario;

    public static CriarAgendamentoDTO fromEntity(Agendamento agendamento) {
        CriarAgendamentoDTO dto = new CriarAgendamentoDTO();
        dto.setId_usuario(agendamento.getUsuario().getId());
        dto.setId_servico(agendamento.getServico().getId());
        dto.setHorario(agendamento.getDataHora());
        return dto;
    }

    
    public LocalDateTime getHorario() {
        if (this.horario == null || this.horario.isEmpty()) {
            return null;
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return LocalDateTime.parse(this.horario, formatter);
    }

    public void setHorario(LocalDateTime horario) {
        if (horario == null) {
            this.horario = "";
        } else {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            this.horario = horario.format(formatter);
        }
    }
}
