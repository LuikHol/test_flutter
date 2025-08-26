import 'package:flutter/material.dart';

class EmptyPersonsList extends StatelessWidget {
  const EmptyPersonsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(fontSize: 18, color: Colors.deepPurple),
          children: [
            TextSpan(text: 'Nenhuma pessoa cadastrada.\nClique no '),
            TextSpan(
              text: 'botão',
              style: TextStyle(
                color: Color.fromARGB(255, 237, 126, 30),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: ' para adicionar.'),
          ],
        ),
      ),
    );
  }
}