package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "portfolio")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Portfolio {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_portfolio")
    private Long id;
    
    @Column(name = "img_porfolio_path", nullable = false, length = 100)
    private String imgPortfolioPath;
    
    @ManyToOne
    @JoinColumn(name = "id_prestador_fk", nullable = false)
    private Prestador prestador;
}
