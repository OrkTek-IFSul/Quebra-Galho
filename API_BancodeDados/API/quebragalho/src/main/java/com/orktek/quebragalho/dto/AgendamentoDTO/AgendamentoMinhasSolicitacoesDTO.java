package com.orktek.quebragalho.dto.AgendamentoDTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Prestador;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para enviar informações de um agendamento")
public class AgendamentoMinhasSolicitacoesDTO {

    @Schema(description = "Id do agendamento", example = "1")
    private Long id_agendamento;
    @Schema(description = "Data e hora do agendamento", example = "2023-10-01T10:00:00")
    private String horario;
    @Schema(description = "Status de pedido completo", example = "false")
    private Boolean status_servico;
    @Schema(description = "Status de pedido aceito", example = "true")
    private Boolean status_aceito;
    @Schema(description = "Nome do prestador", example = "João Silva")
    private String nome_prestador;

    public static AgendamentoMinhasSolicitacoesDTO fromEntity(Agendamento agendamento, Prestador prestador) {
        AgendamentoMinhasSolicitacoesDTO dto = new AgendamentoMinhasSolicitacoesDTO();
        dto.setId_agendamento(agendamento.getId());
        dto.setHorario(agendamento.getDataHora());
        dto.setStatus_servico(agendamento.getStatus());
        dto.setStatus_aceito(agendamento.getStatusAceito());
        dto.setNome_prestador(prestador.getUsuario().getNome());
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
