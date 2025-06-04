package com.orktek.quebragalho.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Avaliacao;
import com.orktek.quebragalho.repository.AgendamentoRepository;
import com.orktek.quebragalho.repository.AvaliacaoRepository;

import jakarta.transaction.Transactional;

@Service
public class AvaliacaoService {

    @Autowired
    private AvaliacaoRepository avaliacaoRepository;
    
    @Autowired
    private AgendamentoRepository agendamentoRepository;

    /**
     * Cria uma nova avaliação para um agendamento
     * @param avaliacao Objeto Avaliacao com os dados
     * @param agendamentoId ID do agendamento sendo avaliado
     * @return Avaliacao criada
     * @throws ResponseStatusException se agendamento não existir, não estiver concluído ou já tiver avaliação
     */
    @Transactional
    public Avaliacao criarAvaliacao(Avaliacao avaliacao) {
        // Verifica se agendamento existe
        Agendamento agendamento = avaliacao.getAgendamento();
        
        // Verifica se agendamento foi concluído
        if (!agendamento.getStatus()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Agendamento nao foi concluido");
        }
        
        // Verifica se já existe avaliação para este agendamento
        if (avaliacaoRepository.existsByAgendamento(agendamento)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Agendamento ja foi avaliado");
        }
        
        return avaliacaoRepository.save(avaliacao);
    }

    /**
     * Lista avaliações de um serviço específico
     * @param servicoId ID do serviço
     * @return Lista de Avaliacao
     */
    public List<Avaliacao> listarPorServico(Long servicoId) {
        return avaliacaoRepository.findByAgendamentoServicoId(servicoId);
    }
    
    /**
     * Lista avaliações de todos os serviços de um prestador
     * @param prestadorId ID do prestador
     * @return Lista de Avaliacao
     */
    public List<Avaliacao> listarPorPrestador(Long prestadorId) {
        return avaliacaoRepository.findByAgendamentoServicoId(prestadorId);
    }

    /**
     * Busca avaliação pelo ID
     * @param id ID da avaliação
     * @return Optional contendo a avaliação se encontrada
     */
    public Optional<Avaliacao> buscarPorId(Long id) {
        return avaliacaoRepository.findById(id);
    }

    /**
     * Remove uma avaliação do sistema
     * @param id ID da avaliação
     */
    @Transactional
    public void deletarAvaliacao(Long id) {
        avaliacaoRepository.deleteById(id);
    }
}