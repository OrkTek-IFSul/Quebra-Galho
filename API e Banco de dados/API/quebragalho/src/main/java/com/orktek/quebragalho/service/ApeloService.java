package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.orktek.quebragalho.model.Apelo;
import com.orktek.quebragalho.model.Denuncia;
import com.orktek.quebragalho.repository.ApeloRepository;
import com.orktek.quebragalho.repository.DenunciaRepository;

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
     * @throws RuntimeException se denúncia não for encontrada
     */
    @Transactional
    public Apelo criarApelo(Apelo apelo, Long denunciaId) {
        Denuncia denuncia = denunciaRepository.findById(denunciaId)
                .orElseThrow(() -> new RuntimeException("Denúncia não encontrada"));
        
        // Verifica se já existe apelo para esta denúncia
        if (apeloRepository.existsByDenuncia(denuncia)) {
            throw new RuntimeException("Já existe um apelo para esta denúncia");
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
     * @throws RuntimeException se apelo não for encontrado
     */
    @Transactional
    public Apelo atualizarStatusApelo(Long id, Boolean status) {
        return apeloRepository.findById(id)
                .map(apelo -> {
                    apelo.setStatus(status);
                    return apeloRepository.save(apelo);
                })
                .orElseThrow(() -> new RuntimeException("Apelo não encontrado"));
    }

    /**
     * Remove um apelo do sistema
     * @param id ID do apelo
     */
    @Transactional
    public void deletarApelo(Long id) {
        apeloRepository.deleteById(id);
    }
}