import 'package:flutter/material.dart';

import '../../models/article_model.dart';
import '../../widgets/article_page_template.dart';
import '../../widgets/calculator_cta_banner.dart';

class PpfGuidePage extends StatelessWidget {
  const PpfGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ArticlePageTemplate(
      article: articles[5],
      intro:
          'PPF remains a popular long-term savings option because it combines government backing, tax benefits, and disciplined lock-in.',
      ctas: const [
        CalculatorCtaBanner(title: 'PPF Calculator', route: '/ppf-calculator')
      ],
      blocks: const [
        ArticleBlock.table(headers: [
          'Rule',
          'PPF Detail'
        ], rows: [
          ['Tenure', '15 years'],
          ['Deposit limit', 'Up to INR 1.5 lakh per financial year'],
          ['Tax', 'Eligible under Section 80C; maturity generally tax-free'],
          ['Rate', 'Declared by government periodically']
        ]),
        ArticleBlock.heading('Who Should Use PPF?'),
        ArticleBlock.paragraph(
            'PPF suits conservative investors who want a long lock-in, predictable compounding, and tax efficiency. It can be one part of retirement or children’s education planning.'),
        ArticleBlock.tip(
            'Banks offering PPF account opening can be linked through approved CueLinks URLs where available.'),
      ],
    );
  }
}
