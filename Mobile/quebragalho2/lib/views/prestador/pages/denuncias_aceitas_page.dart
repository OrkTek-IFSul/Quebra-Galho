import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';

class DenunciasAceitasPage extends StatefulWidget {
  final int idPrestador;

  const DenunciasAceitasPage({super.key, required this.idPrestador});

  @override
  State<DenunciasAceitasPage> createState() => _DenunciasAceitasPageState();
}

class _DenunciasAceitasPageState extends State<DenunciasAceitasPage> {
  List<dynamic> denuncias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDenuncias();
  }

  Future<void> fetchDenuncias() async {
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/denuncia/${widget.idPrestador}',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> todas = jsonDecode(response.body);
        // Mantém só as aceitas:
        final aceitas = todas.where((d) => d['status'] == true).toList();
        setState(() {
          denuncias = aceitas;
          isLoading = false;
        });
      } else {
        throw Exception('Status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar denúncias: $e');
      setState(() => isLoading = false);
    }
  }

  void abrirCriarApeloDialog(int idDenuncia) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Criar Apelo'),
            content: TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Justificativa'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => enviarApelo(idDenuncia, controller.text),
                child: const Text('Enviar'),
              ),
            ],
          ),
    );
  }

  Future<void> enviarApelo(int idDenuncia, String justificativa) async {
    final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/apelo');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_denuncia': idDenuncia,
          'justificativa': justificativa,
        }),
      );

      Navigator.pop(context); // fecha o dialog

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final apeloId = data['apeloId'];
        final status =
            data['status'] == true ? 'aceito automaticamente' : 'pendente';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Apelo #$apeloId criado com status $status.')),
        );
      } else {
        debugPrint(
          'Falha ao enviar apelo: ${response.statusCode} ${response.body}',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar apelo: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      debugPrint('Erro ao enviar apelo: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao enviar apelo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Denúncias Aceitas')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : denuncias.isEmpty
              ? const Center(child: Text('Nenhuma denúncia aceita.'))
              : ListView.builder(
                itemCount: denuncias.length,
                itemBuilder: (context, index) {
                  final d = denuncias[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('Motivo: ${d['motivo']}'),
                      subtitle: Text('Tipo: ${d['tipo']}'),
                      trailing: ElevatedButton(
                        onPressed: () => abrirCriarApeloDialog(d['denunciaId']),
                        child: const Text('Apelar'),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
