// clientes/add_cliente.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddClienteScreen extends StatefulWidget {
  @override
  _AddClienteScreenState createState() => _AddClienteScreenState();
}

class _AddClienteScreenState extends State<AddClienteScreen> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Nombre', _nombreController),
            _buildTextField('Apellidos', _apellidosController),
            _buildTextField('Teléfono', _telefonoController),
            _buildTextField('Dirección', _direccionController),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addCliente,
              child: Text('Agregar Cliente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  Future<void> _addCliente() async {
    // Lógica para agregar el cliente
    final nombre = _nombreController.text;
    final apellido = _apellidosController.text;
    final telefono = _telefonoController.text;
    final direccion = _direccionController.text;

    // Valida que los campos no estén vacíos
    if (nombre.isEmpty || apellido.isEmpty || telefono.isEmpty || direccion.isEmpty) {
      // Muestra un mensaje de error
      _showErrorDialog('Todos los campos son obligatorios');
      return;
    }

    // Realiza la solicitud HTTP para agregar el cliente
    final response = await http.post(
      Uri.parse('http://localhost:3000/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'direccion': direccion,
      }),
    );

    if (response.statusCode == 201) {
      // Cliente agregado exitosamente
      // Puedes realizar alguna acción, como navegar de nuevo a la pantalla de clientes
      Navigator.pop(context);
    } else {
      // Manejar el error en caso de que la solicitud falle
      _showErrorDialog('Error al agregar el cliente');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
