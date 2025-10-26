import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<bool> requestBodySensorsPermission() async {
  var status = await Permission.sensors.status;

  if (status.isDenied) {
    // İzin talebi
    var result = await Permission.sensors.request();
    if (result.isGranted) {
      print("Body Sensors izni verildi.");
      return true; // İzin verildi
    } else {
      print("Body Sensors izni reddedildi.");
      return false; // İzin reddedildi
    }
  } else if (status.isPermanentlyDenied) {
    print("Body Sensors izni kalıcı olarak reddedildi. Ayarlara yönlendirin.");
    await openAppSettings();
    return false; // Kalıcı olarak reddedildi
  } else if (status.isGranted) {
    print("Body Sensors izni zaten verilmiş.");
    return true; // İzin zaten verilmiş
  }

  return false; // Diğer durumlar
}

Future<bool> requestCameraPermission() async {
  var status = await Permission.camera.status;

  if (status.isDenied) {
    var result = await Permission.camera.request();
    return result.isGranted; // İzin verildiyse true döndür
  } else if (status.isPermanentlyDenied) {
    print("Kamera izni kalıcı olarak reddedildi. Ayarlara yönlendirin.");
    await openAppSettings();
    return false; // Kalıcı olarak reddedildiyse false döndür
  }

  return status.isGranted; // İzin zaten verilmişse true döndür
}

Future<bool> requestPhotoPermission() async {
  if (Platform.isAndroid) {
    // Android 13 ve üzeri için
    if (await Permission.photos.isGranted) {
      return true; // Fotoğraf izni verilmiş
    } else if (await Permission.photos.isDenied) {
      var result = await Permission.photos.request();
      return result.isGranted; // Yeni izin talebi sonucu
    } else if (await Permission.photos.isPermanentlyDenied) {
      await openAppSettings(); // Kullanıcı ayarlara yönlendiriliyor
      return false;
    }

    // Android 12 ve altı için
    if (await Permission.storage.isGranted) {
      return true; // Depolama izni verilmiş
    } else if (await Permission.storage.isDenied) {
      var result = await Permission.storage.request();
      return result.isGranted; // Yeni izin talebi sonucu
    } else if (await Permission.storage.isPermanentlyDenied) {
      await openAppSettings();
      return false; // Kalıcı olarak reddedilmiş
    }
  }
  return false; // Diğer platformlarda izin verilmedi
}