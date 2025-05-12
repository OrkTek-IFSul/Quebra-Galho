package com.orktek.quebragalho.model;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "agendamento")
// GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Agendamento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_agendamento")
    @Schema(description = "Identificador único do agendamento", example = "1")
    private Long id;

    @Column(name = "data_hora", nullable = false)
    @Schema(description = "Data e hora do agendamento", example = "2023-12-01T14:30:00")
    private LocalDateTime dataHora;

    @Column(name = "status", nullable = false)
    @Schema(description = "Status do agendamento", example = "true")
    private Boolean status;

    @Column(name = "status_aceito")
    @Schema(description = "Status de aceitação do agendamento", example = "true")
    private Boolean statusAceito;

    @ManyToOne
    @JoinColumn(name = "id_servico_fk", nullable = false)
    @Schema(description = "Serviço relacionado ao agendamento")
    private Servico servico;

    @ManyToOne
    @JoinColumn(name = "id_usuario_fk", nullable = false)
    @Schema(description = "Usuário que realizou o agendamento")
    private Usuario usuario;

    @OneToOne(mappedBy = "agendamento", cascade = CascadeType.ALL)
    @Schema(description = "Avaliação associada ao agendamento")
    private Avaliacao avaliacao;

}
