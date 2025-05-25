package com.orktek.quebragalho.dto.UsuarioDTO;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.orktek.quebragalho.model.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL) // Ignora campos nulos
@Schema(description = "DTO para resposta pública de usuário")
public class UsuarioGenericoDTO {

    @Schema(description = "Identificador único do usuário", example = "1")
    private Long id;

    @Schema(description = "Nome completo do usuário", example = "João Silva")
    private String nome;

    @Schema(description = "Email único do usuário", example = "joao.silva@email.com")
    private String email;

    @Schema(description = "Telefone do usuário", example = "(11) 98765-4321")
    private String telefone;

    @Schema(description = "Documento do usuário (CPF ou CNPJ)", example = "123.456.789-00")
    private String documento;

    @Schema(description = "URL da imagem de perfil", example = "api/usuarios/1/imagem")
    private String imagemPerfil;

    // Removido o campo senha do DTO de resposta
    // @Schema(description = "Senha do usuário", example = "senha123", accessMode = Schema.AccessMode.WRITE_ONLY)
    // private String senha;

    // Construtor vazio explícito
    public UsuarioGenericoDTO() {}

    // Método de conversão opcional (não interfere na desserialização)
    public static UsuarioGenericoDTO fromEntity(Usuario usuario) {
        UsuarioGenericoDTO dto = new UsuarioGenericoDTO();
        dto.setId(usuario.getId());
        dto.setNome(usuario.getNome());
        dto.setEmail(usuario.getEmail());
        dto.setTelefone(usuario.getTelefone());
        dto.setDocumento(usuario.getDocumento());
        dto.setImagemPerfil("api/usuarios/" + usuario.getId() + "/imagem");
        return dto;
    }
}