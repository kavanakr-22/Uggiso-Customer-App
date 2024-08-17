import 'package:flutter/material.dart';

import '../../base/common/utils/fonts.dart';

class ImageTitle extends StatelessWidget {
  final String image;
  final String title;
  final double? imageWidth;
  final double? imageHeight;
  final TextStyle? textStyle;
  final Color? imageColor;

  const ImageTitle({
    Key? key,
    required this.image,
    required this.title,
    this.imageWidth = 10,
    this.imageHeight = 10,
    this.textStyle = AppFonts.smallText,
     this.imageColor = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(image,width: imageWidth,height: imageHeight,color: imageColor,),
        SizedBox(width: 8,),
        Text(title,style: textStyle,)
      ],
    );
  }
}
