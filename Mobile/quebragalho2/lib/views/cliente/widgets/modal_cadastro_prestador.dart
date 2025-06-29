import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';

void showCadastroPrestadorModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
            const SizedBox(height: 16),
            const Text(
              "Você precisa fazer um cadastro oficial como prestador no aplicativo caso deseja acessar esta seção",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o modal
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CadastroPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text("Cadastre-se", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      );
    },
  );
}