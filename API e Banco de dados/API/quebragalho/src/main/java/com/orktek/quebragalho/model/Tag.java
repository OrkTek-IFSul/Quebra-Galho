package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Table(name = "tag")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Tag {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_tag")
    private Long id;
    
    @Column(nullable = false, length = 45)
    private String nome;
    
    @Column(nullable = false, length = 45)
    private String status;
    
    @ManyToMany(mappedBy = "tags")
    private List<Prestador> prestadores;
    
    @ManyToMany(mappedBy = "tags")
    private List<Servico> servicos;
}