import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageButton extends StatefulWidget {
  final ImageProvider image;
  final Function onPressed;

  const ImageButton({
    Key key,
    this.onPressed,
    this.image,
  }) : super(key: key);

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: ScreenUtil().setWidth(120),
        height: ScreenUtil().setHeight(120),
        alignment: Alignment.center,
        child: Image(
          image: widget.image,
          width: ScreenUtil().setWidth(90),
          height: ScreenUtil().setHeight(90),
        ),
      ),
    );
  }
}
