package com.orktek.quebragalho.controller.controller_views;

import java.util.ArrayList;
import java.util.List;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.dto.AgendamentoDTO.AgendamentoRetornoDTO;
import com.orktek.quebragalho.dto.AgendamentoDTO.CriarAgendamentoDTO;
import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.service.AgendamentoService;
import com.orktek.quebragalho.service.PrestadorService;
import com.orktek.quebragalho.service.ServicoService;
import com.orktek.quebragalho.service.UsuarioService;

@RestController
@RequestMapping("/api/usuario/homepage/agendamento")
@Tag(name = "Tela de pedidos de agendamentos do usuario", description = "Operações relacionadas à Tela de pedidos de agendamentos do usuario")
public class AgendamentoServicoUsuario {

        @Autowired
        private UsuarioService usuarioService;

        @Autowired
        private ServicoService servicoService;

        @Autowired
        private PrestadorService prestadorService;

        @Autowired
        private AgendamentoService agendamentoService;

        @GetMapping("/{servicoId}")
        @Operation(summary = "Carrega Horários Indisponíveis", description = "Carrega horários indisponíveis do prestador")
        public ResponseEntity<List<String>> ListaHorariosIndisponiveis(
                        @Parameter(description = "Id do Servico") @PathVariable Long servicoId) {

                List<Agendamento> agendamentos = agendamentoService.listarPorServicoAgoraEFuturo(servicoId);
                List<String> horariosIndisponiveis = new ArrayList<>();
                for (Agendamento agendamento : agendamentos) {
                        horariosIndisponiveis.add(agendamento.getDataHora().toString());
                }
                return ResponseEntity.ok(horariosIndisponiveis);

        }

        @PostMapping
        @Operation(summary = "Cadastrar Agendamento", description = "Cadastra um novo Agendamento e retorna os dados do agendamento")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "201", description = "Agendamento cadastrado com sucesso"),
                        @ApiResponse(responseCode = "409", description = "Falha ao cadastrar o agendamento")
        })
        public ResponseEntity<AgendamentoRetornoDTO> CadastrarAgendamento(
                        @Parameter(description = "Informações do agendamento", required = true) @RequestBody CriarAgendamentoDTO criarAgendamentoDTO) {

                // CriarAgendamentoDTO agendamentoDTO = new CriarAgendamentoDTO();
                // agendamentoDTO.setId_usuario(id_usuario);
                // agendamentoDTO.setId_servico(id_servico);

                // DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                // LocalDateTime horarioCorreto = LocalDateTime.parse(horario, formatter);
                // agendamentoDTO.setHorario(horarioCorreto);

                agendamentoService.criarAgendamento(criarAgendamentoDTO);

                Usuario usuario = usuarioService.buscarPorId(criarAgendamentoDTO.getId_usuario())
                                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
                Servico servico = servicoService.buscarPorId(criarAgendamentoDTO.getId_servico())
                                .orElseThrow(() -> new RuntimeException("Serviço não encontrado"));
                Agendamento agendamento = agendamentoService.buscarPorId(criarAgendamentoDTO.getId_usuario())
                                .orElseThrow(() -> new RuntimeException("Agendamento não encontrado"));
                Prestador prestador = prestadorService.buscarPorId(servico.getPrestador().getId())
                                .orElseThrow(() -> new RuntimeException("Prestador não encontrado"));

                AgendamentoRetornoDTO agendamentoRetornoDTO = new AgendamentoRetornoDTO();
                agendamentoRetornoDTO.setUsuario(usuario.getNome());
                agendamentoRetornoDTO.setPrestador(prestador.getUsuario().getNome());
                agendamentoRetornoDTO.setServico(servico.getNome());
                agendamentoRetornoDTO.setDescricao_servico(servico.getDescricao());
                agendamentoRetornoDTO.setPreco_servico(servico.getPreco());
                agendamentoRetornoDTO.setHorario(agendamento.getDataHora());

                System.out.println("TESTE TESTE" + agendamentoRetornoDTO.toString());
                return ResponseEntity.status(HttpStatus.CREATED).body(agendamentoRetornoDTO);
        }
}
