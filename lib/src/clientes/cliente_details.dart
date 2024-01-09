// clientes/clientes_details.dart
import 'package:flutter/material.dart';

class ClienteDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> cliente;

  ClienteDetailsScreen({required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Nombre', cliente['nombre']),
            _buildDetailRow('Apellido', cliente['apellido']),
            _buildDetailRow('Teléfono', cliente['telefono']),
            _buildDetailRow('Dirección', cliente['direccion']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }
}

