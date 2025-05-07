import 'package:flutter/material.dart';

class EditarTelefoneModal extends StatelessWidget {
  const EditarTelefoneModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.purple),
                  onPressed: () {
                    Navigator.of(context).pop(); // Volta para a tela anterior
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título principal
                Text(
                  'Qual o seu \ntelefone de contato?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 8),
                // Subtítulo
                Text(
                  'Digite seu telefone atualizado',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 95, 95, 95),
                  ),
                ),
                SizedBox(height: 24),
                // Campo de texto para o email
                TextField(
                  decoration: InputDecoration(
                    hintText: '(55) 99999-9999',
                    hintStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                // Botão Alterar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para alterar o email
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Alterar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
