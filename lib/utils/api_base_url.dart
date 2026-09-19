class ApiBaseUrl {
  static const String defaultOrigin = 'http://10.0.2.2:8000';
  static const String _forbiddenHostSuffix = 'ordereasy.win';

  static bool isForbiddenHost(String raw) {
    final host = Uri.tryParse(raw.trim())?.host.toLowerCase() ?? '';
    return host == _forbiddenHostSuffix ||
        host.endsWith('.$_forbiddenHostSuffix');
  }

  /// Scheme + host + port, no trailing slash and no `/api` suffix.
  static String normalizeOrigin(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('API base URL is required');
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed == null || parsed.host.isEmpty || !parsed.hasScheme) {
      throw FormatException('Invalid API base URL: $raw');
    }

    if (isForbiddenHost(trimmed)) {
      throw const FormatException(
        'Live *.ordereasy.win hosts are not allowed. Use a local dummy URL.',
      );
    }

    var path = parsed.path;
    if (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    if (path == '/api') {
      path = '';
    }

    final cleaned = Uri(
      scheme: parsed.scheme,
      userInfo: parsed.userInfo.isEmpty ? null : parsed.userInfo,
      host: parsed.host,
      port: parsed.hasPort ? parsed.port : null,
      path: path,
    );
    return cleaned.toString().replaceAll(RegExp(r'/$'), '');
  }

  static String toApiRoot(String origin) {
    final normalized = origin.endsWith('/')
        ? origin.substring(0, origin.length - 1)
        : origin;
    if (normalized.endsWith('/api')) {
      return normalized;
    }
    return '$normalized/api';
  }
}
