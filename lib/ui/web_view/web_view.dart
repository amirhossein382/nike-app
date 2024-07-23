import 'package:flutter/cupertino.dart';
import 'package:nike/ui/receipt/receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatelessWidget {
  final String url;
  const PaymentWebViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        final uri = Uri.parse(url);
        if (uri.pathSegments.contains("checkout") &&
            uri.host == "expertdevelopers.ir") {
          final int orderId = int.parse(uri.queryParameters['order_id']!);
          Navigator.of(context).pop();
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => PeymentReceiptScreen(
                    orderId: orderId,
                  )));
        }
      },
    );
  }
}
