package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;
import io.swagger.v3.oas.annotations.media.Schema;

@Entity
@Table(name = "portfolio")
@Data
public class Portfolio {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_portfolio")
    @Schema(description = "ID único do portfólio", example = "1")
    private Long id;
    
    @Column(name = "img_porfolio_path", nullable = false, length = 100)
    @Schema(description = "Caminho da imagem do portfólio", example = "/images/portfolio1.jpg")
    private String imgPortfolioPath;
    
    @ManyToOne
    @JoinColumn(name = "id_prestador_fk", nullable = false)
    @Schema(description = "Prestador associado ao portfólio")
    private Prestador prestador;
}
