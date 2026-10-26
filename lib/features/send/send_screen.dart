import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../shared/widgets/svg_icon_widget.dart';
import '../../shared/widgets/glassmorphic_card.dart';
import '../../core/providers/app_providers.dart';

class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key});

  @override
  ConsumerState<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends ConsumerState<SendScreen>
    with TickerProviderStateMixin {
  List<FileItem> _selectedFiles = [];
  int _viewMode = 0; // 0=grid, 1=list
  String _filterType = 'all';
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              _buildFilterBar(),
              Expanded(
                child: _selectedFiles.isEmpty
                    ? _buildEmptyState()
                    : _buildFileGrid(),
              ),
            ],
          ),
          
          // Add Files FAB
          Positioned(
            bottom: 24,
            right: 20,
            child: _buildFAB(),
          ),
          
          // Send Bar (shows when files selected)
          if (_selectedFiles.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildSendBar(context),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.go('/home'),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: SvgIconWidget(
                    svgPath: AppIcons.back,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Files',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Choose what to share',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            
            // View toggle
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _ViewToggleButton(
                    icon: AppIcons.grid,
                    isActive: _viewMode == 0,
                    onTap: () => setState(() => _viewMode = 0),
                  ),
                  _ViewToggleButton(
                    icon: AppIcons.list,
                    isActive: _viewMode == 1,
                    onTap: () => setState(() => _viewMode = 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = [
      ('all', 'All', AppIcons.file),
      ('image', 'Photos', AppIcons.image),
      ('video', 'Videos', AppIcons.video),
      ('audio', 'Audio', AppIcons.audio),
      ('document', 'Docs', AppIcons.document),
      ('apk', 'Apps', AppIcons.apk),
      ('archive', 'Archives', AppIcons.archive),
    ];
    
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (key, label, icon) = filters[index];
          final isActive = _filterType == key;
          return GestureDetector(
            onTap: () => setState(() => _filterType = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgIconWidget(
                    svgPath: icon,
                    size: 14,
                    color: isActive ? AppColors.primary : AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isActive ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgIconWidget(
                svgPath: AppIcons.folder,
                size: 44,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
          ).animate().scale(curve: Curves.elasticOut, duration: 600.ms),
          
          const SizedBox(height: 20),
          const Text(
            'No files selected',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to pick files\nfrom your device',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          
          GestureDetector(
            onTap: _pickFiles,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+  Browse Files',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildFileGrid() {
    if (_viewMode == 1) return _buildFileList();
    
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: _selectedFiles.length,
      itemBuilder: (context, index) {
        return _FileGridItem(
          file: _selectedFiles[index],
          onRemove: () => setState(() => _selectedFiles.removeAt(index)),
        ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).scale(
          begin: const Offset(0.8, 0.8),
          curve: Curves.easeOutBack,
          delay: Duration(milliseconds: index * 50),
        );
      },
    );
  }

  Widget _buildFileList() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      itemCount: _selectedFiles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _FileListItem(
          file: _selectedFiles[index],
          onRemove: () => setState(() => _selectedFiles.removeAt(index)),
        ).animate().fadeIn(delay: Duration(milliseconds: index * 40)).slideX(begin: 0.3);
      },
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: _pickFiles,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ).animate().scale(
        begin: const Offset(0, 0),
        end: const Offset(1, 1),
        delay: 400.ms,
        curve: Curves.elasticOut,
      ),
    );
  }

  Widget _buildSendBar(BuildContext context) {
    final totalSize = _selectedFiles.fold<int>(
      0, (sum, f) => sum + f.size,
    );
    
    return Container(
      padding: EdgeInsets.fromLTRB(
        16, 12, 16, 12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: const Border(
          top: BorderSide(color: AppColors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_selectedFiles.length} file${_selectedFiles.length != 1 ? 's' : ''} selected',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatSize(totalSize),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Clear
          GestureDetector(
            onTap: () => setState(() => _selectedFiles.clear()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Send button
          GestureDetector(
            onTap: () => context.go('/home/connect'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgIconWidget(svgPath: AppIcons.send, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
        withData: false,
        withReadStream: false,
      );
      
      if (result != null) {
        final newFiles = result.files
            .where((f) => f.path != null)
            .map((f) => FileItem(
                  name: f.name,
                  path: f.path!,
                  size: f.size,
                  type: _getFileType(f.name),
                ))
            .toList();
        
        setState(() {
          _selectedFiles = [..._selectedFiles, ...newFiles];
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  String _getFileType(String name) {
    final ext = name.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'bmp', 'svg'].contains(ext)) return 'image';
    if (['mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'm4v', 'webm'].contains(ext)) return 'video';
    if (['mp3', 'wav', 'flac', 'aac', 'ogg', 'm4a', 'opus'].contains(ext)) return 'audio';
    if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'rtf'].contains(ext)) return 'document';
    if (['apk', 'aab', 'ipa', 'exe', 'msi'].contains(ext)) return 'app';
    if (['zip', 'rar', '7z', 'tar', 'gz', 'bz2'].contains(ext)) return 'archive';
    return 'other';
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
    }
    if (bytes >= 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    }
    return '$bytes B';
  }
}

// ─── File Item Model ─────────────────────────────────────────────────────────

class FileItem {
  final String name;
  final String path;
  final int size;
  final String type;

  const FileItem({
    required this.name,
    required this.path,
    required this.size,
    required this.type,
  });
}

// ─── File Grid Item ───────────────────────────────────────────────────────────

class _FileGridItem extends StatefulWidget {
  final FileItem file;
  final VoidCallback onRemove;

  const _FileGridItem({required this.file, required this.onRemove});

  @override
  State<_FileGridItem> createState() => _FileGridItemState();
}

class _FileGridItemState extends State<_FileGridItem> {
  bool _pressed = false;

  Color get _typeColor {
    switch (widget.file.type) {
      case 'image': return AppColors.fileImage;
      case 'video': return AppColors.fileVideo;
      case 'audio': return AppColors.fileAudio;
      case 'document': return AppColors.fileDocument;
      case 'app': return AppColors.fileApp;
      case 'archive': return AppColors.fileArchive;
      default: return AppColors.fileOther;
    }
  }

  String get _typeIcon {
    switch (widget.file.type) {
      case 'image': return AppIcons.image;
      case 'video': return AppIcons.video;
      case 'audio': return AppIcons.audio;
      case 'document': return AppIcons.document;
      case 'app': return AppIcons.apk;
      case 'archive': return AppIcons.archive;
      default: return AppIcons.file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _typeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: SvgIconWidget(
                          svgPath: _typeIcon,
                          size: 24,
                          color: _typeColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.file.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.file.name.split('.').last.toUpperCase(),
                            style: TextStyle(
                              color: _typeColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _formatSize(widget.file.size),
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Remove button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: widget.onRemove,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.bgBase,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgIconWidget(
                        svgPath: AppIcons.close,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024) return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '$bytes B';
  }
}

// ─── File List Item ───────────────────────────────────────────────────────────

class _FileListItem extends StatelessWidget {
  final FileItem file;
  final VoidCallback onRemove;

  const _FileListItem({required this.file, required this.onRemove});

  Color get _typeColor {
    switch (file.type) {
      case 'image': return AppColors.fileImage;
      case 'video': return AppColors.fileVideo;
      case 'audio': return AppColors.fileAudio;
      case 'document': return AppColors.fileDocument;
      case 'app': return AppColors.fileApp;
      case 'archive': return AppColors.fileArchive;
      default: return AppColors.fileOther;
    }
  }

  String get _typeIcon {
    switch (file.type) {
      case 'image': return AppIcons.image;
      case 'video': return AppIcons.video;
      case 'audio': return AppIcons.audio;
      case 'document': return AppIcons.document;
      case 'app': return AppIcons.apk;
      case 'archive': return AppIcons.archive;
      default: return AppIcons.file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _typeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SvgIconWidget(svgPath: _typeIcon, size: 22, color: _typeColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: _typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        file.name.split('.').last.toUpperCase(),
                        style: TextStyle(
                          color: _typeColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatSize(file.size),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: SvgIconWidget(
              svgPath: AppIcons.close,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024) return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '$bytes B';
  }
}

class _ViewToggleButton extends StatelessWidget {
  final String icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgIconWidget(
          svgPath: icon,
          size: 16,
          color: isActive ? AppColors.primary : AppColors.textMuted,
        ),
      ),
    );
  }
}
