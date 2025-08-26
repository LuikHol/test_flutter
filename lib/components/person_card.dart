import 'package:flutter/material.dart';
import '../models/person.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final Function(Person) onEdit;
  final Function(String) onDelete;

  const PersonCard({
    super.key,
    required this.person,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color.fromARGB(255, 243, 131, 33)),
                      onPressed: () => onEdit(person),
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(person.id),
                      tooltip: 'Excluir',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Idade: ${person.age} anos'),
            const SizedBox(height: 4),
            Text('CPF: ${person.cpf}'),
          ],
        ),
      ),
    );
  }
}
