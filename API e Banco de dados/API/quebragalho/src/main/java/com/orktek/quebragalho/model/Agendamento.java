package com.orktek.quebragalho.model;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "agendamento")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Agendamento {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_agendamento")
    private Long id;
    
    @Column(name = "data_hora", nullable = false)
    private LocalDateTime dataHora;
    
    @Column(nullable = false)
    private Boolean status;
    
    @ManyToOne
    @JoinColumn(name = "id_servico_fk", nullable = false)
    private Servico servico;
    
    @ManyToOne
    @JoinColumn(name = "id_usuario_fk", nullable = false)
    private Usuario usuario;
    
    @OneToOne(mappedBy = "agendamento", cascade = CascadeType.ALL)
    private Avaliacao avaliacao;
}
