package com.orktek.quebragalho.dto;

import com.orktek.quebragalho.model.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para resposta pública de usuário")
public class UsuarioDTO {
    @Schema(description = "Identificador único do usuário", example = "1")
    private Long id;

    @Schema(description = "Nome completo do usuário", example = "João Silva")
    private String nome;

    @Schema(description = "Email único do usuário", example = "joao.silva@email.com")
    private String email;

    @Schema(description = "Telefone do usuário", example = "(11) 98765-4321")
    private String telefone;

    @Schema(description = "Path da imagem de perfil do usuário", example = "/img/usuario123.jpeg")
    private String imgPerfil;

    @Schema(description = "Indica se o usuário é administrador", example = "false")
    private Boolean isAdmin;

    @Schema(description = "Indica se o usuário é moderador", example = "false")
    private Boolean isModerador;

    @Schema(description = "Documento do usuário (CPF ou CNPJ)", example = "123.456.789-00")
    private String documento;
    
    @Schema(description = "Número de strikes do usuário", example = "0")
    private Integer numStrike;

    // Construtor que recebe a entidade Usuario
    public UsuarioDTO(Usuario usuario) {
        this.id = usuario.getId();
        this.nome = usuario.getNome();
        this.email = usuario.getEmail();
        this.telefone = usuario.getTelefone();
        this.imgPerfil = usuario.getImgPerfil();
        this.isAdmin = usuario.getIsAdmin();
        this.isModerador = usuario.getIsModerador();
        this.documento = usuario.getDocumento();
        this.numStrike = usuario.getNumStrike();
    }
}