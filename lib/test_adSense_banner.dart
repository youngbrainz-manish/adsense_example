import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

@JS('adsbygoogle')
external JSObject get _adsByGoogle;

class TestAdSenseBanner extends StatefulWidget {
  const TestAdSenseBanner({super.key});

  @override
  State<TestAdSenseBanner> createState() => _TestAdSenseBannerState();
}

class _TestAdSenseBannerState extends State<TestAdSenseBanner> {
  static const String _viewType = 'adsense-test-banner-modern';

  @override
  void initState() {
    super.initState();

    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      // INS element (must be HTMLElement)
      final ins = web.document.createElement('ins') as web.HTMLElement
        ..className = 'adsbygoogle'
        ..setAttribute('style', 'display:block')
        ..setAttribute('data-ad-client', 'ca-pub-3940256099942544')
        ..setAttribute('data-ad-slot', '6300978111')
        ..setAttribute('data-ad-format', 'auto')
        ..setAttribute('data-full-width-responsive', 'true');

      // Container DIV (must be HTMLElement)
      final container = web.document.createElement('div') as web.HTMLElement
        ..style.width = '100%'
        ..style.height = '250px';

      container.append(ins);

      // Call AdSense safely
      Future.microtask(() {
        (_adsByGoogle).callMethod('push'.toJS, <JSAny>[].toJS);
      });

      return container;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 250,
      width: double.infinity,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
