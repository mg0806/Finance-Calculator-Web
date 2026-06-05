import 'package:flutter/material.dart';

import '../../models/article_model.dart';
import '../../widgets/article_page_template.dart';
import '../../widgets/calculator_cta_banner.dart';

class CagrExplainedPage extends StatelessWidget {
  const CagrExplainedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ArticlePageTemplate(
      article: articles[6],
      intro:
          'CAGR shows the smoothed annual growth rate of an investment over time. It is useful because real returns rarely move in a straight line.',
      ctas: const [
        CalculatorCtaBanner(title: 'CAGR Calculator', route: '/cagr-calculator')
      ],
      blocks: const [
        ArticleBlock.tip(
            'Formula: CAGR = (Final Value / Initial Value) ^ (1 / Years) - 1'),
        ArticleBlock.paragraph(
            'Example: INR 1,00,000 growing to INR 1,61,051 in 5 years is roughly 10% CAGR. The investment did not need to earn exactly 10% every year; CAGR is the annualized equivalent.'),
        ArticleBlock.heading('Why CAGR Matters'),
        ArticleBlock.bullets([
          ['It lets you compare investments held for different time periods.'],
          ['It includes compounding, unlike a simple average return.'],
          ['It hides volatility, so always check risk along with CAGR.']
        ]),
      ],
    );
  }
}
