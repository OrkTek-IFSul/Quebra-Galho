package com.orktek.quebragalho.model;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Entity
@Table(name = "resposta")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Resposta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_resposta")
    @Schema(description = "Identificador único da resposta", example = "1")
    private Long id;
    
    @Column(name = "comentario_resposta", nullable = false, length = 100)
    @Schema(description = "Comentário da resposta", example = "Esta é uma resposta.")
    private String resposta;
    
    @Column(nullable = false)
    @Schema(description = "Data da resposta", example = "2023-10-01")
    private LocalDate data;
    
    @OneToOne
    @JoinColumn(name = "id_avaliacao_fk", nullable = false)
    @Schema(description = "Avaliação associada à resposta")
    private Avaliacao avaliacao;
}
