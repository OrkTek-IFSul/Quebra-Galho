package com.orktek.quebragalho.controller.controller_views;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.orktek.quebragalho.service.UsuarioService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Parameter;

@RestController
@RequestMapping("/api/getToken")
@Tag(name = "Controller do token do firebase", description = "Operações relacionadas ao token do firebase")
public class TokenController {

    @Autowired
    private UsuarioService usuarioService;

    @PutMapping("/{usuarioId}")
    @Operation(summary = "Recebe o Token firebase do dispositivo do usuario", description = "Recebe o Token firebase do dispositivo do usuario")
    public boolean receberToken(
            @Parameter(description = "Id do usuario") @PathVariable Long usuarioId,
            @Parameter(description = "Token do dispositivo") @RequestParam String token) {

        usuarioService.salvarToken(usuarioId, token);
        return true;
    }

}
