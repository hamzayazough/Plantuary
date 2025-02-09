import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    }

    return '.env.development';
  }

  static String get mapboxAccessToken {
    return dotenv.env['MAPBOX_ACCESS_TOKEN'] ??
        "MAPBOX_ACCESS_TOKEN not specified";
  }

  static String get apiKey {
    return dotenv.env['API_KEY'] ?? "API_KEY not specified";
  }

  static String get apiBaseUrl {
    return '${dotenv.env['SERVER_BASE_URL']}/api';
  }

  static String get serverBaseUrl {
    return '${dotenv.env['SERVER_BASE_URL']}';
  }
}
