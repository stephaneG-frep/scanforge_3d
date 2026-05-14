import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> ensureCameraAndMediaAccess() async {
    final cameraOk = await _ensure(Permission.camera);
    if (!cameraOk) return false;

    if (Platform.isAndroid) {
      final photosOk = await _ensure(Permission.photos);
      if (photosOk) return true;

      // Fallback for some Android API/devices where storage permission is surfaced.
      return _ensure(Permission.storage);
    }

    return _ensure(Permission.photos);
  }

  Future<bool> _ensure(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted || status.isLimited) return true;

    final requested = await permission.request();
    return requested.isGranted || requested.isLimited;
  }
}
