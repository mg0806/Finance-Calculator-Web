import 'package:flutter/material.dart';

import '../seo_service.dart';
import '../widgets/yieldwise_footer.dart';
import '../widgets/yieldwise_page_scaffold.dart';
import '../widgets/yieldwise_section_hero.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  void initState() {
    super.initState();
    setSeoMeta(
        title: 'Terms & Conditions - YieldWise',
        description: 'Terms of use for YieldWise financial calculators.');
  }

  @override
  Widget build(BuildContext context) {
    const sections = [
      [
        '1. Acceptance of Terms',
        'By accessing yieldwise.online, you agree to these Terms & Conditions. If you do not agree, please discontinue use of the website.'
      ],
      [
        '2. Nature of Service',
        'YieldWise provides free online financial calculators for informational and educational purposes only. All calculations are estimates based on inputs provided by the user. Results should not be treated as financial advice.'
      ],
      [
        '3. No Financial Advice',
        'YieldWise is not a SEBI-registered investment advisor, financial planner, or tax consultant. Nothing on this website constitutes financial, investment, tax, or legal advice. Always consult a qualified professional before making financial decisions.'
      ],
      [
        '4. Accuracy of Information',
        'While we strive to ensure the accuracy of our calculators, we make no warranties, express or implied, about the completeness, accuracy, or suitability of results. Use calculations at your own discretion and risk.'
      ],
      [
        '5. Affiliate Links',
        'Some links on this website may be affiliate links. Clicking these links may result in YieldWise earning a commission. This does not affect the price you pay.'
      ],
      [
        '6. Intellectual Property',
        'All content on yieldwise.online, including calculator logic, design, text, and graphics, is the intellectual property of YieldWise. Unauthorized reproduction is prohibited.'
      ],
      [
        '7. Third-Party Links',
        'We may link to external websites for informational purposes. We are not responsible for the content, accuracy, or privacy practices of third-party sites.'
      ],
      [
        '8. Limitation of Liability',
        'YieldWise shall not be liable for any direct, indirect, incidental, or consequential damages arising from the use of this website or reliance on its calculations.'
      ],
      [
        '9. Governing Law',
        'These terms are governed by the laws of India. Any disputes shall be subject to the jurisdiction of courts in [your city], India.'
      ],
      [
        '10. Contact',
        'For questions regarding these Terms, contact us via the Contact page.'
      ],
    ];
    final theme = Theme.of(context);
    return YieldWisePageScaffold(
      title: 'Terms',
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const YieldWiseSectionHero(
            title: 'Terms & Conditions',
            subtitle: 'Last updated: June 2025',
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 18),
          for (final section in sections)
            Card(
              child: ExpansionTile(
                iconColor: theme.colorScheme.primary,
                title: Text(section.first,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w900)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(section.last, style: theme.textTheme.bodyMedium)
                ],
              ),
            ),
          const YieldWiseFooter(),
        ],
      ),
    );
  }
}
