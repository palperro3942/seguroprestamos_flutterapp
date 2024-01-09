import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seguroprestamos_flutterapp/src/inversiones/inversionDetails.dart';
import 'dart:convert';

import 'package:seguroprestamos_flutterapp/src/inversiones/ringChartWidget.dart';

class InversionesScreen extends StatefulWidget {
  @override
  _InversionesScreenState createState() => _InversionesScreenState();
}

class _InversionesScreenState extends State<InversionesScreen> {
  List<Map<String, dynamic>> inversiones = [];

  @override
  void initState() {
    super.initState();
    _fetchInversiones();
  }

  Future<void> _fetchInversiones() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/inversiones'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        inversiones = data.cast<Map<String, dynamic>>();
      });
    } else {
      print('Error al cargar inversiones: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inversiones'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildResumenInversiones(),
            _buildInversionesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInversionesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: inversiones.length,
      itemBuilder: (context, index) {
        final inversion = inversiones[index];
        return _buildInversionItem(inversion);
      },
    );
  }

  Widget _buildResumenInversiones() {
    // Calcular la cantidad total de inversiones y la cantidad disponible para préstamos
    double cantidadTotal = 0;
    double cantidadDisponible = 0;

    inversiones.forEach((inversion) {
      cantidadTotal += double.parse(inversion['cantidad']);
      cantidadDisponible += double.parse(inversion['cantidad_disponible']);
    });

    return Column(
      children: [
        AnilloChart(
          cantidadDisponible: cantidadDisponible,
          cantidadTotalInversiones: cantidadTotal,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dinero Disponible para Préstamos: \$${cantidadDisponible.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Cantidad Total de Inversiones: \$${cantidadTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInversionItem(Map<String, dynamic> inversion) {
    final inversionista = inversion['inversionista'];
    return ListTile(
      title: Text(
          'Inversión con Folio: ${inversion['folio']} de ${inversionista['nombre']} ${inversionista['apellido']}'),
      subtitle: Text(
          'Fecha: ${inversion['fecha']} - Cantidad: \$${inversion['cantidad']}'),
      onTap: () {
        _navigateToInversionDetails(inversion);
      },
    );
  }

  void _navigateToInversionDetails(Map<String, dynamic> inversion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InversionDetailsScreen(inversion: inversion),
      ),
    );
  }
}
