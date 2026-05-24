import 'package:flutter/material.dart';

import '../../../core/state.dart';
import '../../../core/theme.dart';
import '../../heritage/domain/heritage_model.dart';

class LogbookScreen extends StatefulWidget {
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  List<Heritage> _heritages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHeritageData();
  }

  Future<void> _loadHeritageData() async {
    try {
      final data = await heritageRepository.getAllHeritages();
      if (mounted) {
        setState(() {
          _heritages = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Logbook repository fetch failed: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleReset() async {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    
    // Safety confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: brightness == Brightness.dark ? AppTheme.cardBgDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Reset Logbook?'),
        content: const Text('This will permanently delete all collected museum stamps. Are you sure you want to proceed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Reset All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await stampManager.resetAllStamps();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logbook stamps reset successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Museum Stamp Logbook'),
        actions: [
          IconButton(
            tooltip: 'Reset Logbook',
            icon: const Icon(Icons.refresh_rounded, color: Colors.grey),
            onPressed: _handleReset,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.oceanTealPrimary))
          : ListenableBuilder(
              listenable: stampManager,
              builder: (context, _) {
                final unlockedCount = stampManager.unlockedStamps.length;
                final totalCount = _heritages.length;
                
                return Column(
                  children: [
                    // Summary status dashboard
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        decoration: glassmorphicDecoration(brightness: brightness),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: CircularProgressIndicator(
                                    value: totalCount > 0 ? (unlockedCount / totalCount) : 0,
                                    strokeWidth: 8,
                                    backgroundColor: brightness == Brightness.dark 
                                        ? Colors.white12 
                                        : Colors.black12,
                                    color: AppTheme.emeraldAccent,
                                  ),
                                ),
                                Text(
                                  '${totalCount > 0 ? ((unlockedCount / totalCount) * 100).toInt() : 0}%',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quest Status',
                                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    unlockedCount == totalCount
                                        ? 'Grand Master Preserver! You unlocked all heritages!'
                                        : 'Scan QR codes at physical exhibit booths to collect stamps.',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Grid list of stamps
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _heritages.length,
                        itemBuilder: (context, index) {
                          final heritage = _heritages[index];
                          final isUnlocked = stampManager.isUnlocked(heritage.id);
                          
                          return _buildStampCard(theme, heritage, isUnlocked);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildStampCard(ThemeData theme, Heritage item, bool isUnlocked) {
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.zero,
      elevation: isUnlocked ? 4 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isUnlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.oceanTealPrimary.withValues(alpha: 0.08),
                    AppTheme.emeraldAccent.withValues(alpha: 0.08),
                  ],
                )
              : null,
          color: isUnlocked ? null : (isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.02)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stamp Circle Badge
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? AppTheme.sandGold.withValues(alpha: 0.15)
                        : (isDark ? Colors.white10 : Colors.black12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isUnlocked ? AppTheme.sandGold : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: Icon(
                    isUnlocked ? Icons.stars_rounded : Icons.lock_outline_rounded,
                    color: isUnlocked ? AppTheme.sandGold : Colors.grey,
                    size: 40,
                  ),
                ),
                if (isUnlocked)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppTheme.emeraldAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Heritage title
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 13,
                color: isUnlocked 
                    ? (isDark ? Colors.white : AppTheme.oceanTealDark) 
                    : Colors.grey,
                fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            
            // Locked/Unlocked label
            Text(
              isUnlocked ? 'Unlocked' : 'Locked',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? AppTheme.emeraldAccent : Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
