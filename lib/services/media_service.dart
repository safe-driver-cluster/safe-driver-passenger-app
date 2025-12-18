import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Service for handling media uploads to Firebase Storage
class MediaService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Storage paths
  static const String _feedbackAttachmentsPath = 'feedback/attachments';
  static const String _maxFileSize = 10485760; // 10 MB

  /// Upload a single media file (image or video) with progress tracking
  Future<String> uploadFeedbackMedia({
    required File file,
    required String feedbackId,
    required String userId,
    required Function(double)? onProgress,
    MediaType mediaType = MediaType.image,
  }) async {
    try {
      debugPrint('📸 MediaService: Starting upload for file: ${file.path}');

      // Validate file size
      final fileSizeInBytes = await file.length();
      if (fileSizeInBytes > 10485760) {
        throw Exception('File size exceeds 10 MB limit');
      }

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName =
          '${mediaType.toString().split('.').last}_${feedbackId}_$timestamp';
      final storagePath = '$_feedbackAttachmentsPath/$userId/$feedbackId';
      final fileRef = _storage.ref(storagePath).child(fileName);

      // Upload with progress tracking
      final uploadTask = fileRef.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
        debugPrint(
            '📤 Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      await uploadTask;

      // Get download URL
      final downloadUrl = await fileRef.getDownloadURL();
      debugPrint(
          '✅ MediaService: File uploaded successfully. URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      debugPrint('❌ MediaService: Upload error: $e');
      throw Exception('Failed to upload media: $e');
    }
  }

  /// Upload multiple media files in batch
  Future<List<String>> uploadMultipleMedia({
    required List<File> files,
    required String feedbackId,
    required String userId,
    required Function(int, double)? onProgress,
  }) async {
    try {
      final uploadedUrls = <String>[];

      for (int i = 0; i < files.length; i++) {
        final url = await uploadFeedbackMedia(
          file: files[i],
          feedbackId: feedbackId,
          userId: userId,
          onProgress: (progress) {
            onProgress?.call(i, progress);
          },
          mediaType: _getMediaType(files[i]),
        );
        uploadedUrls.add(url);
      }

      return uploadedUrls;
    } catch (e) {
      debugPrint('❌ MediaService: Batch upload error: $e');
      throw Exception('Failed to upload multiple media files: $e');
    }
  }

  /// Delete a media file from Firebase Storage
  Future<void> deleteMedia(String url) async {
    try {
      debugPrint('🗑️ MediaService: Deleting media: $url');
      final ref = _storage.refFromURL(url);
      await ref.delete();
      debugPrint('✅ MediaService: Media deleted successfully');
    } catch (e) {
      debugPrint('❌ MediaService: Delete error: $e');
      throw Exception('Failed to delete media: $e');
    }
  }

  /// Delete multiple media files
  Future<void> deleteMultipleMedia(List<String> urls) async {
    try {
      for (final url in urls) {
        await deleteMedia(url);
      }
      debugPrint('✅ MediaService: Multiple media deleted successfully');
    } catch (e) {
      debugPrint('❌ MediaService: Batch delete error: $e');
      throw Exception('Failed to delete multiple media files: $e');
    }
  }

  /// Get download URL for a media file
  Future<String> getDownloadUrl(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  /// Get file metadata
  Future<FullMetadata> getFileMetadata(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  /// Determine media type from file extension
  MediaType _getMediaType(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      return MediaType.image;
    } else if (['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(extension)) {
      return MediaType.video;
    } else if (['pdf', 'doc', 'docx', 'txt'].contains(extension)) {
      return MediaType.document;
    }
    return MediaType.file;
  }

  /// Validate if file is supported
  bool isFileSupported(File file) {
    const supportedExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'mp4',
      'mov',
      'avi',
      'mkv',
      'webm',
      'pdf',
      'doc',
      'docx',
      'txt'
    ];
    final extension = file.path.split('.').last.toLowerCase();
    return supportedExtensions.contains(extension);
  }
}

enum MediaType {
  image,
  video,
  document,
  file,
}
