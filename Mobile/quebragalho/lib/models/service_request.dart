import 'package:flutter/material.dart';

class ServiceRequest {
  final String nome;
  final String data;
  final String hora;
  final String status;
  final Color statusColor;

  ServiceRequest({
    required this.nome,
    required this.data,
    required this.hora,
    required this.status,
    required this.statusColor,
  });
}
