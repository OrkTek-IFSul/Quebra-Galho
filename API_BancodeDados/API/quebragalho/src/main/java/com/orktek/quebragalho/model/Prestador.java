package com.orktek.quebragalho.model;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "prestador")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
@Schema(description = "Representa um prestador de serviços")
public class Prestador {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_prestador")
    @Schema(description = "Identificador único do prestador", example = "1")
    private Long id;
    
    @Column(name = "descricao_prestador", nullable = false, length = 200)
    @Schema(description = "Descrição do prestador", example = "Prestador especializado em serviços elétricos")
    private String descricao;
    
    @Column(name = "data_hora_inicio")
    @Schema(description = "Início do horário disponível", example = "Prestador especializado em serviços elétricos")
    private LocalDateTime dataHoraInicio;
    
    @Column(name = "data_hora_fim")
    @Schema(description = "Fim do horário disponível", example = "Prestador especializado em serviços elétricos")
    private LocalDateTime dataHoraFim;
    
    @Column(name = "documento_path", nullable = false, length = 100)
    @Schema(description = "Caminho do documento do prestador", example = "/img/prestador123.jpeg")
    private String documentoPath;
    
    @OneToOne
    @JoinColumn(name = "id_usuario_fk", nullable = false)
    @Schema(description = "Usuário associado ao prestador")
    private Usuario usuario;
    
    @OneToMany(mappedBy = "prestador")
    @Schema(description = "Lista de serviços oferecidos pelo prestador")
    private List<Servico> servicos;
    
    @OneToMany(mappedBy = "prestador")
    @Schema(description = "Portfólios associados ao prestador")
    private List<Portfolio> portfolios;
    
    @OneToMany(mappedBy = "prestador")
    @Schema(description = "Chats relacionados ao prestador")
    private List<Chat> chats;
    
    @ManyToMany
    @JoinTable(
        name = "tag_prestador",
        joinColumns = @JoinColumn(name = "id_prestador_fk"),
        inverseJoinColumns = @JoinColumn(name = "id_tag_fk")
    )
    @Schema(description = "Tags associadas ao prestador")
    private List<Tags> tags;
}