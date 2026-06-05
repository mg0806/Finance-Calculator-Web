import 'package:flutter/material.dart';

import '../navigation.dart';

class CalculatorCtaBanner extends StatelessWidget {
  const CalculatorCtaBanner(
      {required this.title, required this.route, super.key});

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(color: theme.colorScheme.primary, width: 5)),
        ),
        child: ListTile(
          leading: Icon(Icons.calculate, color: theme.colorScheme.primary),
          title: Text('Try the $title',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w900)),
          subtitle: const Text('Get instant results: free, no login needed.'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => goNamed(context, route),
        ),
      ),
    );
  }
}
