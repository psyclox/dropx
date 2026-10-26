import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../shared/widgets/svg_icon_widget.dart';
import '../../core/providers/app_providers.dart';
import '../../core/models/transfer_model.dart';
import '../../core/services/transfer_service.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transfers = ref.watch(activeTransfersProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, transfers),
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransferList(transfers, null),
                  _buildTransferList(transfers, TransferDirection.sending),
                  _buildTransferList(transfers, TransferDirection.receiving),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<TransferModel> transfers) {
    return Padding(
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
                child: SvgIconWidget(svgPath: AppIcons.back, size: 18, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transfer History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _confirmClearAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            SvgIconWidget(svgPath: AppIcons.search, size: 18, color: AppColors.textMuted),
            Expanded(
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search transfers...',
                  hintStyle: TextStyle(color: AppColors.textDisabled),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () => setState(() => _searchQuery = ''),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SvgIconWidget(svgPath: AppIcons.close, size: 16, color: AppColors.textMuted),
                ),
              ),
          ],
        ),
      ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.2),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textMuted,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Sent'),
            Tab(text: 'Received'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferList(List<TransferModel> allTransfers, TransferDirection? direction) {
    var filtered = direction == null
        ? allTransfers
        : allTransfers.where((t) => t.direction == direction).toList();
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
          t.fileName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.senderName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    if (filtered.isEmpty) {
      return _buildEmptyHistory();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _HistoryCard(
          transfer: filtered[index],
          onTap: () => context.go('/home/transfer/${filtered[index].id}'),
          onDelete: () {
            ref.read(activeTransfersProvider.notifier).remove(filtered[index].id);
          },
        ).animate().fadeIn(delay: Duration(milliseconds: index * 40)).slideY(begin: 0.2);
      },
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: SvgIconWidget(svgPath: AppIcons.history, size: 34, color: AppColors.textMuted),
            ),
          ).animate().scale(curve: Curves.elasticOut),
          const SizedBox(height: 16),
          const Text(
            'No transfers here',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your file transfers will appear here',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgModal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All History?', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'This will remove all transfer records. Files won\'t be deleted.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(transferHistoryProvider.notifier).clearAll();
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// ─── History Card ─────────────────────────────────────────────────────────────

class _HistoryCard extends StatefulWidget {
  final TransferModel transfer;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HistoryCard({
    required this.transfer,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  bool _pressed = false;

  Color get _statusColor {
    switch (widget.transfer.status) {
      case TransferStatus.completed: return AppColors.success;
      case TransferStatus.failed: return AppColors.error;
      case TransferStatus.inProgress: return AppColors.primary;
      case TransferStatus.cancelled: return AppColors.warning;
      case TransferStatus.pending: return AppColors.info;
      case TransferStatus.paused: return AppColors.warning;
    }
  }

  String get _statusLabel {
    switch (widget.transfer.status) {
      case TransferStatus.completed: return 'Done';
      case TransferStatus.failed: return 'Failed';
      case TransferStatus.inProgress: return 'Active';
      case TransferStatus.cancelled: return 'Cancelled';
      case TransferStatus.pending: return 'Pending';
      case TransferStatus.paused: return 'Paused';
    }
  }

  String get _typeIcon {
    final ext = widget.transfer.mimeType.split('/').first;
    switch (ext) {
      case 'image': return AppIcons.image;
      case 'video': return AppIcons.video;
      case 'audio': return AppIcons.audio;
      case 'application': return AppIcons.file;
      default: return AppIcons.file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Dismissible(
          key: Key(widget.transfer.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: SvgIconWidget(svgPath: AppIcons.delete, size: 22, color: AppColors.error),
          ),
          onDismissed: (_) => widget.onDelete(),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                // File type icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: SvgIconWidget(svgPath: _typeIcon, size: 24, color: _statusColor),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.bgBase,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgIconWidget(
                              svgPath: widget.transfer.direction == TransferDirection.sending
                                  ? AppIcons.send : AppIcons.receive,
                              size: 10,
                              color: _statusColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.transfer.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            widget.transfer.sizeLabel,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.transfer.senderName,
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _statusColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          color: _statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (widget.transfer.isActive) ...[
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 60,
                        child: LinearProgressIndicator(
                          value: widget.transfer.progress,
                          backgroundColor: AppColors.border,
                          color: AppColors.primary,
                          minHeight: 2,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
