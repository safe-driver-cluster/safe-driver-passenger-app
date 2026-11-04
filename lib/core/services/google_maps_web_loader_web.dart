import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<bool> ensureGoogleMapsWebApiReady({
  Duration timeout = const Duration(seconds: 10),
}) async {
  if (_hasGoogleMapsApi()) return true;

  if (_existingGoogleMapsScript() == null) {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    if (apiKey.trim().isEmpty) return false;

    final script = html.ScriptElement()
      ..src = Uri.https(
        'maps.googleapis.com',
        '/maps/api/js',
        {
          'key': apiKey,
          'libraries': 'places',
        },
      ).toString()
      ..async = true
      ..defer = true;

    html.document.head?.append(script);
  }

  return _waitForGoogleMapsApi(timeout);
}

html.ScriptElement? _existingGoogleMapsScript() {
  final scripts = html.document.getElementsByTagName('script');
  for (final element in scripts) {
    if (element is! html.ScriptElement) continue;
    if (element.src.contains('maps.googleapis.com/maps/api/js')) {
      return element;
    }
  }
  return null;
}

Future<bool> _waitForGoogleMapsApi(Duration timeout) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (_hasGoogleMapsApi()) return true;
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  return _hasGoogleMapsApi();
}

bool _hasGoogleMapsApi() {
  final google = js_util.getProperty<Object?>(js_util.globalThis, 'google');
  if (google == null) return false;

  final maps = js_util.getProperty<Object?>(google, 'maps');
  if (maps == null) return false;

  return js_util.hasProperty(maps, 'MapTypeId');
}
