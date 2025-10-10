import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

import '../app_print.dart';

// Your existing AppLogs class


// Image Cache Manager
class AppImageCacheManager {
  static final AppImageCacheManager _instance = AppImageCacheManager._internal();
  static AppImageCacheManager get instance => _instance;

  late final DefaultCacheManager _cacheManager;
  final Map<String, ui.Image> _memoryCache = {};
  final Map<String, Uint8List> _assetCache = {};
  final Map<String, String> _svgCache = {};

  AppImageCacheManager._internal() {
    _cacheManager = DefaultCacheManager();
    AppLogs.log('Image Cache Manager initialized', tag: 'IMAGE_CACHE', color: Colors.green);
  }

  // Get cache manager
  DefaultCacheManager get cacheManager => _cacheManager;

  // Memory cache methods
  void cacheImage(String key, ui.Image image) {
    _memoryCache[key] = image;
    AppLogs.log('Image cached in memory: $key', tag: 'MEMORY_CACHE', color: Colors.cyan);
  }

  ui.Image? getCachedImage(String key) {
    return _memoryCache[key];
  }

  // Asset cache methods
  void cacheAsset(String key, Uint8List bytes) {
    _assetCache[key] = bytes;
    AppLogs.log('Asset cached: $key', tag: 'ASSET_CACHE', color: Colors.cyan);
  }

  Uint8List? getCachedAsset(String key) {
    return _assetCache[key];
  }

  // SVG cache methods
  void cacheSvg(String key, String svgString) {
    _svgCache[key] = svgString;
    AppLogs.log('SVG cached: $key', tag: 'SVG_CACHE', color: Colors.cyan);
  }

  String? getCachedSvg(String key) {
    return _svgCache[key];
  }

  // Clear specific cache
  void clearMemoryCache() {
    _memoryCache.clear();
    AppLogs.log('Memory cache cleared', tag: 'CACHE_CLEAR', color: Colors.yellow);
  }

  void clearAssetCache() {
    _assetCache.clear();
    AppLogs.log('Asset cache cleared', tag: 'CACHE_CLEAR', color: Colors.yellow);
  }

  void clearSvgCache() {
    _svgCache.clear();
    AppLogs.log('SVG cache cleared', tag: 'CACHE_CLEAR', color: Colors.yellow);
  }

  // Clear all caches
  void clearAllCache() {
    clearMemoryCache();
    clearAssetCache();
    clearSvgCache();
    _cacheManager.emptyCache();
    AppLogs.log('All caches cleared', tag: 'CACHE_CLEAR', color: Colors.red);
  }

  // Get cache info
  Map<String, int> getCacheInfo() {
    return {
      'memory_cache': _memoryCache.length,
      'asset_cache': _assetCache.length,
      'svg_cache': _svgCache.length,
    };
  }
}

// Main AppImage Service
class AppImage {
  static final AppImageCacheManager _cacheManager = AppImageCacheManager.instance;

  // Asset Image with caching
  static Widget asset(
      String assetPath, {
        double? width,
        double? height,
        BoxFit fit = BoxFit.cover,
        Color? color,
        BlendMode? colorBlendMode,
        Alignment alignment = Alignment.center,
        String? semanticLabel,
        Widget? errorWidget,
        Widget? loadingWidget,
        bool enableCaching = true,
      }) {
    if (!enableCaching) {
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        semanticLabel: semanticLabel,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget
            : null,
      );
    }

