import 'package:flutter/material.dart';
import '../modeles/donnees.dart';

class EmptyBody extends StatelessWidget {
  const EmptyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(Donnees.noDataMessage),
    );
  }
}

class EmptyScaffold extends StatelessWidget {
  const EmptyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const EmptyBody(),
    );
  }
}
