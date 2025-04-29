package com.orktek.quebragalho.service;

import java.util.List;
import java.util.Optional;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.repository.AgendamentoRepository;
import com.orktek.quebragalho.repository.ServicoRepository;
import com.orktek.quebragalho.repository.UsuarioRepository;

import jakarta.transaction.Transactional;

@Service
public class AgendamentoService {

    @Autowired
    private AgendamentoRepository agendamentoRepository;
    
    @Autowired
    private ServicoRepository servicoRepository;
    
    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Cria um novo agendamento de serviço
     * @param agendamento Objeto Agendamento com os dados
     * @param servicoId ID do serviço a ser agendado
     * @param usuarioId ID do usuário que está agendando
     * @return Agendamento criado
     * @throws ResponseStatusException se serviço, usuário não existirem ou houver conflito de horário
     */
    @Transactional
    public Agendamento criarAgendamento(Agendamento agendamento, Long servicoId, Long usuarioId) {
        // Verifica se serviço existe
        Servico servico = servicoRepository.findById(servicoId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Servico nao encontrado"));
        
        // Verifica se usuário existe
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario nao encontrado"));
        
        // Verifica conflitos de horário para o mesmo serviço
        if (agendamentoRepository.existsByDataHoraAndServico(agendamento.getDataHora(), servico)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ja existe um servico agendado para este horario");
        }
        
        // Configura os relacionamentos
        agendamento.setServico(servico);
        agendamento.setUsuario(usuario);
        agendamento.setStatus(false); // Status inicial como não concluído
        
        return agendamentoRepository.save(agendamento);
    }

    /**
     * Lista todos os agendamentos
     * @return Lista de Agendamento
     */
    public List<Agendamento> listarTodos() {
        return agendamentoRepository.findAll();
    }
    
    /**
     * Lista agendamentos de um usuário específico
     * @param usuarioId ID do usuário
     * @return Lista de Agendamento
     */
    public List<Agendamento> listarPorUsuario(Long usuarioId) {
        return agendamentoRepository.findByUsuarioId(usuarioId);
    }
    
    /**
     * Lista agendamentos de um prestador específico
     * @param prestadorId ID do prestador
     * @return Lista de Agendamento
     */
    public List<Agendamento> listarPorPrestador(Long prestadorId) {
        return agendamentoRepository.findByServicoPrestadorId(prestadorId);
    }

    /**
     * Busca agendamento pelo ID
     * @param id ID do agendamento
     * @return Optional contendo o agendamento se encontrado
     */
    public Optional<Agendamento> buscarPorId(Long id) {
        return agendamentoRepository.findById(id);
    }

    /**
     * Atualiza o status de um agendamento (concluído/não concluído)
     * @param id ID do agendamento
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
     * Remove um agendamento do sistema
     * @param id ID do agendamento
     */
    @Transactional
    public void deletarAgendamento(Long id) {
        agendamentoRepository.deleteById(id);
    }
}