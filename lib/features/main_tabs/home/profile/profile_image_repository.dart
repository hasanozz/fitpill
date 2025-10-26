import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

class ProfileImageRepository {
  ProfileImageRepository({required FirebaseStorage storage})
      : _storage = storage;

  static const int _maxUploadBytes = 5 * 1024 * 1024;
  static const int _targetDimension = 1600;
  static const int _initialQuality = 75;

  final FirebaseStorage _storage;

  Future<String> uploadProfileImage({
    required String userId,
    required File file,
    String? previousUrl,
  }) async {
    final Uint8List imageBytes = await _prepareImageBytes(file);

    Reference ref;
    if (previousUrl != null && previousUrl.isNotEmpty) {
      try {
        ref = _storage.refFromURL(previousUrl);
      } on FirebaseException {
        ref = _createProfileReference(userId);
      }
    } else {
      ref = _createProfileReference(userId);
    }

    await ref.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return ref.getDownloadURL();
  }

  String? resolveStoragePath(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }

    try {
      return _storage.refFromURL(url).fullPath;
    } on FirebaseException {
      return null;
    }
  }

  Reference _createProfileReference(String userId) {
    return _storage
        .ref()
        .child('users')
        .child(userId)
        .child('profile')
        .child('profile.jpg');
  }

  Future<void> deleteProfileImage(String? url) async {
    if (url == null || url.isEmpty) {
      return;
    }

    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } on FirebaseException {
      // Ignore errors when the previous image is missing.
    }
  }

  Future<Uint8List> _prepareImageBytes(File file) async {
    final Uint8List originalBytes = await file.readAsBytes();
    final Uint8List? nativeCompressed = await _tryNativeCompression(file);
    final Uint8List candidate = nativeCompressed ?? originalBytes;

    if (candidate.lengthInBytes <= _maxUploadBytes) {
      return candidate;
    }

    return await compute<List<dynamic>, Uint8List>(
      _compressOnBackground,
      <dynamic>[candidate, _maxUploadBytes],
    );
  }

  Future<Uint8List?> _tryNativeCompression(File file) async {
    try {
      final List<int>? compressed =
          await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: _initialQuality,
        minWidth: _targetDimension,
        minHeight: _targetDimension,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) {
        return null;
      }

      final Uint8List bytes = Uint8List.fromList(compressed);
      if (bytes.lengthInBytes > _maxUploadBytes) {
        return await compute<List<dynamic>, Uint8List>(
          _compressOnBackground,
          <dynamic>[bytes, _maxUploadBytes],
        );
      }

      return bytes;
    } catch (_) {
      return null;
    }
  }

  static Uint8List _compressOnBackground(List<dynamic> args) {
    final Uint8List sourceBytes = args.first as Uint8List;
    final int maxBytes = args.last as int;
    final img.Image? decoded = img.decodeImage(sourceBytes);
    if (decoded == null) {
      return sourceBytes;
    }

    img.Image resized = decoded;
    if (decoded.width > _targetDimension || decoded.height > _targetDimension) {
      final double scale =
          min(_targetDimension / decoded.width, _targetDimension / decoded.height);
      final int targetWidth = max(1, (decoded.width * scale).round());
      final int targetHeight = max(1, (decoded.height * scale).round());
      resized = img.copyResize(
        decoded,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.average,
      );
    }

    int quality = _initialQuality;
    Uint8List encoded = Uint8List.fromList(
      img.encodeJpg(resized, quality: quality),
    );

    while (encoded.lengthInBytes > maxBytes && quality > 30) {
      quality -= 10;
      encoded = Uint8List.fromList(
        img.encodeJpg(resized, quality: quality),
      );
    }

    if (encoded.lengthInBytes > maxBytes) {
      final double resizeFactor =
          min(0.85, maxBytes / encoded.lengthInBytes.toDouble());
      final int nextWidth = max(1, (resized.width * resizeFactor).round());
      final int nextHeight = max(1, (resized.height * resizeFactor).round());
      final img.Image smaller = img.copyResize(
        resized,
        width: nextWidth,
        height: nextHeight,
        interpolation: img.Interpolation.average,
      );
      encoded = Uint8List.fromList(
        img.encodeJpg(smaller, quality: max(quality, 30)),
      );
    }

    return encoded;
  }
}
