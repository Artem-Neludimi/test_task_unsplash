import 'package:flutter/material.dart';

import '/ui/widgets/photo_widget.dart';

class PhotoPage extends StatelessWidget {
  final String photoUrl;

  const PhotoPage({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: PhotoWidget(photoUrl: photoUrl),
        ),
      ),
    );
  }
}
