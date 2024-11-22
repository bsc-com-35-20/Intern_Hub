import 'package:flutter/material.dart';

class Hahah extends StatelessWidget {
  const Hahah({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Hahah'),
      ),
      body: Center(
        child: TextField(
          controller: controller,
        ),
      ),
    );
  }
}
