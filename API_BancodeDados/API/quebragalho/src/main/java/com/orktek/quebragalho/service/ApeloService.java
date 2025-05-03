package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Apelo;
import com.orktek.quebragalho.model.Denuncia;
import com.orktek.quebragalho.repository.ApeloRepository;
import com.orktek.quebragalho.repository.DenunciaRepository;

import java.util.List;
import java.util.Optional;

@Service
public class ApeloService {

    @Autowired
    private ApeloRepository apeloRepository;
    
    @Autowired
    private DenunciaRepository denunciaRepository;

    /**
     * Cria um novo apelo para uma denúncia
     * @param apelo Objeto Apelo com os dados
     * @param denunciaId ID da denúncia sendo apelada
     * @return Apelo salvo
     * @throws ResponseStatusException se denúncia não for encontrada
     */
    @Transactional
    public Apelo criarApelo(Apelo apelo, Long denunciaId) {
        Denuncia denuncia = denunciaRepository.findById(denunciaId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Denuncia nao encontrado"));
        
        // Verifica se já existe apelo para esta denúncia
        if (apeloRepository.existsByDenuncia(denuncia)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ja existe um apelo para esta denuncia");
        }
        
        apelo.setDenuncia(denuncia);
        apelo.setStatus(false); // Status inicial como não resolvido
        
        return apeloRepository.save(apelo);
    }

    /**
     * Busca um apelo pelo ID
     * @param id ID do apelo
     * @return Optional contendo o apelo se encontrado
     */
    public Optional<Apelo> buscarPorId(Long id) {
        return apeloRepository.findById(id);
    }

    /**
     * Atualiza o status de um apelo
     * @param id ID do apelo
     * @param status Novo status (true = resolvido)
     * @return Apelo atualizado
     * @throws ResponseStatusException se apelo não for encontrado
     */
    @Transactional
    public Apelo atualizarStatusApelo(Long id, Boolean status) {
        return apeloRepository.findById(id)
                .map(apelo -> {
                    apelo.setStatus(status);
                    return apeloRepository.save(apelo);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Apelo nao encontrado"));
    }

    /**
     * Remove um apelo do sistema
     * @param id ID do apelo
     */
    @Transactional
    public void deletarApelo(Long id) {
        apeloRepository.deleteById(id);
    }

    public List<Apelo> listarPendentes() {
        return apeloRepository.findByStatus(false);
    }
}