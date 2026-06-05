import 'package:flutter/material.dart';

import '../../models/article_model.dart';
import '../../widgets/article_page_template.dart';
import '../../widgets/calculator_cta_banner.dart';

class FdVsSipPage extends StatelessWidget {
  const FdVsSipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ArticlePageTemplate(
      article: articles[2],
      intro:
          'FDs and SIPs solve different problems. FDs offer certainty; SIPs offer growth potential with volatility.',
      ctas: const [
        CalculatorCtaBanner(title: 'FD Calculator', route: '/fd-calculator'),
        CalculatorCtaBanner(title: 'SIP Calculator', route: '/sip-calculator')
      ],
      blocks: const [
        ArticleBlock.table(headers: [
          'Factor',
          'FD',
          'SIP'
        ], rows: [
          ['Risk', 'Low for scheduled banks', 'Market-linked'],
          ['Return', 'Fixed', 'Variable'],
          [
            'Liquidity',
            'Premature withdrawal may cost penalty',
            'Usually redeemable, subject to fund rules'
          ],
          ['Tax', 'Interest taxed as income', 'Capital gains tax rules apply'],
          ['Min amount', 'Bank-specific', 'Often starts low']
        ]),
        ArticleBlock.heading('When FD Works Better'),
        ArticleBlock.paragraph(
            'Use FDs for emergency funds, near-term goals, and money you cannot afford to see fluctuate. Certainty matters more than return when the goal is close.'),
        ArticleBlock.heading('When SIP Works Better'),
        ArticleBlock.paragraph(
            'Use SIPs for long-term goals such as retirement, children’s education, or wealth creation where time can help absorb market cycles.'),
        ArticleBlock.tip(
            'FD booking platforms and fintech partners can be linked through CueLinks after approval. Keep affiliate choices separate from the calculator results.'),
      ],
    );
  }
}
