package com.orktek.quebragalho.dto;

import java.time.LocalDate;

import com.orktek.quebragalho.model.Avaliacao;

import io.swagger.v3.oas.annotations.media.Schema;

import lombok.Data;

@Data
public class AvaliacaoDTO {

    @Schema(description = "Identificador único da avaliação", example = "1")
    private Long id;

    @Schema(description = "Nota da avaliação", example = "5")
    private Integer nota;

    @Schema(description = "Comentário da avaliação", example = "Ótimo serviço!")
    private String comentario;

    @Schema(description = "Data da avaliação", example = "2023-10-01")
    private LocalDate data;

    @Schema(description = "Agendamento relacionado à avaliação")
    private AgendamentoDTO agendamento;


    public AvaliacaoDTO(Avaliacao avaliacao) {
        this.id = avaliacao.getId();
        this.nota = avaliacao.getNota();
        this.comentario = avaliacao.getComentario();
        this.data = avaliacao.getData();
        this.agendamento = new AgendamentoDTO(avaliacao.getAgendamento());
    }
}
