package com.orktek.quebragalho.model;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Table(name = "tag")
// GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Tags {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_tag")
    @Schema(description = "Identificador único da tag", example = "1")
    private Long id;

    @Column(nullable = false, length = 45)
    @Schema(description = "Nome da tag", example = "Tecnologia")
    private String nome;

    @Column(nullable = false, length = 45)
    @Schema(description = "Status da tag", example = "Ativo")
    private String status;

    @ManyToMany(mappedBy = "tags")
    @Schema(description = "Lista de prestadores associados à tag")
    private List<Prestador> prestadores;

    @ManyToMany(mappedBy = "tags")
    @Schema(description = "Lista de serviços associados à tag")
    private List<Servico> servicos;
}