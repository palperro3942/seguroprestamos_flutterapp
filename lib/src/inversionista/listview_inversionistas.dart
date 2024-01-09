// inversionista/listview_inversionistas.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seguroprestamos_flutterapp/src/inversionista/inversionista_details.dart';

class ListViewInversionistas extends StatefulWidget {
  @override
  _ListViewInversionistasState createState() => _ListViewInversionistasState();
}

class _ListViewInversionistasState extends State<ListViewInversionistas> {
  List<Map<String, dynamic>> listaInversionistas = [];

  @override
  void initState() {
    super.initState();
    _fetchInversionistas();
  }

  Future<void> _fetchInversionistas() async {
    final response = await http.get(Uri.parse('http://localhost:3000/inversionistas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        listaInversionistas = List<Map<String, dynamic>>.from(data);
      });
    } else {
      // Manejar error
      print('Error al obtener inversionistas: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listaInversionistas.length,
      itemBuilder: (context, index) {
        final inversionista = listaInversionistas[index];
        return _buildInversionistaItem(context, inversionista);
      },
    );
  }

  Widget _buildInversionistaItem(BuildContext context, Map<String, dynamic> inversionista) {
    return ListTile(
      title: Text(inversionista['nombre'] ?? ''),
      onTap: () {
        _navigateToInversionistaDetails(context, inversionista);
      },
    );
  }

  void _navigateToInversionistaDetails(BuildContext context, Map<String, dynamic> inversionista) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InversionistaDetailsScreen(inversionista: inversionista),
      ),
    );
  }
}
