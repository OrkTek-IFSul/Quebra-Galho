package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.orktek.quebragalho.model.Denuncia;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.repository.DenunciaRepository;
import com.orktek.quebragalho.repository.UsuarioRepository;

import java.util.List;
import java.util.Optional;

@Service
public class DenunciaService {

    @Autowired
    private DenunciaRepository denunciaRepository;
    
    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Cria uma nova denúncia no sistema
     * @param denuncia Objeto Denuncia com os dados
     * @param denuncianteId ID do usuário que está denunciando
     * @param denunciadoId ID do usuário sendo denunciado
     * @return Denuncia salva
     * @throws RuntimeException se denunciante ou denunciado não existirem
     */
    @Transactional
    public Denuncia criarDenuncia(Denuncia denuncia, Long denuncianteId, Long denunciadoId) {
        Usuario denunciante = usuarioRepository.findById(denuncianteId)
                .orElseThrow(() -> new RuntimeException("Denunciante não encontrado"));
        
        Usuario denunciado = usuarioRepository.findById(denunciadoId)
                .orElseThrow(() -> new RuntimeException("Denunciado não encontrado"));
        
        denuncia.setDenunciante(denunciante);
        denuncia.setDenunciado(denunciado);
        denuncia.setStatus(false); // Status inicial como não resolvido
        
        return denunciaRepository.save(denuncia);
    }

    /**
     * Lista todas as denúncias
     * @return Lista de Denuncia
     */
    public List<Denuncia> listarTodas() {
        return denunciaRepository.findAll();
    }

    /**
     * Busca uma denúncia pelo ID
     * @param id ID da denúncia
     * @return Optional contendo a denúncia se encontrada
     */
    public Optional<Denuncia> buscarPorId(Long id) {
        return denunciaRepository.findById(id);
    }

    /**
     * Atualiza o status de uma denúncia
     * @param id ID da denúncia
     * @param status Novo status (true = resolvido)
     * @return Denuncia atualizada
     * @throws RuntimeException se denúncia não for encontrada
     */
    @Transactional
    public Denuncia atualizarStatusDenuncia(Long id, Boolean status) {
        return denunciaRepository.findById(id)
                .map(denuncia -> {
                    denuncia.setStatus(status);
                    return denunciaRepository.save(denuncia);
                })
                .orElseThrow(() -> new RuntimeException("Denúncia não encontrada"));
    }

    /**
     * Remove uma denúncia do sistema
     * @param id ID da denúncia
     */
    @Transactional
    public void deletarDenuncia(Long id) {
        denunciaRepository.deleteById(id);
    }
}