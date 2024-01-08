// abonos.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AbonosScreen extends StatelessWidget {
  // Simula la lista de clientes, debes reemplazarla con la lista real de clientes
  final List<Map<String, dynamic>> listaClientes = [
    {'id': 1, 'nombre': 'Cliente 1'},
    {'id': 2, 'nombre': 'Cliente 2'},
    // ... más clientes ...
  ];

  // Variable para almacenar el cliente seleccionado
  Map<String, dynamic>? clienteSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Abonos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountToPay(),
            _buildDueDate(context),
            _buildPaymentMethod(),
            _buildPaymentOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountToPay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cantidad a Pagar',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        // Modificado para aceptar solo números
        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: 'Ingrese la cantidad',
            prefixIcon: Icon(Icons.attach_money),
          ),
        ),
      ],
    );
  }

  Widget _buildDueDate(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        Text(
          'Fecha de Pago',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () => _selectDueDate(context),
          child: Text('Seleccionar Fecha'),
        ),
      ],
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Lógica para manejar la fecha seleccionada
    }
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        Text(
          'Método de Pago',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        // Aquí puedes proporcionar opciones para seleccionar el método de pago
        // Por ejemplo, utilizando un DropdownButton
        DropdownButton<String>(
          items: ['Depósito', 'Efectivo']
              .map((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (String? value) {
            // Lógica para manejar el método de pago seleccionado
          },
          hint: Text('Seleccionar Método de Pago'),
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        Text(
          'Seleccionar Cliente',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        // Aquí se muestra el ListBox de clientes
        DropdownButton<Map<String, dynamic>>(
          value: clienteSeleccionado,
          items: listaClientes
              .map((cliente) => DropdownMenuItem<Map<String, dynamic>>(
                    value: cliente,
                    child: Text(cliente['nombre'] ?? ''),
                  ))
              .toList(),
          onChanged: (Map<String, dynamic>? value) {
            // Lógica para manejar el cliente seleccionado
            clienteSeleccionado = value;
          },
          hint: Text('Seleccionar Cliente'),
        ),
      ],
    );
  }
}
