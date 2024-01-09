import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seguroprestamos_flutterapp/src/inversionista/addInversionista.dart';
import 'dart:convert';

import 'package:seguroprestamos_flutterapp/src/inversionista/inversionista_details.dart';

class InversionistasScreen extends StatefulWidget {
  @override
  _InversionistasScreenState createState() => _InversionistasScreenState();
}

class _InversionistasScreenState extends State<InversionistasScreen> {
  List<Map<String, dynamic>> inversionistas = [];
  List<Map<String, dynamic>> inversionistasFiltrados = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInversionistas();
  }

  Future<void> _fetchInversionistas() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/inversionistas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        inversionistas = data.cast<Map<String, dynamic>>();
        inversionistasFiltrados.addAll(inversionistas);
      });
    } else {
      print('Error al cargar inversionistas: ${response.statusCode}');
    }
  }

  void _filtrarInversionistas(String filtro) {
    setState(() {
      inversionistasFiltrados = inversionistas
          .where((inversionista) =>
              inversionista['nombre']
                  .toLowerCase()
                  .contains(filtro.toLowerCase()) ||
              inversionista['apellido']
                  .toLowerCase()
                  .contains(filtro.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inversionistas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (filtro) => _filtrarInversionistas(filtro),
              decoration: InputDecoration(
                labelText: 'Buscar Inversionista',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: inversionistasFiltrados.length,
              itemBuilder: (context, index) {
                final inversionista = inversionistasFiltrados[index];
                return ListTile(
                  title: Text(
                      '${inversionista['nombre']} ${inversionista['apellido']}'),
                  subtitle: Text('Teléfono: ${inversionista['telefono']}'),
                  onTap: () {
                    _navigateToInversionistaDetails(inversionista);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de agregar inversionista
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarInversionistaScreen()),
          );
        },
        child: Icon(Icons.person_add),
      ),
    );
  }

  void _navigateToInversionistaDetails(Map<String, dynamic> inversionista) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InversionistaDetailsScreen(inversionista: inversionista),
      ),
    );
  }
}
