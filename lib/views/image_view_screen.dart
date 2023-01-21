import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Image.network(
            url,
            height: 300,
          ),
          BackButton(),
        ],
      )),
    );
  }
}
