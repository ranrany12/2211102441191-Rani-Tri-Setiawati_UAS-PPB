import 'package:flutter/material.dart';
import 'package:news_app/services/global_methods.dart';
import 'package:news_app/services/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailsWebviewScreen extends StatefulWidget {
  const NewsDetailsWebviewScreen({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<NewsDetailsWebviewScreen> createState() =>
      _NewsDetailsWebviewScreenState();
}

class _NewsDetailsWebviewScreenState extends State<NewsDetailsWebviewScreen> {
  late final WebViewController webViewController;
  double _progress = 0.0;

  @override
  void initState() {
    webViewController = WebViewController()
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
      );
    super.initState();
  }

  Future<void> _showModalBottomSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 290,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.only(top: 16, left: 16),
          child: Column(
            children: [
              Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'More Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              Divider(
                thickness: 2.0,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.5),
              ),
              ListTile(
                onTap: () async {
                  try {
                    await Share.share(
                      widget.url,
                    );
                  } catch (err) {
                    GlobalMethods.showErrorDialog(
                        errorMessage: err.toString(), context: context);
                    debugPrint(err.toString());
                  } finally {
                    Navigator.of(context).pop();
                  }
                },
                leading: Icon(
                  Icons.share,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                title: Text(
                  'Share',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                horizontalTitleGap: 24,
              ),
              ListTile(
                onTap: () async {
                  try {
                    await launchUrl(
                      Uri.parse(widget.url),
                    );
                  } catch (err) {
                    GlobalMethods.showErrorDialog(
                        errorMessage: err.toString(), context: context);
                  } finally {
                    Navigator.of(context).pop();
                  }
                },
                leading: Icon(
                  Icons.link,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                title: Text(
                  'Open in Browser',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                horizontalTitleGap: 24,
              ),
              ListTile(
                onTap: () async {
                  try {
                    await webViewController.reload();
                  } catch (err) {
                    GlobalMethods.showErrorDialog(
                        errorMessage: err.toString(), context: context);
                  } finally {
                    Navigator.of(context).pop();
                  }
                },
                leading: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                title: Text(
                  'Refresh',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                horizontalTitleGap: 24,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (await webViewController.canGoBack()) {
          await webViewController.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.url,
            style: TextStyle(color: color),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _showModalBottomSheet();
              },
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: _progress,
              color: _progress == 1.0 ? Colors.transparent : Colors.blue,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            Expanded(
              child: WebViewWidget(
                controller: webViewController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
