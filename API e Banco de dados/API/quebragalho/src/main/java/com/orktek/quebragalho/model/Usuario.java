
package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Table(name = "usuario")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_usuario")
    private Long id;
    
    @Column(nullable = false, length = 60)
    private String nome;
    
    @Column(nullable = false, length = 60, unique = true)
    private String email;
    
    @Column(nullable = false, length = 45)
    private String senha;
    
    @Column(nullable = false, length = 45)
    private String documento;
    
    @Column(nullable = false, length = 45)
    private String telefone;
    
    @Column(name = "num_strike", nullable = false)
    private Integer numStrike;
    
    @Column(name = "img_perfil", length = 100)
    private String imgPerfil;
    
    @Column(length = 100)
    private String token;
    
    @Column(name = "is_admin", nullable = false)
    private Boolean isAdmin;
    
    @Column(name = "is_moderador", nullable = false)
    private Boolean isModerador;
    
    @OneToOne(mappedBy = "usuario", cascade = CascadeType.ALL)
    private Prestador prestador;
    
    @OneToMany(mappedBy = "usuario")
    private List<Chat> chats;
    
    @OneToMany(mappedBy = "usuario")
    private List<Agendamento> agendamentos;
    
    @OneToMany(mappedBy = "denunciante")
    private List<Denuncia> denunciasFeitas;
    
    @OneToMany(mappedBy = "denunciado")
    private List<Denuncia> denunciasRecebidas;
}