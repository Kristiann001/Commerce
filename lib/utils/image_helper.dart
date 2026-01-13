
import 'package:flutter/foundation.dart';

class ImageHelper {
  /// Wraps the URL in a CORS proxy if running on Web and the URL is external.
  static String getSafeImageUrl(String url) {
    if (url.isEmpty) return '';
    
    // If it's already a local asset or empty, return as is
    if (!url.startsWith('http')) return url;

    // If running on Web, use a CORS proxy
    // We use wsrv.nl (images.weserv.nl) as it's a robust image proxy/cache
    if (kIsWeb) {
      // Encode the URL to ensure special characters are handled
      // wsrv.nl expects the URL as a query parameter '?url='
      return 'https://wsrv.nl/?url=${Uri.encodeComponent(url)}';
    }

    return url;
  }
}
