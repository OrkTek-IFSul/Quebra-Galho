package com.orktek.quebragalho.model;

import io.swagger.v3.oas.annotations.media.Schema;
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
    @Schema(description = "Identificador único do chat", example = "1")
    private Long id;

    @Column(nullable = false, length = 200)
    @Schema(description = "Mensagens trocadas no chat", example = "Olá, tudo bem?")
    private String mensagens;

    @Column(nullable = false)
    @Schema(description = "Data da mensagem", example = "2023-01-01")
    private LocalDate data;

    @ManyToOne
    @JoinColumn(name = "id_prestador_fk", nullable = false)
    @Schema(description = "Prestador associado ao chat")
    private Prestador prestador;

    @ManyToOne
    @JoinColumn(name = "id_usuario_fk", nullable = false)
    @Schema(description = "Usuário associado ao chat")
    private Usuario usuario;
}
