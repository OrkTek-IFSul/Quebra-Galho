package com.orktek.quebragalho.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.dto.AgendamentoDTO.CriarAgendamentoDTO;
import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.repository.AgendamentoRepository;

import jakarta.transaction.Transactional;

@Service
public class AgendamentoService {

    @Autowired
    private AgendamentoRepository agendamentoRepository;

    @Autowired
    private UsuarioService usuarioService;

    @Autowired
    private ServicoService servicoService;

    // /**
    //  * Cria um novo agendamento de serviço
    //  * 
    //  * @param agendamento Objeto Agendamento com os dados
    //  * @param servicoId   ID do serviço a ser agendado
    //  * @param usuarioId   ID do usuário que está agendando
    //  * @return Agendamento criado
    //  * @throws ResponseStatusException se serviço, usuário não existirem ou houver
    //  *                                 conflito de horário
    //  */
    // @Transactional
    // public Agendamento criarAgendamento(Agendamento agendamento, Long servicoId, Long usuarioId) {
    //     // Verifica se serviço existe
    //     Servico servico = servicoRepository.findById(servicoId)
    //             .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Servico nao encontrado"));

    //     // Verifica se usuário existe
    //     Usuario usuario = usuarioRepository.findById(usuarioId)
    //             .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario nao encontrado"));

    //     // Verifica conflitos de horário para o mesmo serviço
    //     if (agendamentoRepository.existsByDataHoraAndServico(agendamento.getDataHora(), servico)) {
    //         throw new ResponseStatusException(HttpStatus.CONFLICT, "Ja existe um servico agendado para este horario");
    //     }

    //     // Configura os relacionamentos
    //     agendamento.setServico(servico);
    //     agendamento.setUsuario(usuario);
    //     agendamento.setStatus(false); // Status inicial como não concluído

    //     return agendamentoRepository.save(agendamento);
    // }

    /**
     * Lista todos os agendamentos
     * 
     * @return Lista de Agendamento
     */
    public List<Agendamento> listarTodos() {
        return agendamentoRepository.findAll();
    }

    public List<Agendamento> listarPorServicoAgoraEFuturo(Long servicoId) {
        return agendamentoRepository.findByServico_IdAndDataHoraBetween(servicoId, LocalDateTime.now(), LocalDateTime.now().plusDays(30));
    }

    public List<Agendamento> listarAgendamentosPendentesDoPrestador(Long prestadorId) {
        List<Agendamento> getLista = agendamentoRepository.findByStatusAceitoIsNull();
        List<Agendamento> retorno = new ArrayList<>();
        for (Agendamento agendamento : getLista) {
            if (agendamento.getServico().getPrestador().getId().equals(prestadorId)) {
                retorno.add(agendamento);
            }
        }
        return retorno;
    }
    /**
     * Lista agendamentos de um usuário específico
     * 
     * @param usuarioId ID do usuário
     * @return Lista de Agendamento
     */
    public List<Agendamento> listarPorUsuario(Long usuarioId) {
        return agendamentoRepository.findByUsuarioId(usuarioId);
    }

    /**
     * Lista agendamentos de um prestador específico
     * 
     * @param prestadorId ID do prestador
     * @return Lista de Agendamento
     */
    public List<Agendamento> listarPorPrestador(Long prestadorId) {
        return agendamentoRepository.findByServicoPrestadorId(prestadorId);
    }

