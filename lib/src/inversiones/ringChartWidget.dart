// anillo_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnilloChart extends StatelessWidget {
  final double cantidadDisponible;
  final double cantidadTotalInversiones;

  AnilloChart({required this.cantidadDisponible, required this.cantidadTotalInversiones});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: cantidadDisponible,
              title: '\$${cantidadDisponible.toStringAsFixed(2)}',
              radius: 70,
            ),
            PieChartSectionData(
              color: Colors.orange,
              value: cantidadTotalInversiones,
              title: '\$${cantidadTotalInversiones.toStringAsFixed(2)}',
              radius: 70,
            ),
          ],
        ),
      ),
    );
  }
}
