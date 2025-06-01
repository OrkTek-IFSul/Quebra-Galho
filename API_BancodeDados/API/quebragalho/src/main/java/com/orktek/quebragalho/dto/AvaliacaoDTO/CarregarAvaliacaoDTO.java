package com.orktek.quebragalho.dto.AvaliacaoDTO;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.orktek.quebragalho.model.Avaliacao;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class CarregarAvaliacaoDTO {

    @Schema(description = "Identificador único da avaliação", example = "1")
    private Long idAvaliacao;

    @Schema(description = "Nome do usuário que fez a avaliação", example = "João Silva")
    private String nomeUsuario;

    @Schema(description = "Nota da avaliação", example = "5")
    private Integer nota;

    @Schema(description = "Comentário da avaliação", example = "Ótimo serviço!")
    private String comentario;

    @Schema(description = "Nome do servico", example = "Serviço de Elétrica")
    private String nomeServico;

    @Schema(description = "Data da avaliação", example = "2023-10-01")
    private String data;

    
    public static CarregarAvaliacaoDTO fromEntity(Avaliacao avaliacao) {
        CarregarAvaliacaoDTO dto = new CarregarAvaliacaoDTO();
        dto.setIdAvaliacao(avaliacao.getId());
        dto.setNomeUsuario(avaliacao.getAgendamento().getUsuario().getNome());
        dto.setNota(avaliacao.getNota());
        dto.setComentario(avaliacao.getComentario());
        dto.setNomeServico(avaliacao.getAgendamento().getServico().getNome());
        dto.setData(avaliacao.getData());
        return dto;
    }

    public LocalDate getData() {
        if (this.data == null || this.data.isEmpty()) {
            return null;
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        return LocalDate.parse(this.data, formatter);
    }

    public void setData(LocalDate data) {
        if (data == null) {
            this.data = "";
        } else {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
            this.data = data.format(formatter);
        }
    }
}
