import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/models/prestador_model.dart';

class PrestadorPageUserVision extends StatefulWidget {
  final Prestador prestador;

  const PrestadorPageUserVision({super.key, required this.prestador});

  @override
  State<PrestadorPageUserVision> createState() => _PrestadorPageUserVisionState();
}

class _PrestadorPageUserVisionState extends State<PrestadorPageUserVision> {
  bool _showPlaceholder = false;

  @override
  void initState() {
    super.initState();
    _showPlaceholder = widget.prestador.imgPerfil == null || 
                      widget.prestador.imgPerfil!.isEmpty;
  }

  Widget _buildImageOrPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: _showPlaceholder 
            ? const Color.fromARGB(255, 120, 0, 141)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _showPlaceholder
          ? Center(
              child: Text(
                widget.prestador.nome.isNotEmpty
                    ? widget.prestador.nome[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : Image.network(
              widget.prestador.imgPerfil!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() => _showPlaceholder = true);
                  }
                });
                return Container();
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalhes',
          style: TextStyle(
            fontSize: 16,
            color: Colors.purple,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        /*actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.purple),
                const SizedBox(width: 4),
                Text(
                  '3.5',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],*/
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                _buildImageOrPlaceholder(),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NOME DO PRESTADOR',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      widget.prestador.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.handyman,
                        color: Colors.purple,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SERVIÇO',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          widget.prestador.tags.isNotEmpty
                              ? widget.prestador.tags.first.nome
                              : 'Não especificado',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.purple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.attach_money,
                        color: Colors.purple,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VALOR / HORA',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              '50',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.purple,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              ',00',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.purple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EMAIL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.prestador.email ?? 'Não possui email',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.purple,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descrição',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Text(
                  widget.prestador.descricao ?? 'Sem descrição',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero),
          ),
          child: const Text(
            'Solicitar agendamento',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}