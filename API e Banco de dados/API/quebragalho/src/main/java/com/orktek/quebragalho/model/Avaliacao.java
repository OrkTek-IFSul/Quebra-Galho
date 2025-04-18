package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Entity
@Table(name = "avaliacao")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Avaliacao {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_avaliacao")
    private Long id;
    
    @Column(nullable = false)
    private Integer nota;
    
    @Column(nullable = false, length = 200)
    private String comentario;
    
    @Column(nullable = false)
    private LocalDate data;
    
    @OneToOne
    @JoinColumn(name = "id_agendamento_fk", nullable = false)
    private Agendamento agendamento;
    
    @OneToOne(mappedBy = "avaliacao", cascade = CascadeType.ALL)
    private Resposta resposta;
}