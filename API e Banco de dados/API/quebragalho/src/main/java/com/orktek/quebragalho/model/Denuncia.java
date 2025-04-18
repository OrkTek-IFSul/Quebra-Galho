package com.orktek.quebragalho.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "denuncia")
//GETTERS, SETTERS, TOSTRING E CONSTRUTORES VÃO SER CRIADOS PELO @Data
@Data
public class Denuncia {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_denuncia")
    private Long id;
    
    @Column(nullable = false, length = 45)
    private String tipo;
    
    @Column(nullable = false, length = 100)
    private String motivo;
    
    @Column(nullable = false)
    private Boolean status;
    
    @Column(name = "id_comentario")
    private Long idComentario;
    
    @ManyToOne
    @JoinColumn(name = "id_denunciante", nullable = false)
    private Usuario denunciante;
    
    @ManyToOne
    @JoinColumn(name = "id_denunciado", nullable = false)
    private Usuario denunciado;
    
    @OneToOne(mappedBy = "denuncia", cascade = CascadeType.ALL)
    private Apelo apelo;
}