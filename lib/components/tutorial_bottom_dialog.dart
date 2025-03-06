import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorialDialog extends StatelessWidget {
  const TutorialDialog({super.key});

  static void show() => showDialog(
        context: Get.context!,
        builder: (_) => const TutorialDialog(),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Como jogar?", textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text(
            "Fechar",
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              Text(
                "• O objetivo é preencher a grade 9x9 com números de 1 a 9.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 6),
              Text(
                "• Cada linha, coluna e região 3x3 não pode repetir números.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 6),
              Text(
                "• Use lógica para deduzir os números corretos.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 6),
              Text(
                "• Faça anotações para atingir o objetivo mais rapidamente.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
