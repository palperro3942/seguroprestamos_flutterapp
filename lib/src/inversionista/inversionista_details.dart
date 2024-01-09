import 'package:flutter/material.dart';

class InversionistaDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> inversionista;

  InversionistaDetailsScreen({required this.inversionista});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Inversionista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${inversionista['nombre']} ${inversionista['apellido']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Teléfono: ${inversionista['telefono']}'),
            SizedBox(height: 10),
            Text('Dirección: ${inversionista['direccion']}'),
          ],
        ),
      ),
    );
  }
}
