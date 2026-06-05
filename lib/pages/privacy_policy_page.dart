import 'package:flutter/material.dart';

import '../seo_service.dart';
import '../widgets/yieldwise_footer.dart';
import '../widgets/yieldwise_page_scaffold.dart';
import '../widgets/yieldwise_section_hero.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  void initState() {
    super.initState();
    setSeoMeta(
      title: 'Privacy Policy - YieldWise',
      description:
          "Read YieldWise's privacy policy covering data collection, cookies, and affiliate disclosures.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _PolicyPage(
      title: 'Privacy Policy',
      updated: 'Last updated: June 2025',
      icon: Icons.lock_outline,
      sections: [
        [
          '1. Introduction',
          'YieldWise ("we", "our", "us") operates yieldwise.online. This Privacy Policy explains how we collect, use, and protect your information when you visit our website.'
        ],
        [
          '2. Information We Collect',
          'We do not require account registration. We may collect:\n- Usage data via analytics tools (pages visited, time on site, device type)\n- Information you voluntarily submit via the Contact form (name, email, message)'
        ],
        [
          '3. Cookies and Tracking Technologies',
          'We use cookies and similar technologies for:\n- Website analytics (Google Analytics or similar)\n- Affiliate tracking via CueLinks (see Section 5)\nBy using this website, you consent to the use of cookies as described in this policy. You can disable cookies in your browser settings; however, some features may not work correctly.'
        ],
        [
          '4. How We Use Your Information',
          '- To improve website performance and user experience\n- To respond to contact form submissions\n- To display relevant affiliate content'
        ],
        [
          '5. Affiliate Disclosure',
          'YieldWise participates in affiliate marketing programs, including CueLinks. This means some links on our website may be affiliate links. If you click on an affiliate link and make a purchase, we may earn a commission at no additional cost to you. CueLinks may process affiliate tracking data for attribution, but it does not intentionally collect or store personally identifiable information from users of this website. Affiliate relationships do not influence the content, tools, or recommendations on this website. We only link to products and services we believe are useful to our readers.'
        ],
        [
          '6. Third-Party Services',
          'We may use third-party services including:\n- Google Analytics - for usage analytics\n- CueLinks - for affiliate link monetization\nThese third parties have their own privacy policies and data practices.'
        ],
        [
          '7. Data Security',
          'We implement reasonable measures to protect your information. However, no internet transmission is 100% secure. Use the website at your own risk.'
        ],
        [
          "8. Children's Privacy",
          'YieldWise is not directed at children under 13. We do not knowingly collect data from minors.'
        ],
        [
          '9. Changes to This Policy',
          'We may update this Privacy Policy periodically. Changes will be posted on this page with an updated "Last updated" date.'
        ],
        [
          '10. Contact',
          'For privacy-related queries, contact us at: manohargupta0806@gmail.com or via the Contact page at yieldwise.online/contact'
        ],
      ],
    );
  }
}

class _PolicyPage extends StatelessWidget {
  const _PolicyPage({
    required this.title,
    required this.updated,
    required this.icon,
    required this.sections,
  });

  final String title;
  final String updated;
  final IconData icon;
  final List<List<String>> sections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return YieldWisePageScaffold(
      title: title,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          YieldWiseSectionHero(title: title, subtitle: updated, icon: icon),
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
