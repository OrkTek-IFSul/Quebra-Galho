package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.orktek.quebragalho.dto.AgendamentoDTO.AgendamentoInfoDTO;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.repository.AgendamentoRepository;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.repository.ServicoRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class DisponibilidadeService {

    @Autowired
    private AgendamentoRepository agendamentoRepository;
    
    @Autowired
    private ServicoRepository servicoRepository;
    
    @Autowired
    private PrestadorRepository prestadorRepository;

    public List<LocalDateTime> getHorariosDisponiveis(Long idServico, LocalDate data) {
        // 1. Obter informações essenciais
        Servico servicoParaAgendar = servicoRepository.findById(idServico)
                .orElseThrow(() -> new RuntimeException("Serviço não encontrado"));

        Prestador prestador = prestadorRepository.findById(servicoParaAgendar.getPrestador().getId())
                .orElseThrow(() -> new RuntimeException("Prestador não encontrado"));

        if (prestador.getDataHoraInicio() == null || prestador.getDataHoraFim() == null) {
            return new ArrayList<>();
        }
        // Ignora a data do banco e usa apenas a HORA, combinando com a DATA da requisição.
        LocalDateTime inicioTrabalho = data.atTime(prestador.getDataHoraInicio().toLocalTime());
        LocalDateTime fimTrabalho = data.atTime(prestador.getDataHoraFim().toLocalTime());

        int duracaoNovoServico = servicoParaAgendar.getDuracaoMinutos();

        // 2. Obter agendamentos existentes
        List<AgendamentoInfoDTO> agendamentosDoDia = agendamentoRepository
                .findAgendamentosConfirmadosDoDia(prestador.getId(), data);

        // --- INÍCIO DA LÓGICA ATUALIZADA ---

        List<LocalDateTime> horariosDisponiveis = new ArrayList<>();
        LocalDateTime ponteiroTempo = inicioTrabalho;

        // Itera sobre cada agendamento confirmado do dia
        for (AgendamentoInfoDTO agendamento : agendamentosDoDia) {
            LocalDateTime inicioOcupado = agendamento.getInicio_agendamento();

            // Gera slots na lacuna entre o ponteiro atual e o início do próximo agendamento
            gerarSlotsNoIntervalo(ponteiroTempo, inicioOcupado, duracaoNovoServico, horariosDisponiveis);

            // Move o ponteiro para o final do bloco ocupado
            ponteiroTempo = inicioOcupado.plusMinutes(agendamento.getDuracao_agendamento());
        }

        // Gera slots na última lacuna, entre o fim do último agendamento e o fim do
        // expediente
        gerarSlotsNoIntervalo(ponteiroTempo, fimTrabalho, duracaoNovoServico, horariosDisponiveis);

        // --- FIM DA LÓGICA ATUALIZADA ---

        return horariosDisponiveis;
    }

    /**
     * Método auxiliar para gerar slots de 30 em 30 minutos dentro de um intervalo
     * de tempo.
     */
    private void gerarSlotsNoIntervalo(LocalDateTime inicioIntervalo, LocalDateTime fimIntervalo, int duracaoServico,
            List<LocalDateTime> horariosDisponiveis) {
        LocalDateTime slotParaTestar = inicioIntervalo;

        // Loop que avança de 30 em 30 minutos
        while (true) {
            // Calcula o horário de término se o serviço começasse no slot atual
            LocalDateTime fimDoSlotProposto = slotParaTestar.plusMinutes(duracaoServico);

            // Verifica se o serviço proposto termina antes ou exatamente no fim do
            // intervalo livre
            if (fimDoSlotProposto.isAfter(fimIntervalo)) {
                break; // O slot ultrapassa o limite da lacuna, então paramos.
            }

            // Se couber, adicionamos como um horário disponível
            horariosDisponiveis.add(slotParaTestar);

            // Avança para o próximo possível slot (30 minutos depois)
            slotParaTestar = slotParaTestar.plusMinutes(30);
        }
    }
}