package com.orktek.quebragalho.controller.controller_views;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.orktek.quebragalho.dto.PrestadorDTO.DetalhesPrestadorUsuarioDTO;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.service.PrestadorService;

/**
 * Controlador para a página do prestador para o usuário
 */
@RestController
@RequestMapping("/api/usuario/homepage/prestador")
@Tag(name = "Detalhes do Prestador pelo lado do usuario", description = "Detalhes do Prestador pelo lado do usuario")
public class DetalhesPrestadorUsuarioController {


    @Autowired
    private PrestadorService prestadorService;


    @GetMapping("/{prestadorId}")
    @Operation(summary = "Retorna dados e serviços do prestador", description = "Retorna dados e serviços do prestador para a página do usuário")
    public ResponseEntity<DetalhesPrestadorUsuarioDTO> Prestador(
            @Parameter(description = "Id do Prestador") @PathVariable Long prestadorId) {

        Prestador prestador = prestadorService.buscarPorId(prestadorId)
                .orElseThrow(() -> new RuntimeException("Prestador não encontrado com id: " + prestadorId));

        DetalhesPrestadorUsuarioDTO prestadorDTO = DetalhesPrestadorUsuarioDTO.fromEntity(prestador, prestadorService);

        System.out.println("TESTE TESTE" + prestadorDTO.toString());

        return ResponseEntity.ok(prestadorDTO);

    }
}
