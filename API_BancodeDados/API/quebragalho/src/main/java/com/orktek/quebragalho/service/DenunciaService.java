package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.dto.DenunciaDTO.CarregarDenunciaDTO;
import com.orktek.quebragalho.dto.DenunciaDTO.CriarDenunciaDTO;
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
     * Cria uma nova denúncia
     * @param denunciaDTO Dados da denúncia a ser criada
     * @return Denuncia criada
     * @throws ResponseStatusException se o denunciante ou denunciado não forem encontrados
     */
    @Transactional
    public CarregarDenunciaDTO criarDenuncia(CriarDenunciaDTO denunciaDTO) {
        Usuario denunciante = usuarioRepository.findById(denunciaDTO.getDenunciante())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Denunciante nao encontrado"));
        
        Usuario denunciado = usuarioRepository.findById(denunciaDTO.getDenunciado())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Denunciado nao encontrado"));
        
        Denuncia denuncia = new Denuncia();
        denuncia.setTipo(denunciaDTO.getTipo());
        denuncia.setMotivo(denunciaDTO.getMotivo());
        denuncia.setIdComentario(denunciaDTO.getIdConteudoDenunciado());
        denuncia.setDenunciante(denunciante);
        denuncia.setDenunciado(denunciado);
        denuncia.setStatus(null); // Status inicial como não resolvido
        // Salva a denúncia
        denunciaRepository.save(denuncia);
        // Retorna a denúncia criada como DTO
        CarregarDenunciaDTO denunciaDTOResponse = CarregarDenunciaDTO.fromEntity(denuncia);
        return (denunciaDTOResponse);
    }

    /**
     * Lista todas as denúncias
     * @return Lista de Denuncia
     */
    public List<Denuncia> listarTodas() {
        return denunciaRepository.findAll();
    }
    
    public List<Denuncia> listarDenunciasAceitasPorDenunciado(Long denunciadoId) {
        return denunciaRepository.findByDenunciadoIdAndStatusTrue(denunciadoId);
    }


    /**
     * Lista todos as denuncias nao resolvidas
     * 
     * @return Lista de Denuncia
     */
    public List<Denuncia> listarTodosNaoAceitos() {
        return denunciaRepository.findByStatusIsNull();
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
     * @throws ResponseStatusException se denúncia não for encontrada
     */
    @Transactional
    public Denuncia atualizarStatusDenuncia(Long id, Boolean status) {
        return denunciaRepository.findById(id)
                .map(denuncia -> {
                    denuncia.setStatus(status);
                    return denunciaRepository.save(denuncia);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Denuncia nao encontrado"));
    }

    /**
     * Remove uma denúncia do sistema
     * @param id ID da denúncia
     */
    @Transactional
    public void deletarDenuncia(Long id) {
        denunciaRepository.deleteById(id);
    }

    public List<Denuncia> listarPendentes() {
        return denunciaRepository.findByStatus(false);
    }
}