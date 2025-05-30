package com.orktek.quebragalho.controller.controller_views;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.service.UsuarioService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controller para operações da tela de cadastro
 * de usuários e prestadores
 */
@RestController
@RequestMapping("/api/tipousuario")
@Tag(name = "Controller do tipo de usuario", description = "Operações relacionadas ao tipo de usuario")
public class SelecaoTipoUsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping("/{usuarioId}")
    @Operation(summary = "Verifica se o usuario é prestador(true se for, false se for só usuario)", description = "Verifica se o usuario é prestador")
    public boolean usuarioIsPrestador(
            @Parameter(description = "Id do usuario") @PathVariable Long usuarioId) {
        Usuario usuario = usuarioService.buscarPorId(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        if (usuario.getPrestador() != null) {
            return true;
        } else {
            return false;

        }
    }

}
