import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfirmacaoPage extends StatelessWidget {
  final String nomePrestador;
  final String nomeServico;
  final DateTime data;
  final String hora;
  final double valor;

  const ConfirmacaoPage({super.key, 
    required this.nomePrestador,
    required this.nomeServico,
    required this.data,
    required this.hora,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Confirmação'),
        automaticallyImplyLeading: false, // remove botão de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Check animado com Lottie
            Lottie.asset(
              'assets/confetti.json', // você precisa baixar esse json e colocar na pasta assets
              width: 150,
              height: 150,
              repeat: false,
            ),

            SizedBox(height: 20),

            Text('Solicitação Confirmada!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            SizedBox(height: 24),

            infoRow('Prestador:', nomePrestador),
            infoRow('Serviço:', nomeServico),
            infoRow('Data:', '${data.day}/${data.month}/${data.year}'),
            infoRow('Hora:', hora),
            infoRow('Valor:', 'R\$ ${valor.toStringAsFixed(2)}'),

            Spacer(),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst); // volta pra home
              },
              icon: Icon(Icons.home),
              label: Text('Voltar para Home'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
