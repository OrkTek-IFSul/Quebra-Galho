import 'package:flutter/material.dart';

class JobItem extends StatelessWidget {
  final String name;
  final String address;
  final String time;
  final double value;

  const JobItem({
    super.key,
    required this.name,
    required this.address,
    required this.time,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple,
        border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
      ),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(address, style: TextStyle(color: Colors.white70)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(time, style: TextStyle(color: Colors.white70)),
            Text(
              'R\$ ${value.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
