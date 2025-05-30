package com.orktek.quebragalho.dto.AgendamentoDTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para criar um agendamento")
public class AgendamentoRetornoDTO {

    @Schema(description = "Nome do usuário que irá solicitar o agendamento", example = "1")
    private String usuario;
    
    @Schema(description = "Nome do prestador que irá realizar o agendamento", example = "1")
    private String prestador;

    @Schema(description = "nome do serviço", example = "Corte de cabelo")
    private String servico;

    @Schema(description = "descricao do serviço", example = "Corte de cabelo")
    private String descricao_servico;

    @Schema(description = "preco do serviço", example = "50.0")
    private Double preco_servico;

    @Schema(description = "Data e hora do agendamento", example = "2023-10-01T10:00:00")
    private String horario;

    
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
