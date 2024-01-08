// inversionistas.dart
import 'package:flutter/material.dart';
import 'package:seguroprestamos_flutterapp/src/inversionista/listview_inversionistas.dart';

class InversionistasScreen extends StatefulWidget {
  @override
  _InversionistasScreenState createState() => _InversionistasScreenState();
}

class _InversionistasScreenState extends State<InversionistasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inversionistas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Lógica para agregar un nuevo inversionista
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
                labelText: 'Buscar Inversionista',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListViewInversionistas(), // Reemplazar con tu lista de inversionistas
          ),
        ],
      ),
    );
  }
}
