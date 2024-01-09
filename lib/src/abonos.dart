import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AbonosScreen extends StatefulWidget {
  @override
  _AbonosScreenState createState() => _AbonosScreenState();
}

class _AbonosScreenState extends State<AbonosScreen> {
  List<Map<String, dynamic>> prestamos = []; // Aquí almacenarás los préstamos
  Map<String, dynamic>? prestamoSeleccionado; // Aquí almacenarás el préstamo seleccionado
  TextEditingController cantidadController = TextEditingController();
  DateTime? fechaSeleccionada;
  String metodoPagoSeleccionado = 'Efectivo'; // Valor por defecto

  @override
  void initState() {
    super.initState();
    _fetchPrestamos();
  }

  Future<void> _fetchPrestamos() async {
    // Lógica para obtener la lista de préstamos desde tu API
    // ...

    // Ejemplo de lista de préstamos
    final response = await http.get(Uri.parse('http://localhost:3000/prestamos'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        prestamos = data.cast<Map<String, dynamic>>();
      });
    } else {
      print('Error al cargar préstamos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Abonos'),
      ),
      body: Column(
        children: [
          _buildPrestamosList(),
          if (prestamoSeleccionado != null) _buildAbonoForm(),
        ],
      ),
    );
  }

  Widget _buildPrestamosList() {
    return Expanded(
      child: ListView.builder(
        itemCount: prestamos.length,
        itemBuilder: (context, index) {
          final prestamo = prestamos[index];
          return ListTile(
            title: Text('Préstamo ${prestamo['id']}'),
            subtitle: Text('Cantidad: \$${prestamo['cantidad']}'),
            onTap: () {
              setState(() {
                prestamoSeleccionado = prestamo;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildAbonoForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Detalles del Préstamo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('ID: ${prestamoSeleccionado!['id']}'),
          Text('Cantidad: \$${prestamoSeleccionado!['cantidad']}'),
          SizedBox(height: 16),
          TextField(
            controller: cantidadController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Ingrese cantidad a pagar'),
          ),
          SizedBox(height: 16),
          _buildDatePicker(),
          SizedBox(height: 16),
          _buildMetodoPagoDropdown(),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Lógica para procesar el abono
              _procesarAbono();
            },
            child: Text('Realizar Abono'),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        Text('Fecha de Pago: '),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );

              if (selectedDate != null && selectedDate != fechaSeleccionada) {
                setState(() {
                  fechaSeleccionada = selectedDate;
                });
              }
            },
            child: Text(
              fechaSeleccionada == null
                  ? 'Seleccionar Fecha'
                  : '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetodoPagoDropdown() {
    return Row(
      children: [
        Text('Método de Pago: '),
        SizedBox(width: 16),
        DropdownButton<String>(
          value: metodoPagoSeleccionado,
          items: ['Efectivo', 'Transferencia', 'Depósito', 'Otro']
              .map((metodo) => DropdownMenuItem<String>(
                    value: metodo,
                    child: Text(metodo),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              metodoPagoSeleccionado = value!;
            });
          },
        ),
      ],
    );
  }

  void _procesarAbono() {
    // Lógica para procesar el abono aquí
    // ...

    // Mostrar mensaje de éxito
    _mostrarSnackBar('Abono realizado correctamente');
  }

  void _mostrarSnackBar(String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
