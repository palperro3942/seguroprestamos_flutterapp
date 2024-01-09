import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultarPrestamoScreen extends StatefulWidget {
  @override
  _ConsultarPrestamoScreenState createState() =>
      _ConsultarPrestamoScreenState();
}

class _ConsultarPrestamoScreenState extends State<ConsultarPrestamoScreen> {
  List<Map<String, dynamic>> prestamos = [];
  List<Map<String, dynamic>> prestamosFiltrados = []; // Lista para almacenar los préstamos filtrados

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Llamada a la API al inicializar el widget
    _fetchPrestamos();
  }

  Future<void> _fetchPrestamos() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/prestamos'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          prestamos = data.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error al cargar préstamos: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _filterPrestamos(String query) {
    setState(() {
      prestamosFiltrados = prestamos.where((prestamo) {
        final cliente = prestamo['cliente'];
        final nombreCompleto = '${cliente['nombre']} ${cliente['apellido']}'.toLowerCase();
        return nombreCompleto.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Préstamos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPrestamos,
              decoration: InputDecoration(
                labelText: 'Buscar Préstamo por Cliente',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchController.text.isEmpty ? prestamos.length : prestamosFiltrados.length,
              itemBuilder: (context, index) {
                final prestamo = _searchController.text.isEmpty ? prestamos[index] : prestamosFiltrados[index];
                final cliente = prestamo['cliente'];

                return ListTile(
                  title: Text(
                    'Préstamo de ${cliente != null ? "${cliente['nombre']} ${cliente['apellido']}" : 'Cliente Desconocido'} '
                    'con ID ${prestamo['id']} el día ${prestamo['fecha']} por \$${prestamo['cantidad']}',
                  ),
                  onTap: () {
                    _navigateToPrestamoDetails(prestamo);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPrestamoDetails(Map<String, dynamic> prestamo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrestamoDetailsScreen(prestamo: prestamo),
      ),
    );
  }
}

class PrestamoDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> prestamo;

  PrestamoDetailsScreen({required this.prestamo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Préstamo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Fecha', prestamo['fecha']),
            _buildDetailRow('Cantidad', '\$${prestamo['cantidad']}'),
            _buildDetailRow('Interés', '${prestamo['interes']}%'),
            _buildDetailRow('Método de Salida', prestamo['metodo_salida']),
            _buildDetailRow('Origen Fuente', prestamo['origen_fuente']),
            _buildDetailRow('Garantía', prestamo['garantia']),
            _buildDetailRow('Cliente', _buildClienteInfo(prestamo['cliente'])),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }

  String _buildClienteInfo(Map<String, dynamic>? cliente) {
    if (cliente != null) {
      return 'ID Cliente: ${cliente['id']}\nNombre: ${cliente['nombre']} ${cliente['apellido']}\nTeléfono: ${cliente['telefono']}\nDirección: ${cliente['direccion']}';
    } else {
      return 'N/A';
    }
  }
}