    // TODO UTILIZAR NA CONTROLLER DE CRIAR AGENDAMENTO
    /**
     * Cria um novo agendamento a partir de um DTO
     * 
     * @param agendamentoDTO Objeto CriarAgendamentoDTO com os dados
     * @return O mesmo CriarAgendamentoDTO recebido, caso o agendamento seja criado
     *         com sucesso
     * @throws ResponseStatusException com NOT_FOUND se usuário/serviço não
     *                                 existirem
     *                                 ou BAD_REQUEST se houver problemas na
     *                                 requisição
     */
    @Transactional
    public CriarAgendamentoDTO criarAgendamento(CriarAgendamentoDTO agendamentoDTO) {
        try {
            // Validações básicas do DTO
            if (agendamentoDTO.getHorario() == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Data e hora são obrigatórias");
            }

            // Busca usuário e serviço
            Usuario usuario = usuarioService.buscarPorId(agendamentoDTO.getId_usuario())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuário não encontrado"));

            Servico servico = servicoService.buscarPorId(agendamentoDTO.getId_servico())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Serviço não encontrado"));

            // Validação adicional da data (exemplo)
            if (agendamentoDTO.getHorario().isBefore(LocalDateTime.now())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Data não pode ser no passado");
            }

            // Cria e salva o agendamento
            Agendamento agendamento = new Agendamento();
            agendamento.setDataHora(agendamentoDTO.getHorario());
            agendamento.setStatus(false);
            agendamento.setUsuario(usuario);
            agendamento.setServico(servico);

            agendamentoRepository.save(agendamento);

            return agendamentoDTO;

        } catch (DataIntegrityViolationException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Erro ao salvar agendamento: " + e.getRootCause().getMessage());
        }
    }
    // TODO UTILIZAR NA CONTROLLER DE ALTERAR AGENDAMENTO
    /**
     * Atualiza o horário de um agendamento existente
     * 
     * @param idAgendamento ID do agendamento a ser alterado
     * @param novaDataHora  Nova data e hora para o agendamento
     * @return DTO com os dados atualizados
     * @throws ResponseStatusException se agendamento não for encontrado ou data for
     *                                 inválida
     */
    @Transactional
    public CriarAgendamentoDTO alterarHorarioAgendamento(Long idAgendamento, LocalDateTime novaDataHora) {
        // Validação básica da data
        if (novaDataHora == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nova data/hora deve ser informada");
        }

        if (novaDataHora.isBefore(LocalDateTime.now())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Não é possível agendar para datas passadas");
        }

        // Busca o agendamento existente
        Agendamento agendamento = agendamentoRepository.findById(idAgendamento)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Agendamento não encontrado"));

        // Verifica se o agendamento já foi concluído
        if (agendamento.getStatus()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Não é possível alterar agendamentos já concluídos");
        }

        // Atualiza a data/hora
        agendamento.setDataHora(novaDataHora);
        agendamentoRepository.save(agendamento);

        // Retorna um DTO com os dados atualizados
        CriarAgendamentoDTO retornoCriarAgendamentoDTO = new CriarAgendamentoDTO();
        retornoCriarAgendamentoDTO.setId_usuario(agendamento.getUsuario().getId());
        retornoCriarAgendamentoDTO.setId_servico(agendamento.getServico().getId());
        retornoCriarAgendamentoDTO.setHorario(agendamento.getDataHora());
        return retornoCriarAgendamentoDTO;
    }

    /**
     * Busca agendamento pelo ID
     * 
     * @param id ID do agendamento
     * @return Optional contendo o agendamento se encontrado
     */
    public Optional<Agendamento> buscarPorId(Long id) {
        return agendamentoRepository.findById(id);
    }

    /**
     * Atualiza o status de um agendamento (concluído/não concluído)
     * 
     * @param id     ID do agendamento
     * @param status Novo status (true = concluído)
     * @return Agendamento atualizado
     * @throws RuntimeException se agendamento não for encontrado
     */
    @Transactional
    public Agendamento atualizarStatusAgendamento(Long id, Boolean status) {
        return agendamentoRepository.findById(id)
                .map(agendamento -> {
                    agendamento.setStatus(status);
                    return agendamentoRepository.save(agendamento);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Agendamento nao encontrado"));
    }

    
    /**
     * Atualiza o status de um agendamento (aceito/não aceito)
     * 
     * @param id     ID do agendamento
     * @param status Novo status (true = concluído)
     * @return Agendamento atualizado
     * @throws RuntimeException se agendamento não for encontrado
     */
    @Transactional
    public Agendamento atualizarStatusAceitoAgendamento(Long id, Boolean status) {
        return agendamentoRepository.findById(id)
                .map(agendamento -> {
                    agendamento.setStatusAceito(status);
                    return agendamentoRepository.save(agendamento);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Agendamento nao encontrado"));
    }

    /**
     * Atualiza o status de um agendamento (aceito/não aceito)
     * 
     * @param id     ID do agendamento
     * @param status Novo status (true = concluído)
     * @return Agendamento atualizado
     * @throws RuntimeException se agendamento não for encontrado
     */
    @Transactional
    public Agendamento atualizarStatusFinalizadoAgendamento(Long id, Boolean status) {
        return agendamentoRepository.findById(id)
                .map(agendamento -> {
                    agendamento.setStatus(status);
                    return agendamentoRepository.save(agendamento);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Agendamento nao encontrado"));
    }

    /**
     * Remove um agendamento do sistema
     * 
     * @param id ID do agendamento
     */
    @Transactional
    public void deletarAgendamento(Long id) {
        agendamentoRepository.deleteById(id);
    }
}