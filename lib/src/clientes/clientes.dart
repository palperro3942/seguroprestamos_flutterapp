// clientes.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seguroprestamos_flutterapp/src/clientes/cliente_details.dart';

class ClientesScreen extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Map<String, dynamic>> clientes = [];

  @override
  void initState() {
    super.initState();
    // Llamada a la API al inicializar el widget
    _fetchClientes();
  }

  Future<void> _fetchClientes() async {
    final response = await http.get(Uri.parse('http://localhost:3000/personas/cliente'));

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, analiza el cuerpo de la respuesta
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        clientes = data.cast<Map<String, dynamic>>();
      });
    } else {
      // Si la solicitud falla, muestra un mensaje de error
      print('Error al cargar clientes: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Lógica para agregar un nuevo cliente
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar Cliente',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return _buildClientItem(cliente);
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildClientItem(Map<String, dynamic> cliente) {
  return ListTile(
    title: Text(cliente['nombre']),
    trailing: PopupMenuButton<String>(
      onSelected: (value) {
        // Lógica para las opciones de cliente seleccionadas
        if (value == 'editar') {
          // Lógica para editar el cliente
        } else if (value == 'eliminar') {
          // Lógica para eliminar el cliente
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'editar',
          child: Text('Editar'),
        ),
        PopupMenuItem<String>(
          value: 'eliminar',
          child: Text('Eliminar'),
        ),
      ],
    ),
    onTap: () {
      _navigateToClienteDetails(cliente);
    },
  );
}

void _navigateToClienteDetails(Map<String, dynamic> cliente) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ClienteDetailsScreen(cliente: cliente),
    ),
  );
}
}
