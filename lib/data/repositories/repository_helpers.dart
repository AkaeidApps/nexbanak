/// Backends differ on list envelope keys; normalise them in one place.
List<Map<String, dynamic>> extractList(
  Map<String, dynamic> body,
  String preferredKey,
) {
  for (final String key in <String>[preferredKey, 'items', 'data', 'results']) {
    final Object? value = body[key];
    if (value is List) {
      return value
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
  }
  return <Map<String, dynamic>>[];
}

Map<String, dynamic> extractMap(
  Map<String, dynamic> body,
  String preferredKey,
) {
  final Object? value = body[preferredKey] ?? body['data'] ?? body;
  return value is Map ? Map<String, dynamic>.from(value) : body;
}
