import 'package:flutter/material.dart';

class AdicionarServicoPage extends StatefulWidget {
  const AdicionarServicoPage({super.key});

  @override
  State<AdicionarServicoPage> createState() => _AdicionarServicoPageState();
}

class _AdicionarServicoPageState extends State<AdicionarServicoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  void _salvarServico() {
    if (_formKey.currentState!.validate()) {
      String nome = _nomeController.text;
      String descricao = _descricaoController.text;
      int valor = int.parse(_valorController.text);

      // Aqui você pode fazer o salvamento real do serviço, como enviar para o backend ou salvar localmente

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Serviço "$nome" adicionado com sucesso!')),
      );

      // Limpar campos
      _nomeController.clear();
      _descricaoController.clear();
      _valorController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Serviço'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Novo Serviço',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do serviço',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              SizedBox(height: 16),

              // Campo Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a descrição' : null,
              ),
              SizedBox(height: 16),

              // Campo Valor
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: 'Valor (R\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor';
                  }
                  final n = int.tryParse(value);
                  if (n == null) return 'Digite apenas números inteiros';
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  label: Text('Salvar Serviço'),
                  onPressed: _salvarServico,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
