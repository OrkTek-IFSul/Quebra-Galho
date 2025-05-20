import 'package:flutter/material.dart';

/// WIDGET PRA EXIBIR AS INFO BONITINHAS
class InfoCamposPerfil extends StatelessWidget {
  final String titulo;
  final String valor;

  const InfoCamposPerfil({super.key, required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$titulo: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(valor),
          ),
        ],
      ),
    );
  }
}
