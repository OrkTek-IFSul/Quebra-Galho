package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

@Entity
@Table(name = "servico")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Servico {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_servico")
    @Schema(description = "Identificador único do serviço", example = "1")
    private Long id;
    
    @Column(nullable = false, length = 45)
    @Schema(description = "Nome do serviço", example = "Corte de cabelo")
    private String nome;
    
    @Column(nullable = false, length = 45)
    @Schema(description = "Descrição do serviço", example = "Corte de cabelo masculino")
    private String descricao;
    
    @Column(nullable = false)
    @Schema(description = "Preço do serviço", example = "50.0")
    private Double preco;
    
    @Column(nullable = false)
    @Schema(description = "Serviço ativo ou não", example = "true")
    private Boolean ativo;

    @ManyToOne
    @JoinColumn(name = "id_prestador_fk", nullable = false)
    @Schema(description = "Prestador responsável pelo serviço")
    private Prestador prestador;
    
    @OneToMany(mappedBy = "servico")
    @Schema(description = "Lista de agendamentos associados ao serviço")
    private List<Agendamento> agendamentos;
    
    @ManyToMany
    @JoinTable(
        name = "tag_servico",
        joinColumns = @JoinColumn(name = "id_servico_fk"),
        inverseJoinColumns = @JoinColumn(name = "id_tag_fk")
    )
    @Schema(description = "Lista de tags associadas ao serviço")
    private List<Tags> tags;
}
