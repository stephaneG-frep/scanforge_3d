import 'scan_status.dart';

class ScanProject {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<String> imagePaths;
  final ScanStatus status;
  final String? modelPath;
  final Map<String, String> exportPaths;

  const ScanProject({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.imagePaths,
    required this.status,
    required this.modelPath,
    required this.exportPaths,
  });

  ScanProject copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    List<String>? imagePaths,
    ScanStatus? status,
    String? modelPath,
    Map<String, String>? exportPaths,
  }) {
    return ScanProject(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      imagePaths: imagePaths ?? this.imagePaths,
      status: status ?? this.status,
      modelPath: modelPath ?? this.modelPath,
      exportPaths: exportPaths ?? this.exportPaths,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'imagePaths': imagePaths,
      'status': status.name,
      'modelPath': modelPath,
      'exportPaths': exportPaths,
    };
  }

  factory ScanProject.fromJson(Map<String, dynamic> json) {
    return ScanProject(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      imagePaths: (json['imagePaths'] as List<dynamic>).cast<String>(),
      status: ScanStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ScanStatus.draft,
      ),
      modelPath: json['modelPath'] as String?,
      exportPaths: Map<String, String>.from(json['exportPaths'] as Map),
    );
  }
}
