package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;
import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDate;

@Entity
@Table(name = "avaliacao")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Avaliacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_avaliacao")
    @Schema(description = "Identificador único da avaliação", example = "1")
    private Long id;

    @Column(nullable = false)
    @Schema(description = "Nota da avaliação", example = "5")
    private Integer nota;

    @Column(nullable = false, length = 200)
    @Schema(description = "Comentário da avaliação", example = "Ótimo serviço!")
    private String comentario;

    @Column(nullable = false)
    @Schema(description = "Data da avaliação", example = "2023-10-01")
    private LocalDate data;

    @OneToOne
    @JoinColumn(name = "id_agendamento_fk", nullable = false)
    @Schema(description = "Agendamento relacionado à avaliação")
    private Agendamento agendamento;

    @OneToOne(mappedBy = "avaliacao", cascade = CascadeType.ALL)
    @Schema(description = "Resposta associada à avaliação")
    private Resposta resposta;
}