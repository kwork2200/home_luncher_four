class AllVideoItem {
  final String path;
  final String name;
  final int fileSizeBytes;
  final DateTime createdAt;
  final int durationMs;
  final String? thumbnailPath;

  AllVideoItem({
    required this.path,
    required this.name,
    required this.fileSizeBytes,
    required this.createdAt,
    this.durationMs = 0,
    this.thumbnailPath,
  });

  String get title => name;

  String get durationText {
    final d = Duration(milliseconds: durationMs);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get sizeText {
    final kb = fileSizeBytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(2)} KB';
    final mb = kb / 1024;
    if (mb < 1024) return '${mb.toStringAsFixed(2)} MB';
    final gb = mb / 1024;
    return '${gb.toStringAsFixed(2)} GB';
  }

  String get sourceTag {
    final lowerPath = path.toLowerCase();
    if (lowerPath.contains('whatsapp')) return 'WhatsApp Video';
    if (lowerPath.contains('download')) return 'Download';
    if (lowerPath.contains('camera') || lowerPath.contains('dcim')) return 'Camera';
    return 'Video';
  }

  factory AllVideoItem.fromJson(Map<String, dynamic> json) {
    return AllVideoItem(
      path: json['path'] as String,
      name: json['name'] as String,
      fileSizeBytes: json['size'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['dateAdded'] as int),
      durationMs: json['duration'] as int? ?? 0,
      thumbnailPath: json['thumbnailPath'] as String?,
    );
  }
}
