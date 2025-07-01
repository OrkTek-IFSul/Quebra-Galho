package com.orktek.quebragalho.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Avaliacao;
import com.orktek.quebragalho.repository.AvaliacaoRepository;

import jakarta.transaction.Transactional;

@Service
public class AvaliacaoService {

    @Autowired
    private AvaliacaoRepository avaliacaoRepository;
    
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
        return avaliacaoRepository.findByAgendamentoServicoPrestadorId(prestadorId);
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

    /**
     * Atualiza o comentário de uma avaliação
     * @param id ID da avaliação
     * @param novoComentario Novo comentário a ser salvo
     * @return Avaliacao atualizada
     * @throws ResponseStatusException se avaliação não existir
     */
    @Transactional
    public Avaliacao atualizarAvaliacao(Long id, String novoComentario) {
        return avaliacaoRepository.findById(id)
                .map(avaliacao -> {
                    avaliacao.setComentario(novoComentario);
                    return avaliacaoRepository.save(avaliacao);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Avaliacao nao encontrada"));
    }
}