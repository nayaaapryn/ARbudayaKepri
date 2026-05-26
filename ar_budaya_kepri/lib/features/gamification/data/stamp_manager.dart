import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the gamification state of the application.
/// Uses native [ChangeNotifier] to represent a lightweight state manager,
/// avoiding memory-heavy third-party state libraries.
class StampManager extends ChangeNotifier {
  static const String _storageKey = 'unlocked_cultural_stamps';
  
  final Set<String> _unlockedStamps = {};
  bool _isInitialized = false;

  /// Returns whether the StampManager has successfully loaded local storage.
  bool get isInitialized => _isInitialized;

  /// Returns a read-only list of all unlocked heritage stamp IDs.
  List<String> get unlockedStamps => _unlockedStamps.toList();

  /// Initialises local storage by loading saved stamp progress.
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? loadedStamps = prefs.getStringList(_storageKey);
      
      if (loadedStamps != null) {
        _unlockedStamps.addAll(loadedStamps);
      }
    } catch (e) {
      // Robust error logging to avoid runtime crashes on faulty low-end file systems
      debugPrint('Error loading stamps from local storage: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Checks if a specific heritage ID is currently unlocked.
  bool isUnlocked(String id) {
    return _unlockedStamps.contains(id);
  }

  /// Asynchronously unlocks a heritage stamp and persists the updated progress.
  /// Returns `true` if the stamp was newly unlocked, or `false` if already unlocked.
  Future<bool> unlockStamp(String id) async {
    // Standard safety check
    if (id.trim().isEmpty) return false;
    
    // If already unlocked, no need to overwrite storage
    if (_unlockedStamps.contains(id)) return false;

    _unlockedStamps.add(id);
    notifyListeners(); // Immediate UI feedback response

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, _unlockedStamps.toList());
      return true;
    } catch (e) {
      debugPrint('Failed to persist stamp unlock state: $e');
      // Graceful fallback: although storage failed, the local session memory is kept
      return false;
    }
  }

  /// Resets all stamps (useful for debugging/testing).
  Future<void> resetAllStamps() async {
    _unlockedStamps.clear();
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      debugPrint('Failed to clear stamp database: $e');
    }
  }
}
