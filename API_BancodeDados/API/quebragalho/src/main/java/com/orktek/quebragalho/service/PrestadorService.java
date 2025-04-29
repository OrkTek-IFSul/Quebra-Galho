package com.orktek.quebragalho.service;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.repository.UsuarioRepository;

import jakarta.transaction.Transactional;

@Service
public class PrestadorService {

    @Autowired
    private FileStorageService fileStorageService; // Para manipulação de arquivos

    @Autowired
    private PrestadorRepository prestadorRepository;
    
    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Cria um novo prestador de serviço associado a um usuário
     * @param prestador Objeto Prestador com os dados
     * @param usuarioId ID do usuário que será o prestador
     * @return Prestador criado
     * @throws ResponseStatusException se usuário não existir ou já for prestador
     */
    @Transactional
    public Prestador criarPrestador(Prestador prestador, Long usuarioId) {
        // Verifica se usuário existe
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario nao encontrado"));
        
        // Verifica se usuário já é prestador
        if (prestadorRepository.existsByUsuario(usuario)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Este usuario ja é um prestador");
        }
        
        // Associa o usuário ao prestador
        prestador.setUsuario(usuario);
        return prestadorRepository.save(prestador);
    }

    /**
     * Lista todos os prestadores cadastrados
     * @return Lista de Prestador
     */
    public List<Prestador> listarTodos() {
        return prestadorRepository.findAll();
    }

    /**
     * Busca prestador pelo ID
     * @param id ID do prestador
     * @return Optional contendo o prestador se encontrado
     */
    public Optional<Prestador> buscarPorId(Long id) {
        return prestadorRepository.findById(id);
    }
    
    /**
     * Busca prestador pelo ID do usuário associado
     * @param usuarioId ID do usuário
     * @return Optional contendo o prestador se encontrado
     */
    public Optional<Prestador> buscarPorUsuarioId(Long usuarioId) {
        return prestadorRepository.findByUsuarioId(usuarioId);
    }

    /**
     * Atualiza os dados de um prestador
     * @param id ID do prestador
     * @param prestadorAtualizado Objeto com os novos dados
     * @return Prestador atualizado
     * @throws ResponseStatusException se prestador não for encontrado
     */
    @Transactional
    public Prestador atualizarPrestador(Long id, Prestador prestadorAtualizado) {
        return prestadorRepository.findById(id)
                .map(prestador -> {
                    // Atualiza apenas os campos permitidos
                    prestador.setDescricao(prestadorAtualizado.getDescricao());
                    prestador.setDocumentoPath(prestadorAtualizado.getDocumentoPath());
                    return prestadorRepository.save(prestador);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador nao encontrado"));
    }

    /**
     * Remove um prestador do sistema
     * @param id ID do prestador
     */
    @Transactional
    public void deletarPrestador(Long id) {
        prestadorRepository.deleteById(id);
    }

        /**
     * Adiciona a imagem de documento do prestador
     * @param prestadorId ID do prestador
     * @param documento Arquivo de imagem a ser salvo
     * @return Nome do arquivo salvo
     * @throws ResponseStatusException se usuário não for encontrado ou ocorrer erro no upload
     */
    @Transactional
    public String enviarImagemDocumento(Long prestadorId, MultipartFile documento) {
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador nao encontrado"));
        
        try {
            // Remove a imagem antiga se existir
            if (prestador.getDocumentoPath() != null) {
                fileStorageService.deleteFile(prestador.getDocumentoPath());
            }
            
            // Salva a nova imagem
            String nomeArquivo = fileStorageService.storeFile(documento);
            prestador.setDocumentoPath(nomeArquivo);
            prestadorRepository.save(prestador);
            
            return nomeArquivo;
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Falha ao enviar imagem de documento", e);
        }
    }
}