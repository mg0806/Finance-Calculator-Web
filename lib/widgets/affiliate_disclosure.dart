import 'package:flutter/material.dart';

class AffiliateDisclosure extends StatelessWidget {
  const AffiliateDisclosure({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.colorScheme.tertiary, width: 5),
        ),
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.tertiaryContainer,
      ),
      child: Text(
        'Disclosure: This article may contain affiliate links. If you sign up or purchase via these links, YieldWise may earn a small commission at no extra cost to you. This helps us keep the calculators free.',
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}
