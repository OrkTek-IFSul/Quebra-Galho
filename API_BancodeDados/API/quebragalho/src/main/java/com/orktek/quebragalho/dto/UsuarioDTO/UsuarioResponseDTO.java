package com.orktek.quebragalho.dto.UsuarioDTO; // Adapte o pacote para o seu projeto

import com.orktek.quebragalho.model.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para garantir e remover a moderação de um usuário")
public class UsuarioResponseDTO {

    @Schema(description = "Identificador único do usuário", example = "1")
    private Long id;
    @Schema(description = "Nome completo do usuário", example = "João Silva")
    private String nome;
    @Schema(description = "Email único do usuário", example = "email@email.com")
    private String email;
    @Schema(description = " Telefone do usuário", example = "(11) 98765-4321")
    private String telefone;
    @Schema(description = "URL da imagem de perfil", example = "api/usuarios/1/imagem")
    private String imgPerfil;
    @Schema(description = "usuario é admin ou não", example = "false")
    private boolean isAdmin;
    @Schema(description = "usuario é moderador ou não", example = "false")
    private boolean isModerador;
    @Schema(description = "Indica se o usuário está ativo", example = "true")
    private boolean isAtivo;

    public static UsuarioResponseDTO fromEntity(Usuario usuario) {
        UsuarioResponseDTO dto = new UsuarioResponseDTO();
        dto.setId(usuario.getId());
        dto.setNome(usuario.getNome());
        dto.setEmail(usuario.getEmail());
        dto.setTelefone(usuario.getTelefone());
        dto.setAdmin(usuario.getIsAdmin());
        dto.setModerador(usuario.getIsModerador());
        dto.setImgPerfil("api/usuarios/" + usuario.getId() + "/imagem");
        return dto;
    }
}