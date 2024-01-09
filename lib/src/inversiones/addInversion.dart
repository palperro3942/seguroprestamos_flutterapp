import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarInversionScreen extends StatefulWidget {
  @override
  _AgregarInversionScreenState createState() => _AgregarInversionScreenState();
}

class _AgregarInversionScreenState extends State<AgregarInversionScreen> {
  final TextEditingController _folioController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _metodoIngresoController =
      TextEditingController();
  final TextEditingController _porcentajeInteresController =
      TextEditingController();
  String? _selectedInversionista; // ID del inversionista seleccionado
  List<Map<String, dynamic>> inversionistas = []; // Lista de inversionistas

  @override
  void initState() {
    super.initState();
    _fetchInversionistas(); // Obtener la lista de inversionistas al iniciar la pantalla
  }

  Future<void> _fetchInversionistas() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/inversionistas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        inversionistas = data.cast<Map<String, dynamic>>();
      });
    } else {
      // Manejar errores aquí
      print('Error al obtener inversionistas: ${response.statusCode}');
    }
  }

  Future<void> _agregarInversion() async {
    final url = Uri.parse('http://localhost:3000/inversiones');

    final response = await http.post(
      url,
      body: jsonEncode({
        "folio": _folioController.text,
        "fecha": _fechaController.text,
        "cantidad": _cantidadController.text,
        "cantidad_disponible": _cantidadController.text,
        "metodo_ingreso": _metodoIngresoController.text,
        "porcentaje_interes": _porcentajeInteresController.text,
        "id_inversionista":
            int.parse(_selectedInversionista!.split(' - ')[0]), // Parsea a int
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // Éxito: Inversión agregada correctamente
      _mostrarSnackBar('Inversión agregada correctamente');
      Navigator.pop(context); // Cerrar la pantalla actual
    } else {
      // Manejar errores aquí, por ejemplo, mostrar un mensaje al usuario
      _mostrarSnackBar('Error al agregar la inversión');
      print('Error al agregar inversión: ${response.statusCode}');
    }
  }

  void _mostrarSnackBar(String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(
          seconds: 2), // Puedes ajustar la duración según tus necesidades
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Inversión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _folioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Folio (Número)'),
            ),
            TextField(
              controller: _fechaController,
              decoration: InputDecoration(labelText: 'Fecha'),
            ),
            TextField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Cantidad (Dinero)'),
            ),
            TextField(
              controller: _metodoIngresoController,
              decoration: InputDecoration(labelText: 'Método de Ingreso'),
            ),
            TextField(
              controller: _porcentajeInteresController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Porcentaje de Interés'),
            ),
            DropdownButton<String>(
              value: _selectedInversionista,
              items: inversionistas.map((inversionista) {
                return DropdownMenuItem<String>(
                  value:
                      '${inversionista['id']} - ${inversionista['nombre']} ${inversionista['apellido']}',
                  child: Text(
                      '${inversionista['id']} - ${inversionista['nombre']} ${inversionista['apellido']}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedInversionista = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _agregarInversion,
              child: Text('Agregar Inversión'),
            ),
          ],
        ),
      ),
    );
  }
}
