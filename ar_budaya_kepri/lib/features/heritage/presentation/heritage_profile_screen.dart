import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state.dart';
import '../../../core/theme.dart';
import '../domain/heritage_model.dart';

class HeritageProfileScreen extends StatefulWidget {
  final String id;
  final bool openedViaScan;

  const HeritageProfileScreen({
    super.key,
    required this.id,
    this.openedViaScan = false,
  });

  @override
  State<HeritageProfileScreen> createState() => _HeritageProfileScreenState();
}

class _HeritageProfileScreenState extends State<HeritageProfileScreen> {
  Heritage? _heritage;
  bool _isLoading = true;
  bool _isNewUnlock = false;

  @override
  void initState() {
    super.initState();
    _loadHeritageData();
  }

  Future<void> _loadHeritageData() async {
    try {
      final data = await heritageRepository.getHeritageById(widget.id);
      
      if (mounted) {
        setState(() {
          _heritage = data;
          _isLoading = false;
        });
      }

      // If the page was successfully loaded, and it was opened via a scan, unlock stamp!
      if (data != null && widget.openedViaScan) {
        final newlyUnlocked = await stampManager.unlockStamp(data.id);
        if (newlyUnlocked && mounted) {
          setState(() => _isNewUnlock = true);
          // Show a beautiful premium success SnackBar to reward the user
          _showUnlockBadge(data.title);
        }
      }
    } catch (e) {
      debugPrint('Failed to load heritage detail sheet: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showUnlockBadge(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.stars_rounded, color: AppTheme.sandGold, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Stamp Unlocked!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'You have collected the stamp for $title!',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.oceanTealDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _handleARLaunch() {
    // Print debug log as required by PRD and instructions
    debugPrint('AR ENGINE ACTION: Launching VR/AR 360 gyro experiences for heritage ID: ${widget.id}');
    context.push('/heritage/${widget.id}/ar');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.oceanTealPrimary),
        ),
      );
    }

    if (_heritage == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Heritage Detail')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Heritage ID "${widget.id}" Not Found',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final item = _heritage!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Elegant Sliver App Bar with parallax background image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: brightness == Brightness.dark 
                    ? Colors.black54 
                    : Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                item.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.oceanTealPrimary.withValues(alpha: 0.2),
                      child: const Icon(Icons.image, size: 64, color: AppTheme.oceanTealPrimary),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Heritage profile body details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metadata Badges (Category & Location)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.emeraldAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.oceanTealPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.oceanTealPrimary),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                item.location,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.oceanTealPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Unlock Notice if opened from scanner
                  if (_isNewUnlock) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.sandGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.sandGold.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.stars_rounded, color: AppTheme.sandGold),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Verified scan stamp added to your Logbook!',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: brightness == Brightness.dark ? AppTheme.sandGold : Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  
                  // Short description
                  Text(
                    item.shortDescription,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Historical text detail
                  Text(
                    'Historical Background',
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.historicalBackground,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      height: 1.5,
                      color: brightness == Brightness.dark ? Colors.white60 : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 28),
                  
                  // Media Player Section Placeholder
                  Text(
                    'Educational Media Assets',
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  
                  // Audio Narrator Box
                  _buildMediaPlaceholder(
                    icon: Icons.audiotrack_rounded,
                    title: 'Audio Oral Narrative Narration',
                    subtitle: item.audioUrl,
                    theme: theme,
                  ),
                  const SizedBox(height: 12),
                  
                  // Video Performance Box
                  _buildMediaPlaceholder(
                    icon: Icons.video_collection_rounded,
                    title: 'Historical Demonstration Video',
                    subtitle: item.videoUrl,
                    theme: theme,
                  ),
                  
                  const SizedBox(height: 120), // Spacing for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: brightness == Brightness.dark 
                  ? Colors.white10 
                  : Colors.black12,
              width: 1,
            ),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _handleARLaunch,
            icon: const Icon(Icons.view_in_ar_rounded, size: 24),
            label: const Text('LAUNCH AR EXPERIENCE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.oceanTealPrimary,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPlaceholder({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardBgDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.oceanTealPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.oceanTealPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Simulated play of asset: $title')),
              );
            },
            icon: const Icon(Icons.play_arrow_rounded, color: AppTheme.emeraldAccent),
          ),
        ],
      ),
    );
  }
}
