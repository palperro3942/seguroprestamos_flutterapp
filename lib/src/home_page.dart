import 'package:flutter/material.dart';
import 'package:seguroprestamos_flutterapp/src/abonos.dart';
import 'package:seguroprestamos_flutterapp/src/clientes/clientes.dart';
import 'package:seguroprestamos_flutterapp/src/inversionista/inversionistas.dart';
import 'package:seguroprestamos_flutterapp/src/reportes.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: <Widget>[
            _buildButton(context, 'Solicitar Préstamo', Colors.blue, () {
              // Lógica para la pantalla de solicitud de préstamo
            }),
            _buildButton(context, 'Abonos', Colors.green, () {
              // Navegar a la pantalla de abonos
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AbonosScreen()),
              );
            }),
            _buildButton(context, 'Inversionistas', Colors.orange, () {
              // Navegar a la pantalla de inversionistas
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InversionistasScreen()),
              );
            }),
            _buildButton(context, 'Clientes', Colors.red, () {
              // Navegar a la pantalla de clientes
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClientesScreen()),
              );
            }),
            _buildButton(context, 'Reportes', Colors.purple, () {
              // Navegar a la pantalla de reportes
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportesScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String title, Color color, Function() onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}