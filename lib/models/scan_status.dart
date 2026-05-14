enum ScanStatus {
  draft,
  capturing,
  processing,
  completed,
  failed,
}

extension ScanStatusX on ScanStatus {
  String get label {
    switch (this) {
      case ScanStatus.draft:
        return 'Brouillon';
      case ScanStatus.capturing:
        return 'Capture en cours';
      case ScanStatus.processing:
        return 'Traitement';
      case ScanStatus.completed:
        return 'Termine';
      case ScanStatus.failed:
        return 'Echec';
    }
  }
}
