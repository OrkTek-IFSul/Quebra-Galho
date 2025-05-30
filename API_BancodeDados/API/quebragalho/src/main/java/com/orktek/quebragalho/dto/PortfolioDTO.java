package com.orktek.quebragalho.dto;

import com.orktek.quebragalho.model.Portfolio;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class PortfolioDTO {
    @Schema(description = "ID único do portfólio", example = "1")
    private Long id;
    
    @Schema(description = "Caminho da imagem do portfólio", example = "/images/portfolio1.jpg")
    private String imagemUrl;
    
    @Schema(description = "Prestador associado ao portfólio")
    private Long prestadorId;

    public PortfolioDTO(Portfolio portfolio) {
        this.id = portfolio.getId();
        this.prestadorId = portfolio.getPrestador().getId();
        this.imagemUrl = "/api/portfolio/" + portfolio.getId() + "/imagem";
    }
}
