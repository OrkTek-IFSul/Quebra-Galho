package com.orktek.quebragalho.controller.controller_views;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.dto.ApeloDTO.CarregarApeloDTO;
import com.orktek.quebragalho.dto.ApeloDTO.CriarApeloDTO;
import com.orktek.quebragalho.service.ApeloService;

@RestController
@RequestMapping("/api/apelo")
@Tag(name = "Operações relacionadas a fazer denúncias", description = "Operações relacionadas a fazer denúncias")
public class GerenciarApeloController {

        @Autowired
        private ApeloService apeloService;

        @PostMapping
        @Operation(summary = "Criar apelo", description = "Cria um novo apelo para uma denúncia")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "201", description = "Denuncia feita com sucesso"),
                        @ApiResponse(responseCode = "409", description = "Falha ao criar a denuncia")
        })
        public ResponseEntity<CarregarApeloDTO> CriarApelo(
                        @Parameter(description = "Informações do apelo", required = true) @RequestBody CriarApeloDTO criarApeloDTO) {

                CarregarApeloDTO denunciaRetorno = apeloService.criarApelo(criarApeloDTO);

                return ResponseEntity.status(HttpStatus.CREATED).body(denunciaRetorno);
        }
}
