package com.orktek.quebragalho.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.repository.ServicoRepository;

import jakarta.transaction.Transactional;

@Service
public class ServicoService {

    @Autowired
    private ServicoRepository servicoRepository;
    
    @Autowired
    private PrestadorRepository prestadorRepository;

    /**
     * Cria um novo serviço associado a um prestador
     * @param servico Objeto Servico com os dados
     * @param prestadorId ID do prestador que oferece o serviço
     * @return Servico criado
     * @throws RuntimeException se prestador não existir
     */
    @Transactional
    public Servico criarServico(Servico servico, Long prestadorId) {
        // Verifica se prestador existe
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new RuntimeException("Prestador não encontrado"));
        
        // Associa o prestador ao serviço
        servico.setPrestador(prestador);
        return servicoRepository.save(servico);
    }

    /**
     * Lista todos os serviços cadastrados
     * @return Lista de Servico
     */
    public List<Servico> listarTodos() {
        return servicoRepository.findAll();
    }
    
    /**
     * Lista serviços de um prestador específico
     * @param prestadorId ID do prestador
     * @return Lista de Servico
     */
    public List<Servico> listarPorPrestador(Long prestadorId) {
        return servicoRepository.findByPrestadorId(prestadorId);
    }

    /**
     * Busca serviço pelo ID
     * @param id ID do serviço
     * @return Optional contendo o serviço se encontrado
     */
    public Optional<Servico> buscarPorId(Long id) {
        return servicoRepository.findById(id);
    }

    /**
     * Atualiza os dados de um serviço
     * @param id ID do serviço
     * @param servicoAtualizado Objeto com os novos dados
     * @return Servico atualizado
     * @throws RuntimeException se serviço não for encontrado
     */
    @Transactional
    public Servico atualizarServico(Long id, Servico servicoAtualizado) {
        return servicoRepository.findById(id)
                .map(servico -> {
                    // Atualiza os campos permitidos
                    servico.setNome(servicoAtualizado.getNome());
                    servico.setDescricao(servicoAtualizado.getDescricao());
                    servico.setPreco(servicoAtualizado.getPreco());
                    return servicoRepository.save(servico);
                })
                .orElseThrow(() -> new RuntimeException("Serviço não encontrado"));
    }

    /**
     * Remove um serviço do sistema
     * @param id ID do serviço
     */
    @Transactional
    public void deletarServico(Long id) {
        servicoRepository.deleteById(id);
    }
}