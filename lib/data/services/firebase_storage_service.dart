import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Service for managing Firebase Storage operations
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Storage paths
  static const String feedbackMediaPath = 'feedback/attachments';
  static const String userProfilePath = 'users';
  static const String busPhotoPath = 'buses/photos';

  /// Upload a passenger profile image.
  /// Returns the Firebase Storage download URL.
  Future<String> uploadUserProfileImage({
    required File file,
    required String userId,
  }) async {
    try {
      debugPrint('📤 FirebaseStorageService: Starting profile image upload...');
      debugPrint('   User ID: $userId');
      debugPrint('   File path: ${file.path}');

      final fileName = _getFileName(file.path);
      final fileSize = file.lengthSync();

      const maxFileSize = 5 * 1024 * 1024; // 5MB
      if (fileSize > maxFileSize) {
        throw Exception(
            'Profile image exceeds 5MB limit. Current size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB');
      }

      if (!isImage(fileName)) {
        throw Exception('Please select a valid image file.');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storagePath =
          '$userProfilePath/$userId/profile/$timestamp-$fileName';
      final ref = _storage.ref(storagePath);

      final metadata = SettableMetadata(
        contentType: _getContentType(fileName),
        customMetadata: {
          'userId': userId,
          'uploadedAt': DateTime.now().toIso8601String(),
          'originalFileName': fileName,
          'type': 'profileImage',
        },
      );

      final taskSnapshot = await ref.putFile(file, metadata);
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      debugPrint('✅ FirebaseStorageService: Profile image upload completed');
      debugPrint('   Download URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      debugPrint('❌ FirebaseStorageService: Profile image upload failed: $e');
      throw Exception('Failed to upload profile image: $e');
    }
  }

  /// Upload feedback media (image or video)
  /// Returns the download URL of the uploaded file
  Future<String> uploadFeedbackMedia({
    required File file,
    required String userId,
    required String feedbackId,
  }) async {
    try {
      debugPrint('📤 FirebaseStorageService: Starting media upload...');
      debugPrint('   User ID: $userId');
      debugPrint('   Feedback ID: $feedbackId');
      debugPrint('   File path: ${file.path}');

      // Get file info
      final fileName = _getFileName(file.path);
      final fileSize = file.lengthSync();

      debugPrint('   File name: $fileName');
      debugPrint(
          '   File size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB');

      // Validate file size (10MB limit)
      const maxFileSize = 10 * 1024 * 1024; // 10MB
      if (fileSize > maxFileSize) {
        throw Exception(
            'File size exceeds 10MB limit. Current size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB');
      }

      // Create storage path
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storagePath =
          '$feedbackMediaPath/$userId/$feedbackId/$timestamp-$fileName';

      debugPrint('   Storage path: $storagePath');

      // Upload file
      final ref = _storage.ref(storagePath);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: _getContentType(fileName),
        customMetadata: {
          'userId': userId,
          'feedbackId': feedbackId,
          'uploadedAt': DateTime.now().toIso8601String(),
          'originalFileName': fileName,
        },
      );

      debugPrint('   Content type: ${metadata.contentType}');

      final uploadTask = ref.putFile(file, metadata);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((event) {
        final percent = (event.bytesTransferred / event.totalBytes * 100)
            .toStringAsFixed(0);
        debugPrint('   Upload progress: $percent%');
      });

      // Wait for upload to complete
      final taskSnapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      debugPrint('✅ FirebaseStorageService: Upload completed');
      debugPrint('   Download URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      debugPrint('❌ FirebaseStorageService: Upload failed: $e');
      throw Exception('Failed to upload media: $e');
    }
  }

  /// Upload multiple feedback media files
  /// Returns list of download URLs
  Future<List<String>> uploadFeedbackMediaMultiple({
    required List<File> files,
    required String userId,
    required String feedbackId,
  }) async {
    try {
      debugPrint('📤 FirebaseStorageService: Starting batch upload...');
      debugPrint('   Files count: ${files.length}');

      final uploadedUrls = <String>[];

      for (int i = 0; i < files.length; i++) {
        try {
          debugPrint('   Uploading file ${i + 1}/${files.length}...');
          final url = await uploadFeedbackMedia(
            file: files[i],
            userId: userId,
            feedbackId: feedbackId,
          );
          uploadedUrls.add(url);
        } catch (e) {
          debugPrint('   ⚠️ Failed to upload file ${i + 1}: $e');
          // Continue with next file instead of stopping
          continue;
        }
      }

      debugPrint('✅ FirebaseStorageService: Batch upload completed');
      debugPrint(
          '   Successfully uploaded: ${uploadedUrls.length}/${files.length}');

      return uploadedUrls;
    } catch (e) {
      debugPrint('❌ FirebaseStorageService: Batch upload failed: $e');
      throw Exception('Failed to upload media files: $e');
    }
  }

  /// Delete media from Firebase Storage
  Future<void> deleteMedia(String downloadUrl) async {
    try {
      debugPrint('🗑️ FirebaseStorageService: Deleting media...');
      debugPrint('   URL: $downloadUrl');

      // Extract path from URL
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();

      debugPrint('✅ FirebaseStorageService: Media deleted successfully');
    } catch (e) {
      debugPrint('❌ FirebaseStorageService: Delete failed: $e');
      throw Exception('Failed to delete media: $e');
    }
  }

  /// Get content type based on file extension
  String _getContentType(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;

    switch (ext) {
      // Images
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      // Videos
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'mkv':
        return 'video/x-matroska';
      // Audio
      case 'mp3':
        return 'audio/mpeg';
      case 'm4a':
        return 'audio/mp4';
      case 'wav':
        return 'audio/wav';
      default:
        return 'application/octet-stream';
    }
  }

  /// Check if file is image
  static bool isImage(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }

  /// Check if file is video
  static bool isVideo(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    return ['mp4', 'mov', 'avi', 'mkv'].contains(ext);
  }

  /// Get file type (image, video, audio, other)
  static String getFileType(String fileName) {
    if (isImage(fileName)) return 'image';
    if (isVideo(fileName)) return 'video';

    final ext = fileName.toLowerCase().split('.').last;
    if (['mp3', 'm4a', 'wav'].contains(ext)) return 'audio';

    return 'other';
  }

  /// Get MIME type
  static String getMimeType(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;

    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'mkv':
        return 'video/x-matroska';
      case 'mp3':
        return 'audio/mpeg';
      case 'm4a':
        return 'audio/mp4';
      case 'wav':
        return 'audio/wav';
      default:
        return 'application/octet-stream';
    }
  }

  static String _getFileName(String path) {
    return path.split(RegExp(r'[\\/]')).last;
  }
}
