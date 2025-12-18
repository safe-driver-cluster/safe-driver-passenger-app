import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../core/themes/app_theme.dart';

/// Widget for uploading and managing media files
class MediaUploadWidget extends StatefulWidget {
  final Function(List<File>) onFilesSelected;
  final Function(int)? onFileRemoved;
  final Function(double)? onProgressUpdate;
  final int maxFiles;
  final int maxFileSize; // in bytes
  final List<String> allowedExtensions;
  final bool allowVideo;
  final bool allowImage;
  final bool allowMultiple;

  const MediaUploadWidget({
    Key? key,
    required this.onFilesSelected,
    this.onFileRemoved,
    this.onProgressUpdate,
    this.maxFiles = 10,
    this.maxFileSize = 10485760, // 10 MB
    this.allowedExtensions = const [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'mp4',
      'mov',
      'avi',
    ],
    this.allowVideo = true,
    this.allowImage = true,
    this.allowMultiple = true,
  }) : super(key: key);

  @override
  State<MediaUploadWidget> createState() => _MediaUploadWidgetState();
}

class _MediaUploadWidgetState extends State<MediaUploadWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<File> _selectedFiles = [];
  final List<VideoPlayerController> _videoControllers = [];
  bool _isLoading = false;

  @override
  void dispose() {
    for (final controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload buttons
        _buildUploadButtons(),

        // Selected files grid
        if (_selectedFiles.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildFileGrid(),
        ],

        // File limit info
        if (_selectedFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              '${_selectedFiles.length}/${widget.maxFiles} files selected',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.gray,
                  ),
            ),
          ),
      ],
    );
  }

  /// Build upload action buttons
  Widget _buildUploadButtons() {
    return Row(
      children: [
        if (widget.allowImage)
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  _selectedFiles.length < widget.maxFiles ? _pickImage : null,
              icon: const Icon(Icons.image),
              label: const Text('Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.gray,
              ),
            ),
          ),
        if (widget.allowImage && widget.allowVideo) const SizedBox(width: 12),
        if (widget.allowVideo)
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  _selectedFiles.length < widget.maxFiles ? _pickVideo : null,
              icon: const Icon(Icons.videocam),
              label: const Text('Video'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.gray,
              ),
            ),
          ),
      ],
    );
  }

  /// Build grid of selected files
  Widget _buildFileGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _selectedFiles.length,
      itemBuilder: (context, index) {
        return _buildFilePreview(index);
      },
    );
  }

  /// Build single file preview
  Widget _buildFilePreview(int index) {
    final file = _selectedFiles[index];
    final fileName = file.path.split('/').last;
    final extension = fileName.split('.').last.toLowerCase();
    final isVideo = ['mp4', 'mov', 'avi', 'mkv'].contains(extension);
    final isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Preview
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.gray, width: 1),
          ),
          child: isImage
              ? Image.file(file, fit: BoxFit.cover)
              : isVideo
                  ? _buildVideoPreview(file)
                  : _buildDocumentPreview(fileName),
        ),

        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeFile(index),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),

        // File type badge
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              extension.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build video preview thumbnail
  Widget _buildVideoPreview(File file) {
    return FutureBuilder(
      future: _generateVideoThumbnail(file),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            return Image.file(snapshot.data as File, fit: BoxFit.cover);
          }
        }
        return Center(
          child: Icon(
            Icons.videocam,
            color: AppColors.gray,
            size: 32,
          ),
        );
      },
    );
  }

  /// Build document preview
  Widget _buildDocumentPreview(String fileName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            color: AppColors.gray,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            fileName.length > 15 ? '${fileName.substring(0, 12)}...' : fileName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// Pick image from gallery or camera
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        _addFile(File(image.path));
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  /// Pick video from gallery or camera
  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video != null) {
        _addFile(File(video.path));
      }
    } catch (e) {
      _showError('Failed to pick video: $e');
    }
  }

  /// Add file with validation
  void _addFile(File file) {
    try {
      // Check file size
      final fileSize = file.lengthSync();
      if (fileSize > widget.maxFileSize) {
        _showError(
            'File size exceeds limit (Max: ${widget.maxFileSize ~/ 1024 ~/ 1024}MB)');
        return;
      }

      // Check file extension
      final extension = file.path.split('.').last.toLowerCase();
      if (!widget.allowedExtensions.contains(extension)) {
        _showError('File type not supported');
        return;
      }

      // Check max files
      if (_selectedFiles.length >= widget.maxFiles) {
        _showError('Maximum files reached');
        return;
      }

      setState(() {
        _selectedFiles.add(file);
      });

      widget.onFilesSelected(_selectedFiles);
    } catch (e) {
      _showError('Error adding file: $e');
    }
  }

  /// Remove file from selection
  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });

    widget.onFileRemoved?.call(index);
    widget.onFilesSelected(_selectedFiles);
  }

  /// Generate video thumbnail
  Future<File?> _generateVideoThumbnail(File file) async {
    try {
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      _videoControllers.add(controller);

      // Note: Full thumbnail generation would require a package like video_thumbnail
      // For now, returning null to show default icon
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

/// Widget for displaying upload progress
class UploadProgressWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String fileName;
  final VoidCallback? onCancel;
  final bool isCompleted;
  final bool hasFailed;
  final String? errorMessage;

  const UploadProgressWidget({
    Key? key,
    required this.progress,
    required this.fileName,
    this.onCancel,
    this.isCompleted = false,
    this.hasFailed = false,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  if (!isCompleted && !hasFailed)
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.gray,
                          ),
                    )
                  else if (isCompleted)
                    Text(
                      'Upload complete',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.success,
                          ),
                    )
                  else
                    Text(
                      errorMessage ?? 'Upload failed',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                          ),
                    ),
                ],
              ),
            ),
            if (!isCompleted && !hasFailed && onCancel != null)
              IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
              )
            else if (isCompleted)
              Icon(Icons.check_circle, color: AppColors.success, size: 24)
            else
              Icon(Icons.error, color: AppColors.error, size: 24),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(
              hasFailed ? AppColors.error : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget for displaying attachment previews
class AttachmentPreviewWidget extends StatelessWidget {
  final String fileUrl;
  final String fileName;
  final String fileType;
  final VoidCallback? onDelete;
  final bool isLoading;

  const AttachmentPreviewWidget({
    Key? key,
    required this.fileUrl,
    required this.fileName,
    required this.fileType,
    this.onDelete,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = fileType.startsWith('image/');
    final isVideo = fileType.startsWith('video/');

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.gray, width: 1),
          ),
          child: isImage
              ? Image.network(
                  fileUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorWidget(),
                )
              : isVideo
                  ? _buildVideoThumbnail()
                  : _buildDocumentWidget(),
        ),
        if (!isLoading && onDelete != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoThumbnail() {
    return Center(
      child: Icon(
        Icons.play_circle_outline,
        color: AppColors.gray,
        size: 48,
      ),
    );
  }

  Widget _buildDocumentWidget() {
    return Center(
      child: Icon(
        Icons.description,
        color: AppColors.gray,
        size: 48,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Icon(
        Icons.error_outline,
        color: AppColors.error,
        size: 48,
      ),
    );
  }
}
