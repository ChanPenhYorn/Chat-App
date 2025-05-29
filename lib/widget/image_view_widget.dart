import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String imagePath;

  const ImageViewerScreen({super.key, required this.imagePath});

  bool _isNetworkImage(String path) {
    final trimmed = path.trim();
    return trimmed.startsWith('http://') || trimmed.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Viewer")),
      backgroundColor: Colors.black,
      body: Center(
        child: _isNetworkImage(imagePath)
            ? Image.network(
                imagePath,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load network image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                },
              )
            : Image.file(
                File(imagePath),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load local image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
