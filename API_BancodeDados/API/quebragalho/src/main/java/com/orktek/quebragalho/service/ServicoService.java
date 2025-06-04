package com.orktek.quebragalho.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.model.Tags;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.repository.ServicoRepository;
import com.orktek.quebragalho.repository.TagRepository;

import jakarta.transaction.Transactional;

@Service
public class ServicoService {

    @Autowired
    private ServicoRepository servicoRepository;

    @Autowired
    private PrestadorRepository prestadorRepository;

    @Autowired
    private TagRepository tagRepository;
    /**
     * Cria um novo serviço associado a um prestador e adiciona suas tags ao
     * prestador
     * 
     * @param servico     Objeto Servico com os dados
     * @param prestadorId ID do prestador que oferece o serviço
     * @return Servico criado
     * @throws ResponseStatusException se prestador não existir
     */
    @Transactional
    public Servico criarServico(Servico servico, Long prestadorId) {
        // Verifica se prestador existe
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador nao encontrado"));

        // Associa o prestador ao serviço
        servico.setPrestador(prestador);

        // Adiciona as tags do serviço ao prestador (se houver tags)
        if (servico.getTags() != null && !servico.getTags().isEmpty()) {
            adicionarTagsAoPrestador(prestador, servico.getTags());
        }

        return servicoRepository.save(servico);
    }

    /**
     * Adiciona tags ao prestador, evitando duplicatas
     * 
     * @param prestador Prestador que receberá as tags
     * @param novasTags Lista de tags para adicionar
     */
    private void adicionarTagsAoPrestador(Prestador prestador, List<Tags> novasTags) {
        // Inicializa a lista de tags do prestador se for null
        if (prestador.getTags() == null) {
            prestador.setTags(new ArrayList<>());
        }

        // Cria um Set com os nomes das tags existentes para busca eficiente
        Set<String> tagsExistentes = prestador.getTags().stream()
                .map(tag -> tag.getNome().toLowerCase())
                .collect(Collectors.toSet());

        // Processa cada nova tag
        for (Tags novaTag : novasTags) {
            if (novaTag != null && novaTag.getNome() != null &&
                    !tagsExistentes.contains(novaTag.getNome().toLowerCase())) {

                // Busca a tag no banco ou cria uma nova se não existir
                Tags tagGerenciada = buscarOuCriarTag(novaTag.getNome());

                prestador.getTags().add(tagGerenciada);
                tagsExistentes.add(tagGerenciada.getNome().toLowerCase());
            }
        }

        // Salva o prestador com as novas tags
        prestadorRepository.save(prestador);
    }

    /**
     * Busca uma tag existente no banco ou cria uma nova
     * 
     * @param nomeTag Nome da tag
     * @return Tag gerenciada pelo Hibernate
     */
    private Tags buscarOuCriarTag(String nomeTag) {
        // Assumindo que você tenha um TagRepository
        return tagRepository.findByNomeIgnoreCase(nomeTag)
                .orElseGet(() -> {
                    Tags novaTag = new Tags();
                    novaTag.setNome(nomeTag.toLowerCase().trim());
                    return tagRepository.save(novaTag);
                });
    }

    /**
     * Lista todos os serviços cadastrados
     * 
     * @return Lista de Servico
     */
    public List<Servico> listarTodos() {
        return servicoRepository.findAll();
    }

    public Optional<Servico> buscarPorIdEPrestador(Long idServico, Long idPrestador) {
        return Optional.ofNullable(servicoRepository.findByIdAndPrestadorId(idServico, idPrestador))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Servico nao encontrado"));
    }

    /**
     * Lista serviços de um prestador específico
     * 
     * @param prestadorId ID do prestador
     * @return Lista de Servico
     */
    public List<Servico> listarPorPrestador(Long prestadorId) {
        return servicoRepository.findByPrestadorId(prestadorId);
    }

    /**
     * Busca serviço pelo ID
     * 
     * @param id ID do serviço
     * @return Optional contendo o serviço se encontrado
     */
    public Optional<Servico> buscarPorId(Long id) {
        return servicoRepository.findById(id);
    }

    /**
     * Atualiza os dados de um serviço
     * 
     * @param id                ID do serviço
     * @param servicoAtualizado Objeto com os novos dados
     * @return Servico atualizado
     * @throws ResponseStatusException se serviço não for encontrado
     */
    @Transactional
    public Servico atualizarServico(Long id, Servico servicoAtualizado) {
        return servicoRepository.findById(id)
                .map(servico -> {
                    // Atualiza os campos permitidos
                    servico.setNome(servicoAtualizado.getNome());
                    servico.setDescricao(servicoAtualizado.getDescricao());
                    servico.setPreco(servicoAtualizado.getPreco());
                    servico.setTags(servicoAtualizado.getTags());
                    return servicoRepository.save(servico);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Servico nao encontrado"));
    }
    /**
     * Busca serviços por id do prestador e status
     * 
     * @param prestadorId ID do prestador
     * @param ativo       Status do serviço (ativo ou inativo)
     * @return Lista de serviços
     */
    public List<Servico> buscarServicosPorPrestadorEStatus(Long prestadorId, boolean ativo) {
    return servicoRepository.findByPrestadorIdAndAtivo(prestadorId, ativo);
}
}