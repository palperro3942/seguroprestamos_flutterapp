import 'package:flutter/material.dart';

class InversionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> inversion;

  InversionDetailsScreen({required this.inversion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Inversión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Folio: ${inversion['folio']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Fecha: ${inversion['fecha']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Cantidad: \$${inversion['cantidad']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Método de Ingreso: ${inversion['metodo_ingreso']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Porcentaje de Interés: ${inversion['porcentaje_interes']}%',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Inversionista: ${inversion['inversionista']['nombre']} ${inversion['inversionista']['apellido']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
