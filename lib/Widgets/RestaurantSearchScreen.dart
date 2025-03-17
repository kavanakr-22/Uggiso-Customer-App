import 'package:flutter/material.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';

class Restaurantsearchscreen extends StatefulWidget {
  const Restaurantsearchscreen({super.key});

  @override
  State<Restaurantsearchscreen> createState() => _RestaurantsearchscreenState();
}

class _RestaurantsearchscreenState extends State<Restaurantsearchscreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      _focusNode.requestFocus(); // Auto-focus the text field
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the focus node to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        centerTitle: false,
        title: RoundedContainer(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.05,
          color: AppColors.white,
          child: TextFormField(
            focusNode: _focusNode,
            maxLines: 1,
            style: AppFonts.title,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Search Restaurant',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          cornerRadius: 5,
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: IconButton(
            iconSize: 18,
            icon: Image.asset('assets/ic_back_arrow.png'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
