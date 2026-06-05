import 'package:flutter/material.dart';

import '../navigation.dart';
import '../seo_service.dart';
import '../widgets/yieldwise_footer.dart';
import '../widgets/yieldwise_page_scaffold.dart';
import '../widgets/yieldwise_section_hero.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    setSeoMeta(
      title: 'About YieldWise',
      description:
          "Learn about YieldWise's mission to make financial calculators free and accessible for every Indian.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return YieldWisePageScaffold(
      title: 'About',
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const YieldWiseSectionHero(
            title: 'About YieldWise',
            subtitle:
                'A practical India money toolkit built for fast, clear planning.',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 18),
          const _Section(
            icon: Icons.flag_outlined,
            title: 'Our Mission',
            body:
                'YieldWise was built with one goal: make financial planning accessible to every Indian, not just those with chartered accountants on speed dial. Our free calculators help you understand SIPs, EMIs, FDs, and retirement planning in minutes: no jargon, no paywalls.',
          ),
          const _Section(
            icon: Icons.grid_view,
            title: 'What We Offer',
            body:
                '- 10+ free financial calculators\n- Instant results, no login required\n- Mobile-friendly design\n- Regularly updated for accuracy',
          ),
          const _Section(
            icon: Icons.verified_user_outlined,
            title: 'Disclaimer',
            body:
                'YieldWise is a financial calculator tool. All results are estimates for planning purposes only. We are not SEBI-registered investment advisors. Please consult a qualified financial advisor before making investment decisions.',
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.mail_outline),
              title: const Text('Contact Us'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => goNamed(context, '/contact'),
            ),
          ),
          const YieldWiseFooter(),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(color: theme.colorScheme.primary, width: 5)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(body, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
