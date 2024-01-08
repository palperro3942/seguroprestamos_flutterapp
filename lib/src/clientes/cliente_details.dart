// cliente_details.dart
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
            _buildDetailRow('Dirección', _buildDireccion(cliente)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _buildDireccion(Map<String, dynamic> cliente) {
    return '${cliente['calle']}, ${cliente['numero']}, ${cliente['colonia']}, ${cliente['codigo_postal']}, ${cliente['ciudad']}, ${cliente['estado']}, ${cliente['pais']}';
  }
}
