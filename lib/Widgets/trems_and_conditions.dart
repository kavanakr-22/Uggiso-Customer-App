import 'package:flutter/material.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  late WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse(Strings.terms_and_conditions_url),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        title: Text(Strings.terms_and_conditions,style: AppFonts.title,),
        leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: IconButton(
              iconSize: 18,
              icon: Image.asset('assets/ic_back_arrow.png'),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ),
      body: isLoading?Center(child: CircularProgressIndicator(color: AppColors.appPrimaryColor,)):WebViewWidget(
        controller: _controller,
      ),
    );
  }
}