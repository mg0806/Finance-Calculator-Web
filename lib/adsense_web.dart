// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

var _adViewCounter = 0;

Widget buildAdSenseSlot({
  required String publisherId,
  required String slotId,
  required double height,
}) {
  final viewType = 'adsense-slot-$slotId-${_adViewCounter++}';
  final heightPx = '${height.round()}px';

  ui_web.platformViewRegistry.registerViewFactory(viewType, (viewId) {
    final container = html.DivElement()
      ..style.width = '100%'
      ..style.height = heightPx
      ..style.maxHeight = heightPx
      ..style.overflow = 'hidden';

    final ad = html.Element.tag('ins') as html.HtmlElement
      ..classes.add('adsbygoogle')
      ..style.display = 'block'
      ..style.width = '100%'
      ..style.height = heightPx
      ..style.maxHeight = heightPx
      ..setAttribute('data-ad-client', publisherId)
      ..setAttribute('data-ad-slot', slotId)
      ..setAttribute('data-ad-format', 'auto')
      ..setAttribute('data-full-width-responsive', 'true');

    container.append(ad);

    container.append(
      html.ScriptElement()
        ..text = '''
          try {
            (adsbygoogle = window.adsbygoogle || []).push({});
          } catch (error) {}
        ''',
    );

    return container;
  });

  return SizedBox(height: height, child: HtmlElementView(viewType: viewType));
}
