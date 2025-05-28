import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SolicitacaoClienteCard extends StatefulWidget {
  final String nome;
  final String fotoUrl;
  final VoidCallback onTap;
  final int idAgendamento;
  final Function() onConfirm;
  final bool isConfirmed;


  const SolicitacaoClienteCard({
    super.key,
    required this.nome,
    required this.fotoUrl,
    required this.onTap,
    required this.idAgendamento,
    required this.onConfirm,
    required this.isConfirmed,
   
  });

  @override
  State<SolicitacaoClienteCard> createState() => _SolicitacaoClienteCardState();
}

class _SolicitacaoClienteCardState extends State<SolicitacaoClienteCard> {
  bool isLoading = false;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _isConfirmed = widget.isConfirmed;
  }

  Future<void> _confirmarSolicitacao() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('http://192.168.0.155:8080/api/prestador/pedidoservico/${widget.idAgendamento}/aceitar'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isConfirmed = true;
        });
        widget.onConfirm(); // Callback to update parent
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitação de ${widget.nome} confirmada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Falha ao confirmar solicitação');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao confirmar solicitação: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Foto de perfil
              CircleAvatar(
                backgroundImage: NetworkImage(widget.fotoUrl),
                radius: 25,
              ),
              const SizedBox(width: 12),
              
              // Informações do cliente
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                  
                  ],
                ),
              ),

              // Status ou botões de ação
              _isConfirmed 
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, 
                            color: Colors.green.shade700, 
                            size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Confirmado',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.green,
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: _confirmarSolicitacao,
                          ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          // Implementar rejeição aqui
                        },
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
