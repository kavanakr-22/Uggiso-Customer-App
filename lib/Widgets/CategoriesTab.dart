import 'package:flutter/material.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        leading:Container(),
        backgroundColor: AppColors.white,
        title: const Text(
          Strings.categories,
          style: AppFonts.appBarText,
        ),
        centerTitle: true,
      ),
    );
  }
}
