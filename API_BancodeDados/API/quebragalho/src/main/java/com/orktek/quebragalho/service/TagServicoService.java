package com.orktek.quebragalho.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.model.Tags;
import com.orktek.quebragalho.repository.ServicoRepository;
import com.orktek.quebragalho.repository.TagRepository;

@Service
public class TagServicoService {

        @Autowired
        private ServicoRepository servicoRepository;

        @Autowired
        private TagRepository tagRepository;

        /**
         * Adiciona uma tag a um serviço
         * 
         * @param servicoId ID do serviço
         * @param tagId     ID da tag
         * @throws RuntimeException se serviço ou tag não existirem
         */
        @Transactional
        public void adicionarTagAoServico(Long servicoId, Long tagId) {
                Servico servico = servicoRepository.findById(servicoId)
                                .orElseThrow(() -> new RuntimeException("Serviço não encontrado"));

                Tags tag = tagRepository.findById(tagId)
                                .orElseThrow(() -> new RuntimeException("Tag não encontrada"));

                servico.getTags().add(tag);
                servicoRepository.save(servico);
        }

        /**
         * Remove uma tag de um serviço
         * 
         * @param servicoId ID do serviço
         * @param tagId     ID da tag
         * @throws RuntimeException se serviço ou tag não existirem
         */
        @Transactional
        public void removerTagDoServico(Long servicoId, Long tagId) {
                Servico servico = servicoRepository.findById(servicoId)
                                .orElseThrow(() -> new RuntimeException("Serviço não encontrado"));

                Tags tag = tagRepository.findById(tagId)
                                .orElseThrow(() -> new RuntimeException("Tag não encontrada"));

                servico.getTags().remove(tag);
                servicoRepository.save(servico);
        }

        /**
         * Lista os IDs das tags associadas a um serviço
         * 
         * @param servicoId ID do serviço
         * @return Lista de IDs das tags associadas ao serviço
         * @throws RuntimeException se o serviço não existir
         */
        public List<Long> listarTagsPorServico(Long servicoId) {
                Servico servico = servicoRepository.findById(servicoId)
                                .orElseThrow(() -> new RuntimeException("Serviço não encontrado"));

                return servico.getTags().stream()
                                .map(Tags::getId)
                                .toList();
        }
}