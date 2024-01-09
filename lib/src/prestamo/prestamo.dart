// prestamo.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrestamoScreen extends StatefulWidget {
  @override
  _PrestamoScreenState createState() => _PrestamoScreenState();
}

class _PrestamoScreenState extends State<PrestamoScreen> {
  DateTime? _selectedDate;
  TextEditingController _cantidadController = TextEditingController();
  TextEditingController _interesController = TextEditingController();
  TextEditingController _metodoSalidaController = TextEditingController();
  TextEditingController _origenFuenteController = TextEditingController();
  TextEditingController _garantiaController = TextEditingController();

  // Agregamos una lista de clientes y una variable para almacenar el cliente seleccionado
  List<Map<String, dynamic>> clientes = [];
  Map<String, dynamic>? _selectedCliente;

  @override
  void initState() {
    super.initState();
    // Llamada a la API al inicializar el widget
    _fetchClientes();
  }

  Future<void> _fetchClientes() async {
    final response = await http.get(Uri.parse('http://localhost:3000/clientes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        clientes = data.cast<Map<String, dynamic>>();
      });
    } else {
      print('Error al cargar clientes: ${response.statusCode}');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Realizar Préstamo'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(),
          _buildClienteDropdown(),
          _buildTextField('Cantidad', _cantidadController, TextInputType.number),
          _buildTextField('Interés (%)', _interesController, TextInputType.number),
          _buildTextField('Método de Salida', _metodoSalidaController, TextInputType.text),
          _buildTextField('Origen Fuente', _origenFuenteController, TextInputType.text),
          _buildTextField('Garantía', _garantiaController, TextInputType.text),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _realizarPrestamo,
            child: Text('Realizar Préstamo'),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTextField(String label, TextEditingController controller, TextInputType inputType) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
      ),
    ),
  );
}


  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Fecha',
            hintText: 'Seleccione una fecha',
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_selectedDate != null
                  ? '${_selectedDate!.toLocal().day}/${_selectedDate!.toLocal().month}/${_selectedDate!.toLocal().year}'
                  : 'Seleccione una fecha'),
              Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildClienteDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<Map<String, dynamic>>(
        decoration: InputDecoration(
          labelText: 'ID Cliente',
        ),
        value: _selectedCliente,
        items: clientes.map((cliente) {
          return DropdownMenuItem<Map<String, dynamic>>(
            value: cliente,
            child: Text('${cliente['id']} - ${cliente['nombre']}'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCliente = value;
          });
        },
      ),
    );
  }

Future<void> _realizarPrestamo() async {
  // Valida que los campos no estén vacíos
  if (_selectedDate == null ||
      _selectedCliente == null ||
      _cantidadController.text.isEmpty ||
      _interesController.text.isEmpty ||
      _metodoSalidaController.text.isEmpty ||
      _origenFuenteController.text.isEmpty ||
      _garantiaController.text.isEmpty) {
    // Muestra un mensaje de error
    _showErrorDialog('Todos los campos son obligatorios');
    return;
  }

  // Prepara el cuerpo del JSON para la solicitud
  final Map<String, dynamic> prestamoData = {
    'fecha': _selectedDate!.toLocal().toString().split(' ')[0],
    'id_cliente': _selectedCliente!['id'],
    // Suponiendo que id_inversion no es obligatorio en el JSON
    //'id_inversion': 1,
    'cantidad': double.parse(_cantidadController.text),
    'interes': double.parse(_interesController.text),
    'metodo_salida': _metodoSalidaController.text,
    'origen_fuente': _origenFuenteController.text,
    'garantia': _garantiaController.text,
  };

  try {
    // Realiza la solicitud HTTP para realizar el préstamo
    final response = await http.post(
      Uri.parse('http://localhost:3000/prestamos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(prestamoData),
    );

    if (response.statusCode == 201) {
      // Préstamo realizado exitosamente
      // navegar de nuevo a la pantalla principal
      _showSuccessDialog('Préstamo realizado exitosamente');
      Navigator.pop(context, true);
    } else {
      // Manejar el error en caso de que la solicitud falle
      final Map<String, dynamic> errorData = json.decode(response.body);
      final errorMessage = errorData['message'] ?? 'Error al realizar el préstamo';
      _showErrorDialog(errorMessage);
    }
  } catch (error) {
    print('Error: $error');
    _showErrorDialog('Error al realizar el préstamo');
  }
}

void _showSuccessDialog(String successMessage) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Éxito'),
      content: Text(successMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}

void _showErrorDialog(String errorMessage) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}

}
