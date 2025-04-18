package com.orktek.quebragalho.model;

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
    private Long id;
    
    @Column(name = "comentario_resposta", nullable = false, length = 100)
    private String comentario;
    
    @Column(nullable = false)
    private LocalDate data;
    
    @OneToOne
    @JoinColumn(name = "id_avaliacao_fk", nullable = false)
    private Avaliacao avaliacao;

    public void setComentarioResposta(String novoComentario) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'setComentarioResposta'");
    }
}
