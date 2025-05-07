import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/widgets/JobItem.dart';

class HistoricoValores extends StatelessWidget {
  const HistoricoValores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed header section with profession and rating
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Mecânico',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.star, color: Colors.purple, size: 20),
                        Text(
                          '3.5',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'R\$',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '50',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          '/h',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Valor por serviço',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 54, 54, 54),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),

          // Title for recent jobs
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  color: const Color.fromARGB(255, 40, 0, 87),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Últimos trabalhos',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color.fromARGB(255, 40, 0, 87),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable list that fills remaining space
          Expanded(
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                JobItem(
                  name: 'Jean Carlo',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 100.0,
                ),
                JobItem(
                  name: 'Rogério Silva',
                  address: 'Av. Vasco Aires, 1986',
                  time: '16:00 - 19:00',
                  value: 50.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
                JobItem(
                  name: 'Maicol Dieckson',
                  address: 'Av. Vasco Aires, 1986',
                  time: '14:00 - 17:00',
                  value: 150.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
