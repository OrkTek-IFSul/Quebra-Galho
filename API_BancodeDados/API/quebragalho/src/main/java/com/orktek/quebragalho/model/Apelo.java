package com.orktek.quebragalho.model;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "apelo")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Apelo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_apelo")
    @Schema(description = "Identificador único do apelo", example = "1")
    private Long id;
    
    @Column(nullable = false, length = 100)
    @Schema(description = "Justificativa do apelo", example = "Necessidade de revisão urgente")
    private String justificativa;
    
    @Column(nullable = false)
    @Schema(description = "Status do apelo", example = "true")
    private Boolean status;
    
    @OneToOne
    @JoinColumn(name = "id_denuncia_fk", nullable = false)
    @Schema(description = "Denúncia associada ao apelo")
    private Denuncia denuncia;
}
