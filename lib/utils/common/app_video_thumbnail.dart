import 'dart:io';
import 'dart:typed_data';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart' as thumbs;
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/foundation.dart';

/// Returns the thumbnail file path for a video (URL or local path)
Future<String?> getVideoThumbnailPath(String videoPathOrUrl,
    {bool isPickedFile = false}) async {
  try {
    final tempDir = await getTemporaryDirectory();

    // Make sure folder exists
    final thumbDir = Directory(p.join(tempDir.path, "video_thumbnails"));
    if (!thumbDir.existsSync()) thumbDir.createSync(recursive: true);

    // Unique file name
    final ext = isPickedFile ? "jpg" : "webp";
    final fileName = "thumb_${videoPathOrUrl.hashCode}.$ext";
    final outPath = p.join(thumbDir.path, fileName);

    if (isPickedFile) {
      // 🔹 For local picked video, use thumbnailData (bytes)
      XFile? uint8list = await thumbs.VideoThumbnail.thumbnailFile(video: ''

      );

      // if (uint8list != null) {
      //   final file = File(outPath);
      //   await file.writeAsBytes(uint8list);
      //   return file.path;
      // }
    } else {
      XFile? file = await thumbs.VideoThumbnail.thumbnailFile(video:videoPathOrUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      // 🔹 For remote URL, use thumbnailFile (direct save)
      // String? path = await thumbs.thumbnailFile(
      //   video: videoPathOrUrl,
      //   thumbnailPath: outPath,
      //   imageFormat: thumbs.ImageFormat.WEBP,
      //   maxHeight: 64,
      //   quality: 75,
      // );
      return file.path;
    }
  } catch (e) {
    if (kDebugMode) print("getVideoThumbnailPath error: $e");
  }
  return null;
}
