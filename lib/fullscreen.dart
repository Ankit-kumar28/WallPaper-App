import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'dart:io';

class FullScreen extends StatelessWidget {
  final String imageurl;

  const FullScreen({Key? key, required this.imageurl}) : super(key: key);

  Future<void> setWallpaper(BuildContext context) async {
    try {
    
      int location = WallpaperManager.HOME_SCREEN;

      
      File file = await DefaultCacheManager().getSingleFile(imageurl);

      bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result
              ? 'Wallpaper set successfully! '
              : 'Failed to set wallpaper '),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error setting wallpaper: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context), 
            child: Center(
              child: Image.network(
                imageurl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () => setWallpaper(context),
              child: Container(
                height: 60,
                color: Colors.black54,
                child: const Center(
                  child: Text(
                    'Set Wallpaper',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
