package com.orktek.quebragalho.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.repository.UsuarioRepository;

import jakarta.transaction.Transactional;

@Service
public class PrestadorService {

    @Autowired
    private PrestadorRepository prestadorRepository;
    
    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Cria um novo prestador de serviço associado a um usuário
     * @param prestador Objeto Prestador com os dados
     * @param usuarioId ID do usuário que será o prestador
     * @return Prestador criado
     * @throws RuntimeException se usuário não existir ou já for prestador
     */
    @Transactional
    public Prestador criarPrestador(Prestador prestador, Long usuarioId) {
        // Verifica se usuário existe
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        
        // Verifica se usuário já é prestador
        if (prestadorRepository.existsByUsuario(usuario)) {
            throw new RuntimeException("Este usuário já é um prestador");
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
     * @throws RuntimeException se prestador não for encontrado
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
                .orElseThrow(() -> new RuntimeException("Prestador não encontrado"));
    }

    /**
     * Remove um prestador do sistema
     * @param id ID do prestador
     */
    @Transactional
    public void deletarPrestador(Long id) {
        prestadorRepository.deleteById(id);
    }
}