package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Table(name = "servico")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Servico {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_servico")
    private Long id;
    
    @Column(nullable = false, length = 45)
    private String nome;
    
    @Column(nullable = false, length = 45)
    private String descricao;
    
    @Column(nullable = false)
    private Double preco;
    
    @ManyToOne
    @JoinColumn(name = "id_prestador_fk", nullable = false)
    private Prestador prestador;
    
    @OneToMany(mappedBy = "servico")
    private List<Agendamento> agendamentos;
    
    @ManyToMany
    @JoinTable(
        name = "tag_servico",
        joinColumns = @JoinColumn(name = "id_servico_fk"),
        inverseJoinColumns = @JoinColumn(name = "id_tag_fk")
    )
    private List<Tag> tags;
}
