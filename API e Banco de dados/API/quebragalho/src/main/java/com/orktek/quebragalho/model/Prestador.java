package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Table(name = "prestador")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Prestador {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_prestador")
    private Long id;
    
    @Column(name = "descricao_prestador", nullable = false, length = 200)
    private String descricao;
    
    @Column(name = "documento_path", nullable = false, length = 100)
    private String documentoPath;
    
    @OneToOne
    @JoinColumn(name = "id_usuario_fk", nullable = false)
    private Usuario usuario;
    
    @OneToMany(mappedBy = "prestador")
    private List<Servico> servicos;
    
    @OneToMany(mappedBy = "prestador")
    private List<Portfolio> portfolios;
    
    @OneToMany(mappedBy = "prestador")
    private List<Chat> chats;
    
    @ManyToMany
    @JoinTable(
        name = "tag_prestador",
        joinColumns = @JoinColumn(name = "id_prestador_fk"),
        inverseJoinColumns = @JoinColumn(name = "id_tag_fk")
    )
    private List<Tag> tags;
}