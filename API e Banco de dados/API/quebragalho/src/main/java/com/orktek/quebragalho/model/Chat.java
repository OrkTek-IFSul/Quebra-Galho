package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Entity
@Table(name = "chat")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Chat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_chat")
    private Long id;
    
    @Column(nullable = false, length = 200)
    private String mensagens;
    
    @Column(nullable = false)
    private LocalDate data;
    
    @ManyToOne
    @JoinColumn(name = "id_prestador_fk", nullable = false)
    private Prestador prestador;
    
    @ManyToOne
    @JoinColumn(name = "id_usuario_fk", nullable = false)
    private Usuario usuario;
}
