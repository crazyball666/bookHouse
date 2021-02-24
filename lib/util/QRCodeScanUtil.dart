import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class QRCodeScanUtil {
  static Future<bool> canReadStorage() async {
    if (Platform.isIOS) return true;
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
      return status == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  static Future<bool> canOpenCamera() async {
    if (Platform.isIOS) return true;
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
      return status == PermissionStatus.granted;
    } else {
      return true;
    }
  }



}
