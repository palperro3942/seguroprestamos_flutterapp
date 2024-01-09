import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarInversionistaScreen extends StatefulWidget {
  @override
  _AgregarInversionistaScreenState createState() =>
      _AgregarInversionistaScreenState();
}

class _AgregarInversionistaScreenState
    extends State<AgregarInversionistaScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  Future<void> _agregarInversionista() async {
    final url = Uri.parse('http://localhost:3000/inversionistas');

    final response = await http.post(
      url,
      body: jsonEncode({
        "nombre": _nombreController.text,
        "apellido": _apellidoController.text,
        "telefono": _telefonoController.text,
        "direccion": _direccionController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // Éxito: Inversionista agregado correctamente
      Navigator.pop(context); // Cerrar la pantalla actual
    } else {
      // Manejar errores aquí, por ejemplo, mostrar un mensaje al usuario
      print('Error al agregar inversionista: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Inversionista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: _direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _agregarInversionista,
              child: Text('Agregar Inversionista'),
            ),
          ],
        ),
      ),
    );
  }
}
