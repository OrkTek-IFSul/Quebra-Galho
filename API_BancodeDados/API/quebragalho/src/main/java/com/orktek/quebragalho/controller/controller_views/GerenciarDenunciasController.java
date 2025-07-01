package com.orktek.quebragalho.controller.controller_views;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.dto.DenunciaDTO.CarregarDenunciaDTO;
import com.orktek.quebragalho.dto.DenunciaDTO.CriarDenunciaDTO;
import com.orktek.quebragalho.service.DenunciaService;

@RestController
@RequestMapping("/api/denuncia")
@Tag(name = "Operações relacionadas a denúncias", description = "Operações relacionadas a denúncias")
public class GerenciarDenunciasController {

        @Autowired
        private DenunciaService denunciaService;

        @PostMapping
        @Operation(summary = "Criar denuncia", description = "Cria uma nova denúncia")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "201", description = "Denuncia feita com sucesso"),
                        @ApiResponse(responseCode = "409", description = "Falha ao criar a denuncia")
        })
        public ResponseEntity<CarregarDenunciaDTO> CriarDenuncia(
                        @Parameter(description = "Informações do agendamento", required = true) @RequestBody CriarDenunciaDTO CriarDenunciaDTO) {

                CarregarDenunciaDTO denunciaRetorno = denunciaService.criarDenuncia(CriarDenunciaDTO);
                return ResponseEntity.status(HttpStatus.CREATED).body(denunciaRetorno);
        }

        @GetMapping("/{idUsuario}")
        @Operation(summary = "Listar Denuncias", description = "Lista todas as denúncias aceitas que foram feitas contra o usuário informado")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Denuncias encontradas"),
                        @ApiResponse(responseCode = "404", description = "Nenhuma denuncia encontrada")
        })
        public ResponseEntity<List<CarregarDenunciaDTO>> ListarDenuncias(
                        @Parameter(description = "ID do usuário cujas denúncias serão listadas", required = true) @PathVariable Long idUsuario) {
                List<CarregarDenunciaDTO> denuncias = denunciaService.listarDenunciasAceitasPorDenunciado(idUsuario)
                                .stream()
                                .map(CarregarDenunciaDTO::fromEntity)
                                .toList();
                return ResponseEntity.ok(denuncias);
        }
}
