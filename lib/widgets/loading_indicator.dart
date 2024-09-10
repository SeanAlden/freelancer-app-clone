import 'package:flutter/material.dart';

class LoaderTransparent extends StatelessWidget {
  final double height;
  final double width;

  const LoaderTransparent({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.withOpacity(0.5),
      child: const Center(
        child: SizedBox(
          height: 60.0,
          width: 60.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 5.0,
          ),
        ),
      ),
    );
  }
}