    return FutureBuilder<Uint8List>(
      future: _loadAssetWithCache(assetPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              BlurGrayPlaceholder();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          AppLogs.log('Error loading asset: $assetPath', tag: 'ASSET_ERROR', color: Colors.red);
          return errorWidget ??
              SizedBox(
                width: width,
                height: height,
                child: const Icon(Icons.error),
              );
        }

        return Image.memory(
          snapshot.data!,
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
          alignment: alignment,
          semanticLabel: semanticLabel,
        );
      },
    );
  }

  // Network Image with advanced caching
  static Widget network(
      String imageUrl, {
        double width = 100,
        double height = 100,
        BoxFit fit = BoxFit.cover,
        Alignment alignment = Alignment.center,
        Widget? placeholder,
        Widget? errorWidget,
        Map<String, String>? httpHeaders,
        Duration cacheDuration = const Duration(days: 7),
        String? cacheKey,
        bool enableCaching = true,
      }) {
    if (!enableCaching) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget
            : null,
        loadingBuilder: placeholder != null
            ? (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder;
        }
            : null,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) =>
      placeholder ?? BlurGrayPlaceholder(width: width, height: height),
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget
          : (context, url, error) {
        AppLogs.log('Network image error: $url - $error',
            tag: 'NETWORK_ERROR', color: Colors.red);
        return AppImage.network("https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg",errorWidget: SizedBox(
            width: width,
            height: height,
            child: const Icon(Icons.error),
          ));
        // return SizedBox(
        //   width: width,
        //   height: height,
        //   child: const Icon(Icons.error),
        // );
      },
      httpHeaders: httpHeaders,
      cacheManager: _cacheManager.cacheManager,
      cacheKey: cacheKey,
      maxWidthDiskCache: 1000,
      maxHeightDiskCache: 1000,
      // memCacheWidth: width.toInt(),
      // memCacheHeight: height.toInt(),
    );
  }

  // SVG Image with caching
  static Widget svg(
      String assetPath, {
        double? width,
        double? height,
        BoxFit fit = BoxFit.contain,
        Color? color,
        Alignment alignment = Alignment.center,
        String? semanticLabel,
        Widget? errorWidget,
        Widget? loadingWidget,
        bool enableCaching = true,
      }) {
    if (!enableCaching) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticsLabel: semanticLabel,
        placeholderBuilder: loadingWidget != null
            ? (context) => loadingWidget
            : null,
      );
    }

    return FutureBuilder<String>(
      future: _loadSvgWithCache(assetPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              BlurGrayPlaceholder(width: width, height: height);
        }

        if (snapshot.hasError || !snapshot.hasData) {
          AppLogs.log('Error loading SVG: $assetPath', tag: 'SVG_ERROR', color: Colors.red);
          return errorWidget ??
              SizedBox(
                width: width,
                height: height,
                child: const Icon(Icons.error),
              );
        }

        return SvgPicture.string(
          snapshot.data!,
          width: width,
          height: height,
          fit: fit,
          color: color,
          alignment: alignment,
          semanticsLabel: semanticLabel,
        );
      },
    );
  }

  // Network SVG with caching
  static Widget svgNetwork(
      String svgUrl, {
        double? width,
        double? height,
        BoxFit fit = BoxFit.contain,
        Color? color,
        Alignment alignment = Alignment.center,
        Widget? placeholder,
        Widget? errorWidget,
        Map<String, String>? httpHeaders,
        bool enableCaching = true,
      }) {
    return FutureBuilder<String>(
      future: _loadNetworkSvgWithCache(svgUrl, httpHeaders),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ??
              BlurGrayPlaceholder(width: width, height: height);
        }

        if (snapshot.hasError || !snapshot.hasData) {
          AppLogs.log('Error loading network SVG: $svgUrl', tag: 'SVG_NETWORK_ERROR', color: Colors.red);
          return errorWidget ??
              SizedBox(
                width: width,
                height: height,
                child: const Icon(Icons.error),
              );
        }

        return SvgPicture.string(
          snapshot.data!,
          width: width,
          height: height,
          fit: fit,
          color: color,
          alignment: alignment,
        );
      },
    );
  }

  // Circular Avatar with network image
  static Widget circularAvatar(
      String imageUrl, {
        double radius = 20,
        Widget? placeholder,
        Widget? errorWidget,
        Color backgroundColor = Colors.grey,
      }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: ClipOval(
        child: network(enableCaching: true,
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: placeholder,
          errorWidget: errorWidget,
        ),
      ),
    );
  }

  // Preload images for better performance
  static Future<void> preloadImages(List<String> imagePaths, BuildContext context) async {
    AppLogs.log('Preloading ${imagePaths.length} images', tag: 'PRELOAD', color: Colors.blue);

    for (String imagePath in imagePaths) {
      try {
        if (imagePath.startsWith('http')) {
          // Network image
          await _cacheManager.cacheManager.downloadFile(imagePath);
        } else if (imagePath.endsWith('.svg')) {
          // SVG asset
          await _loadSvgWithCache(imagePath);
        } else {
          // Asset image
          await _loadAssetWithCache(imagePath);
        }
        AppLogs.log('Preloaded: $imagePath', tag: 'PRELOAD', color: Colors.green);
      } catch (e) {
        AppLogs.log('Failed to preload: $imagePath - $e', tag: 'PRELOAD_ERROR', color: Colors.red);
      }
    }
  }

  // Cache management methods
  static void clearCache() {
    _cacheManager.clearAllCache();
  }

  static void clearMemoryCache() {
    _cacheManager.clearMemoryCache();
  }

  static Map<String, int> getCacheInfo() {
    return _cacheManager.getCacheInfo();
  }

  // Private helper methods
  static Future<Uint8List> _loadAssetWithCache(String assetPath) async {
    // Check cache first
    final cachedAsset = _cacheManager.getCachedAsset(assetPath);
    if (cachedAsset != null) {
      AppLogs.log('Asset loaded from cache: $assetPath', tag: 'ASSET_CACHE_HIT', color: Colors.green);
      return cachedAsset;
    }

    // Load from asset bundle
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Cache the asset
      _cacheManager.cacheAsset(assetPath, bytes);

      AppLogs.log('Asset loaded and cached: $assetPath', tag: 'ASSET_LOADED', color: Colors.blue);
      return bytes;
    } catch (e) {
      AppLogs.log('Failed to load asset: $assetPath - $e', tag: 'ASSET_ERROR', color: Colors.red);
      throw Exception('Failed to load asset: $assetPath');
    }
  }

  static Future<String> _loadSvgWithCache(String assetPath) async {
    // Check cache first
    final cachedSvg = _cacheManager.getCachedSvg(assetPath);
    if (cachedSvg != null) {
      AppLogs.log('SVG loaded from cache: $assetPath', tag: 'SVG_CACHE_HIT', color: Colors.green);
      return cachedSvg;
    }

    // Load from asset bundle
    try {
      final String svgString = await rootBundle.loadString(assetPath);

      // Cache the SVG
      _cacheManager.cacheSvg(assetPath, svgString);

      AppLogs.log('SVG loaded and cached: $assetPath', tag: 'SVG_LOADED', color: Colors.blue);
      return svgString;
    } catch (e) {
      AppLogs.log('Failed to load SVG: $assetPath - $e', tag: 'SVG_ERROR', color: Colors.red);
      throw Exception('Failed to load SVG: $assetPath');
    }
  }

  static Future<String> _loadNetworkSvgWithCache(
      String svgUrl,
      Map<String, String>? httpHeaders
      ) async {
    // Check cache first
    final cachedSvg = _cacheManager.getCachedSvg(svgUrl);
    if (cachedSvg != null) {
      AppLogs.log('Network SVG loaded from cache: $svgUrl', tag: 'SVG_NETWORK_CACHE_HIT', color: Colors.green);
      return cachedSvg;
    }

    // Download and cache
    try {
      final file = await _cacheManager.cacheManager.getSingleFile(svgUrl, headers: httpHeaders);
      final String svgString = await file.readAsString();

      // Cache the SVG
      _cacheManager.cacheSvg(svgUrl, svgString);

      AppLogs.log('Network SVG loaded and cached: $svgUrl', tag: 'SVG_NETWORK_LOADED', color: Colors.blue);
      return svgString;
    } catch (e) {
      AppLogs.log('Failed to load network SVG: $svgUrl - $e', tag: 'SVG_NETWORK_ERROR', color: Colors.red);
      throw Exception('Failed to load network SVG: $svgUrl');
    }
  }
}

class BlurGrayPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const BlurGrayPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}


// Usage Examples
// class AppImageExamples extends StatelessWidget {
//   const AppImageExamples({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('AppImage Examples')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Asset Image
//             const Text('Asset Image:', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             AppImage.asset(
//               'assets/images/sample.png',
//               width: 150,
//               height: 150,
//               fit: BoxFit.cover,
//             ),
//
//             const SizedBox(height: 20),
//
//             // Network Image
//             const Text('Network Image:', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             AppImage.network(
//               'https://picsum.photos/200/200',
//               width: 150,
//               height: 150,
//               fit: BoxFit.cover,
//               placeholder: const Center(child: CircularProgressIndicator()),
//               errorWidget: const Icon(Icons.error, size: 50),
//             ),
//
//             const SizedBox(height: 20),
//
//             // SVG Image
//             const Text('SVG Image:', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             AppImage.svg(
//               'assets/icons/sample.svg',
//               width: 150,
//               height: 150,
//               color: Colors.blue,
//             ),
//
//             const SizedBox(height: 20),
//
//             // Circular Avatar
//             const Text('Circular Avatar:', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             AppImage.circularAvatar(
//               'https://picsum.photos/100/100',
//               radius: 50,
//             ),
//
//             const SizedBox(height: 20),
//
//             // Cache Info
//             FutureBuilder<Map<String, int>>(
//               future: Future.value(AppImage.getCacheInfo()),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Cache Info:', style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text('Memory Cache: ${snapshot.data!['memory_cache']} items'),
//                       Text('Asset Cache: ${snapshot.data!['asset_cache']} items'),
//                       Text('SVG Cache: ${snapshot.data!['svg_cache']} items'),
//                     ],
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//
//             const SizedBox(height: 20),
//
//             // Clear Cache Button
//             ElevatedButton(
//               onPressed: () {
//                 AppImage.clearCache();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Cache cleared!')),
//                 );
//               },
//               child: const Text('Clear All Cache'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }