package com.orktek.quebragalho.dto.UsuarioDTO;

import com.orktek.quebragalho.model.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para alterar e criar usuário")
public class AtualizarUsuarioDTO {

    @Schema(description = "identificador único do usuário", example = "1")
    private Long id;

    @Schema(description = "Nome completo do usuário", example = "João Silva")
    private String nome;

    @Schema(description = "Email único do usuário", example = "joao.silva@email.com")
    private String email;

    @Schema(description = "Telefone do usuário", example = "(11) 98765-4321")
    private String telefone;

    public static AtualizarUsuarioDTO fromEntity(Usuario usuario) {
        AtualizarUsuarioDTO dto = new AtualizarUsuarioDTO();
        dto.setId(usuario.getId());
        dto.setNome(usuario.getNome());
        dto.setEmail(usuario.getEmail());
        dto.setTelefone(usuario.getTelefone());
        return dto;
    }
}