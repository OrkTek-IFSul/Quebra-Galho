package com.orktek.quebragalho.model;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "usuario")
// GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Usuario implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_usuario")
    @Schema(description = "Identificador único do usuário", example = "1")
    private Long id;

    @Column(nullable = false, length = 60)
    @Schema(description = "Nome completo do usuário", example = "João Silva")
    private String nome;

    @Column(nullable = false, length = 60, unique = true)
    @Schema(description = "Email único do usuário", example = "joao.silva@email.com")
    private String email;

    @Column(nullable = false, length = 255)
    @Schema(description = "Senha do usuário", example = "senha123")
    private String senha;

    @Column(nullable = false, length = 45)
    @Schema(description = "Documento do usuário (CPF ou CNPJ)", example = "123.456.789-00")
    private String documento;

    @Column(nullable = false, length = 45)
    @Schema(description = "Telefone do usuário", example = "(11) 98765-4321")
    private String telefone;

    @Column(name = "num_strike", nullable = false)
    @Schema(description = "Número de strikes do usuário", example = "0")
    private Integer numStrike = 0;

    @Column(name = "img_perfil", length = 100)
    @Schema(description = "Path da imagem de perfil do usuário", example = "/img/usuario123.jpeg")
    private String imgPerfil;

    @Column(length = 100)
    @Schema(description = "Token de autenticação do usuário", example = "abc123token")
    private String token;

    @Column(name = "is_admin", nullable = false)
    @Schema(description = "Indica se o usuário é administrador", example = "false")
    private Boolean isAdmin;

    @Column(name = "is_moderador", nullable = false)
    @Schema(description = "Indica se o usuário é moderador", example = "false")
    private Boolean isModerador;

    @OneToOne(mappedBy = "usuario", cascade = CascadeType.ALL)
    @Schema(description = "Prestador associado ao usuário")
    private Prestador prestador;

    @OneToMany(mappedBy = "usuario")
    @Schema(description = "Lista de chats associados ao usuário")
    private List<Chat> chats;

    @OneToMany(mappedBy = "usuario")
    @Schema(description = "Lista de agendamentos associados ao usuário")
    private List<Agendamento> agendamentos;

    @OneToMany(mappedBy = "denunciante")
    @Schema(description = "Lista de denúncias feitas pelo usuário")
    private List<Denuncia> denunciasFeitas;

    @OneToMany(mappedBy = "denunciado")
    @Schema(description = "Lista de denúncias recebidas pelo usuário")
    private List<Denuncia> denunciasRecebidas;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(); // ou retorne as permissões se tiver papéis/roles
    }

    @Override
    public String getUsername() {
        return this.email;
    }

    @Override
    public String getPassword() {
        return this.senha;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}