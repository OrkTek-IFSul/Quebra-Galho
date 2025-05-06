import 'package:flutter/material.dart';

class PrestadorFormModal extends StatelessWidget {
  const PrestadorFormModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () {
            Navigator.of(context).pop(); // Volta para a tela anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            // Título principal
            Text(
              'Quero ser um\nprestador de serviço',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            // Descrição
            Text(
              'Para garantir a segurança, confiança e transparência entre os usuários da plataforma, é necessário que todos os prestadores de serviço realizem o cadastro com CPF ou CNPJ, além de fazer o upload de um documento oficial com foto.\n\n'
              'Essa verificação nos ajuda a manter um ambiente mais seguro para todos, prevenindo fraudes e assegurando que os serviços sejam realizados por pessoas ou empresas devidamente identificadas.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 24),
            // Campo CPF / CNPJ
            Text(
              'CPF / CNPJ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '035.122.470.08',
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
            // Upload de documento
            GestureDetector(
              onTap: () {
                // Lógica para upload do documento
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.purple.shade50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: Colors.purple, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Upload de documento\n(RG, CPF ou Comprovante de CNPJ)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            // Botão "Solicitar"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para solicitar cadastro
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Solicitar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}