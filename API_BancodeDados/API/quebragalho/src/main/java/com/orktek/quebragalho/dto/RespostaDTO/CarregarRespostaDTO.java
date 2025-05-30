package com.orktek.quebragalho.dto.RespostaDTO;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.orktek.quebragalho.model.Resposta;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class CarregarRespostaDTO {

    @Schema(description = "Identificador único da Resposta", example = "1")
    private Long idResposta;

    @Schema(description = "Comentário da resposta", example = "Muito Obrigado pelo feedback!")
    private String comentario;

    @Schema(description = "Data da resposta", example = "2023-10-01")
    private String data;

    @Schema(description = "Nome do prestador", example = "João da Silva")
    private String nomePrestador;
    
    public static CarregarRespostaDTO fromEntity(Resposta resposta) {
        CarregarRespostaDTO dto = new CarregarRespostaDTO();
        dto.setIdResposta(resposta.getId());
        dto.setComentario(resposta.getResposta());
        dto.setData(resposta.getData());
        dto.setNomePrestador(resposta.getAvaliacao().getAgendamento().getServico().getPrestador().getUsuario().getNome());
        return dto;
    }

    public LocalDate getData() {
        if (this.data == null || this.data.isEmpty()) {
            return null;
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        return LocalDate.parse(this.data, formatter);
    }

    public void setData(LocalDate data) {
        if (data == null) {
            this.data = "";
        } else {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
            this.data = data.format(formatter);
        }
    }
}
