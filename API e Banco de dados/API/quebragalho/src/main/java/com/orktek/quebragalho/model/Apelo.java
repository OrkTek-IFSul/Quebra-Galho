package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "apelo")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Apelo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_apelo")
    private Long id;
    
    @Column(nullable = false, length = 50)
    private String justificativa;
    
    @Column(nullable = false)
    private Boolean status;
    
    @OneToOne
    @JoinColumn(name = "id_denuncia_fk", nullable = false)
    private Denuncia denuncia;
}
