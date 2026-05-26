import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state.dart';
import '../../../core/theme.dart';
import '../../heritage/domain/heritage_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Heritage> _heritages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHeritages();
    
    const bool isTestMode = String.fromEnvironment('TEST_AR_MODE') == 'true';
    if (isTestMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Programmatically route straight to our AR test screen layout
        context.push('/heritage/zapin/ar');
      });
    }
  }

  Future<void> _loadHeritages() async {
    try {
      final data = await heritageRepository.getAllHeritages();
      if (mounted) {
        setState(() {
          _heritages = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading heritages in UI: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadHeritages,
          color: AppTheme.oceanTealPrimary,
          child: CustomScrollView(
            slivers: [
              // Beautiful Custom Premium Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AR Budaya Kepri',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: AppTheme.oceanTealPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Explore Riau Islands Intangible Heritage',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          // Premium logbook shortcut
                          IconButton.filledTonal(
                            onPressed: () => context.push('/logbook'),
                            icon: const Icon(Icons.bookmark_outline),
                            style: IconButton.styleFrom(
                              foregroundColor: AppTheme.oceanTealPrimary,
                              backgroundColor: AppTheme.oceanTealLight.withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Dynamic Logbook Progress Card
                      ListenableBuilder(
                        listenable: stampManager,
                        builder: (context, _) {
                          final unlockedCount = stampManager.unlockedStamps.length;
                          final totalCount = _heritages.isEmpty ? 7 : _heritages.length;
                          final progressPercent = totalCount > 0 ? (unlockedCount / totalCount) : 0.0;
                          
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: glassmorphicDecoration(brightness: brightness),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.sandGold.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.stars_rounded,
                                        color: AppTheme.sandGold,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Museum Expedition Progress',
                                            style: theme.textTheme.titleLarge?.copyWith(
                                              fontSize: 16,
                                              letterSpacing: 0.1,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '$unlockedCount of $totalCount Stamps Unlocked',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Progress bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: progressPercent,
                                    minHeight: 8,
                                    backgroundColor: brightness == Brightness.dark 
                                        ? Colors.white12 
                                        : Colors.black12,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.emeraldAccent),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      
                      Text(
                        'Heritage Catalog',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Catalog Grid
              _isLoading
                  ? const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: AppTheme.oceanTealPrimary),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final heritage = _heritages[index];
                            return _buildHeritageCard(context, heritage, brightness);
                          },
                          childCount: _heritages.length,
                        ),
                      ),
                    ),
              
              // Spacing helper
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      // Highly premium Floating Action Button for barcode scanning
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/scanner'),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan Exhibit'),
        backgroundColor: AppTheme.oceanTealPrimary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeritageCard(BuildContext context, Heritage item, Brightness brightness) {
    final theme = Theme.of(context);
    
    return ListenableBuilder(
      listenable: stampManager,
      builder: (context, _) {
        final isUnlocked = stampManager.isUnlocked(item.id);
        
        return InkWell(
          onTap: () => context.push('/heritage/${item.id}'),
          borderRadius: BorderRadius.circular(20),
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dynamic Header Image
                    Expanded(
                      flex: 5,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.black12,
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.oceanTealPrimary),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.oceanTealPrimary.withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppTheme.oceanTealPrimary,
                            ),
                          );
                        },
                      ),
                    ),
                    // Details block
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.category,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.emeraldAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: 14,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Active stamp status indicator badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUnlocked 
                          ? AppTheme.emeraldAccent.withValues(alpha: 0.9) 
                          : Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUnlocked ? Icons.check_circle : Icons.lock_outline,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isUnlocked ? 'Scan' : 'Lock',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
