import 'package:flutter/material.dart';

import '../../models/article_model.dart';
import '../../widgets/article_page_template.dart';
import '../../widgets/calculator_cta_banner.dart';

class TaxSaving80cPage extends StatelessWidget {
  const TaxSaving80cPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ArticlePageTemplate(
      article: articles[7],
      intro:
          'Section 80C can reduce taxable income, but the right product should match your time horizon and risk comfort.',
      ctas: const [
        CalculatorCtaBanner(title: 'FD Calculator', route: '/fd-calculator'),
        CalculatorCtaBanner(title: 'SIP Calculator', route: '/sip-calculator')
      ],
      blocks: const [
        ArticleBlock.table(headers: [
          'Instrument',
          'Lock-in',
          'Return',
          'Risk'
        ], rows: [
          ['PPF', '15 years', 'Government-declared', 'Low'],
          ['ELSS', '3 years', 'Market-linked', 'High'],
          ['NSC', '5 years', 'Fixed', 'Low'],
          ['Life Insurance', 'Policy term', 'Product-specific', 'Varies'],
          ['5-year FD', '5 years', 'Fixed', 'Low']
        ]),
        ArticleBlock.heading('How to Choose'),
        ArticleBlock.paragraph(
            'For long-term growth, ELSS may suit investors who understand equity risk. For certainty, PPF, NSC, and tax-saving FDs are simpler. Insurance should be bought for protection first, not only tax saving.'),
        ArticleBlock.tip(
            'ELSS platforms and insurance aggregators can be monetized through approved CueLinks links, with clear disclosure to readers.'),
      ],
    );
  }
}
