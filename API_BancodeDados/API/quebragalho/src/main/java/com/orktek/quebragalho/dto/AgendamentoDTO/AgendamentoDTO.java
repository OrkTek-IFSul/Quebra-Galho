package com.orktek.quebragalho.dto.AgendamentoDTO;

import java.time.LocalDateTime;

import com.orktek.quebragalho.model.Agendamento;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para enviar informações de um agendamento")
public class AgendamentoDTO {
    
    @Schema(description = "Id do usuário que irá solicitar o agendamento", example = "1")
    private Long id_usuario;
    @Schema(description = "Id do prestador que irá realizar o agendamento", example = "1")
    private Long id_servico;
    @Schema(description = "Data e hora do agendamento", example = "2023-10-01T10:00:00")
    private LocalDateTime data_hora;

    public static AgendamentoDTO fromEntity(Agendamento agendamento) {
        AgendamentoDTO dto = new AgendamentoDTO();
        dto.setId_usuario(agendamento.getUsuario().getId());
        dto.setId_servico(agendamento.getServico().getPrestador().getId());
        dto.setData_hora(agendamento.getDataHora());
        return dto;
    }
}
