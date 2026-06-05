import 'package:flutter/material.dart';

import '../../models/article_model.dart';
import '../../widgets/article_page_template.dart';
import '../../widgets/calculator_cta_banner.dart';

class SipVsLumpsumPage extends StatelessWidget {
  const SipVsLumpsumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ArticlePageTemplate(
      article: articles[0],
      intro:
          'SIP and lump sum investing can both build wealth. The better choice depends on cash flow, risk comfort, and market valuation.',
      ctas: const [
        CalculatorCtaBanner(title: 'SIP Calculator', route: '/sip-calculator')
      ],
      blocks: const [
        ArticleBlock.heading('What is SIP?'),
        ArticleBlock.paragraph(
            'A Systematic Investment Plan invests a fixed amount at regular intervals. It is useful for salaried investors because it turns investing into a monthly habit and reduces the pressure to time the market.'),
        ArticleBlock.heading('What is Lump Sum?'),
        ArticleBlock.paragraph(
            'Lump sum investing means deploying a large amount in one go. It can work well when you already have idle cash and your investment horizon is long enough to absorb volatility.'),
        ArticleBlock.heading('Key Differences'),
        ArticleBlock.table(headers: [
          'Factor',
          'SIP',
          'Lump Sum'
        ], rows: [
          ['Cash flow', 'Monthly', 'One-time'],
          ['Market timing', 'Lower pressure', 'Higher pressure'],
          ['Volatility', 'Averages entry price', 'Full exposure immediately'],
          ['Best for', 'Regular income', 'Existing corpus']
        ]),
        ArticleBlock.tip(
            'Want to start a SIP? Compare top platforms through your approved CueLinks affiliate links once they are available.'),
        ArticleBlock.heading('Which Should You Choose?'),
        ArticleBlock.bullets([
          [
            'Choose SIP if income arrives monthly, you dislike timing markets, or you are building discipline.'
          ],
          [
            'Choose lump sum if money is already available, goals are long-term, and you can tolerate short-term drops.'
          ],
          [
            'Many investors use a hybrid approach: park cash safely and deploy it through a short systematic transfer plan.'
          ]
        ]),
        ArticleBlock.heading('Verdict'),
        ArticleBlock.paragraph(
            'For most Indian retail investors, SIP is the calmer default. Lump sum can outperform when markets rise soon after investment, but the emotional cost is higher. Use numbers, not guesswork, and keep your asset allocation suitable for your goal.'),
      ],
    );
  }
}
