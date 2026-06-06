import 'package:flutter/material.dart';

import '../seo_service.dart';
import '../widgets/live_finance_news.dart';
import '../widgets/yieldwise_footer.dart';
import '../widgets/yieldwise_page_scaffold.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    setSeoMeta(
      title: 'Finance News - YieldWise',
      description:
          'Latest India business, market, mutual fund, tax, GST, and real estate news for financial planning.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return YieldWisePageScaffold(
      title: 'Finance News',
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          LiveFinanceNews(
            pageSize: 12,
            showPageTitle: true,
            enableLoadMore: true,
          ),
          YieldWiseFooter(),
        ],
      ),
    );
  }
}
