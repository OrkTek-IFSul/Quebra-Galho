package com.orktek.quebragalho.dto.PrestadorDTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import com.orktek.quebragalho.dto.UsuarioDTO.UsuarioGenericoDTO;
import com.orktek.quebragalho.model.Prestador;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para atualizar perfil de prestador")
public class AtualizarPrestadorDTO {

    @Schema(description = "Descrição do prestador", example = "Prestador especializado em serviços elétricos")
    private String descricao;

    @Schema(description = "Usuario do prestador")
    private UsuarioGenericoDTO usuario;

    @Schema(description = "Horario de inicio", example = "2025-05-01T08:00:00")
    private String horarioInicio;

    @Schema(description = "Horario de encerramento", example = "2025-05-01T08:00:00")
    private String horarioFim;

    public static AtualizarPrestadorDTO fromEntity(Prestador prestador) {
        AtualizarPrestadorDTO dto = new AtualizarPrestadorDTO();
        dto.setDescricao(prestador.getDescricao());
        dto.setUsuario(UsuarioGenericoDTO.fromEntity(prestador.getUsuario()));
        dto.setHorarioInicio(prestador.getDataHoraInicio());
        dto.setHorarioFim(prestador.getDataHoraFim());
        return dto;
    }

    public LocalDateTime getHorarioInicio() {
        if (this.horarioInicio == null || this.horarioInicio.isEmpty()) {
            return null;
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return LocalDateTime.parse(this.horarioInicio, formatter);
    }

    public LocalDateTime getHorarioFim() {
        if (this.horarioFim == null || this.horarioFim.isEmpty()) {
            return null;
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return LocalDateTime.parse(this.horarioFim, formatter);
    }

    public void setHorarioInicio(LocalDateTime horarioInicio) {
        if (horarioInicio == null) {
            this.horarioInicio = "";
        } else {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            this.horarioInicio = horarioInicio.format(formatter);
        }
    }

    public void setHorarioFim(LocalDateTime horarioFim) {
        if (horarioFim == null) {
            this.horarioFim = "";
        } else {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            this.horarioFim = horarioFim.format(formatter);
        }
    }
}