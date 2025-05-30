package com.orktek.quebragalho.model;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "denuncia")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Denuncia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_denuncia")
    @Schema(description = "Identificador único da denúncia", example = "1")
    private Long id;
    
    @Column(nullable = false, length = 45)
    @Schema(description = "Tipo da denúncia", example = "Abuso")
    private String tipo;
    
    @Column(nullable = false, length = 100)
    @Schema(description = "Motivo da denúncia", example = "Conteúdo impróprio")
    private String motivo;
    
    @Column(nullable = false)
    @Schema(description = "Status da denúncia", example = "true")
    private Boolean status;
    
    @Column(name = "id_comentario")
    @Schema(description = "Identificador do comentário relacionado à denúncia", example = "10")
    private Long idComentario;
    
    @ManyToOne
    @JoinColumn(name = "id_denunciante", nullable = false)
    @Schema(description = "Usuário que realizou a denúncia")
    private Usuario denunciante;
    
    @ManyToOne
    @JoinColumn(name = "id_denunciado", nullable = false)
    @Schema(description = "Usuário que foi denunciado")
    private Usuario denunciado;
    
    @OneToOne(mappedBy = "denuncia", cascade = CascadeType.ALL)
    @Schema(description = "Apelo relacionado à denúncia")
    private Apelo apelo;
}