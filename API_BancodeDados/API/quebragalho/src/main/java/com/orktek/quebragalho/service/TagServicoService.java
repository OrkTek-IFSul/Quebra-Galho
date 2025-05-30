package com.orktek.quebragalho.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

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
         * @throws ResponseStatusException se serviço ou tag não existirem
         */
        @Transactional
        public void adicionarTagAoServico(Long servicoId, Long tagId) {
                Servico servico = servicoRepository.findById(servicoId)
                                .orElseThrow(() ->  new ResponseStatusException(HttpStatus.NOT_FOUND, "Servico nao encontrado"));	

                Tags tag = tagRepository.findById(tagId)
                                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tag nao encontrada"));

                servico.getTags().add(tag);
                servicoRepository.save(servico);
        }

        /**
         * Remove uma tag de um serviço
         * 
         * @param servicoId ID do serviço
         * @param tagId     ID da tag
         * @throws ResponseStatusException se serviço ou tag não existirem
         */
        @Transactional
        public void removerTagDoServico(Long servicoId, Long tagId) {
                Servico servico = servicoRepository.findById(servicoId)
                                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Servico nao encontrado"));

                Tags tag = tagRepository.findById(tagId)
                                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tag nao encontrada"));

                servico.getTags().remove(tag);
                servicoRepository.save(servico);
        }

        /**
         * Lista os IDs das tags associadas a um serviço
         * 
         * @param servicoId ID do serviço
         * @return Lista de IDs das tags associadas ao serviço
         * @throws ResponseStatusException se o serviço não existir
         */
        public List<Long> listarTagsPorServico(Long servicoId) {
                Servico servico = servicoRepository.findById(servicoId)
                                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Servico nao encontrado"));

                return servico.getTags().stream()
                                .map(Tags::getId)
                                .toList();
        }
}