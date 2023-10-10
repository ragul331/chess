import 'package:flutter/material.dart';

class NameCard extends StatelessWidget {
  const NameCard({super.key, required this.name, required this.mailId});
  final String name;
  final String mailId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: ListTile(
        trailing: const Icon(
          Icons.arrow_circle_right_outlined,
          color: Colors.white,
        ),
        tileColor: const Color.fromARGB(255, 209, 209, 209),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          mailId,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
