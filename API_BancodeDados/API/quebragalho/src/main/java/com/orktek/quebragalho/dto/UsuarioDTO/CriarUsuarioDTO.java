package com.orktek.quebragalho.dto.UsuarioDTO;

import com.orktek.quebragalho.model.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para alterar e criar usuário")
public class CriarUsuarioDTO {

    @Schema(description = "Nome completo do usuário", example = "João Silva")
    private String nome;

    @Schema(description = "Email único do usuário", example = "joao.silva@email.com")
    private String email;

    @Schema(description = "Senha do usuário", example = "senha123")
    private String senha;

    @Schema(description = "Telefone do usuário", example = "(11) 98765-4321")
    private String telefone;

    @Schema(description = "Documento do usuário (CPF ou CNPJ)", example = "123.456.789-00")
    private String documento;

    public static CriarUsuarioDTO fromEntity(Usuario usuario) {
        CriarUsuarioDTO dto = new CriarUsuarioDTO();
        dto.setNome(usuario.getNome());
        dto.setEmail(usuario.getEmail());
        dto.setSenha(usuario.getSenha()); // ⚠️ Cuidado com a exposição da senha!
        dto.setTelefone(usuario.getTelefone());
        dto.setDocumento(usuario.getDocumento());
        return dto;
    }
}