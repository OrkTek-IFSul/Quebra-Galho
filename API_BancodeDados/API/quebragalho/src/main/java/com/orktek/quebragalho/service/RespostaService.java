package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Resposta;
import com.orktek.quebragalho.repository.RespostaRepository;

import java.util.Optional;

@Service
public class RespostaService {

    @Autowired
    private RespostaRepository respostaRepository;

    /**
     * Cria uma resposta para uma avaliação
     * 
     * @param resposta    Objeto Resposta com os dados
     * @param avaliacaoId ID da avaliação sendo respondida
     * @return Resposta salva
     * @throws ResponseStatusException se avaliação não for encontrada
     */
    @Transactional
    public Resposta criarResposta(Resposta resposta) {
        // Verifica se já existe resposta para esta avaliação
        if (respostaRepository.existsByAvaliacao(resposta.getAvaliacao())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Já existe uma resposta para esta avaliacao");
        }

        return respostaRepository.save(resposta);
    }

    /**
     * Busca uma resposta pelo ID
     * 
     * @param id ID da resposta
     * @return Optional contendo a resposta se encontrada
     */
    public Optional<Resposta> buscarPorId(Long id) {
        return respostaRepository.findById(id);
    }

    /**
     * Atualiza o texto de uma resposta
     * 
     * @param id             ID da resposta
     * @param novoComentario Novo texto da resposta
     * @return Resposta atualizada
     * @throws ResponseStatusException se resposta não for encontrada
     */
    @Transactional
    public Resposta atualizarResposta(Long id, String novoComentario) {
        return respostaRepository.findById(id)
                .map(resposta -> {
                    resposta.setResposta(novoComentario);
                    return respostaRepository.save(resposta);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Resposta nao encontrada"));
    }

    /**
     * Remove uma resposta do sistema
     * 
     * @param id ID da resposta
     */
    @Transactional
    public void deletarResposta(Long id) {
        respostaRepository.deleteById(id);
    }

    public Optional<Resposta> buscarPorAvaliacao(Long avaliacaoId) {
        return Optional.ofNullable(respostaRepository.findByAvaliacaoId(avaliacaoId));
    }
}