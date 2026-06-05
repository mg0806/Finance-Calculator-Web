// ignore_for_file: deprecated_member_use

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void setSeoMeta({required String title, required String description}) {
  html.document.title = title;
  final metas = html.document.querySelectorAll('meta[name="description"]');
  if (metas.isEmpty) {
    final meta = html.MetaElement()
      ..name = 'description'
      ..content = description;
    html.document.head?.append(meta);
    return;
  }
  for (final meta in metas) {
    (meta as html.MetaElement).content = description;
  }
}
