# 🕌 AR Budaya Kepri (Riau Islands Cultural Heritage AR Experience)

AR Budaya Kepri is a mobile application developed for the **Pemrograman Perangkat Mobile (Mobile Device Programming) - 6th Semester** university course. It is designed to preserve, catalog, and celebrate the rich intangible cultural heritage of the Riau Islands (*Kepulauan Riau / Kepri*) using an interactive Augmented Reality (AR) viewport.

The project blends **Flutter** for UI, routing, state management, and cataloging with **Unity 6** for high-performance 3D rendering and gyroscope-driven virtual environment experiences.

---

## 🚀 Key Features

1. **Intangible Cultural Heritage Catalog**:
   * Detailed cultural entries for 7 iconic Riau Islands traditions: *Tari Zapin Penyengat, Boria, Gazal, Makyong, Mendu, Gurindam 12,* and *Mandi Safar*.
   * Premium maritime-themed UI designed with a sandy-teal color palette (`AppTheme`) representing the coastal identity of the region.

2. **Gamified Cultural Logbook (Stamp Collection)**:
   * Keeps users engaged by locking cultural stamps until they physically scan exhibits.
   * Tracks achievements asynchronously and saves unlock progress using local persistence (`shared_preferences`).
   * Beautifully rendered locked/unlocked visual state cards in the Logbook dashboard.

3. **High-Performance Camera QR Scanner**:
   * Scans physical QR codes placed at cultural exhibits using `mobile_scanner`.
   * Includes a Developer Simulation mode allowing testing and emulation without a physical camera feed.
   * Leverages smart routing backstack pops: scanning automatically replaces the routing stack, preventing visitors from getting trapped in camera preview loops.

4. **Immersive Unity 6 AR Viewport**:
   * Renders embedded 360° virtual cultural scenes directly inside a Flutter widget.
   * Employs zero-allocation, garbage-collection-safe C# scripts to handle camera rotations (`GyroCameraControl.cs`) and asset switching (`HeritageAssetManager.cs`).
   * Performs proactive native memory teardowns (`pause()`, `unload()`, `dispose()`) upon exiting to prevent Out-Of-Memory (OOM) crashes on low-end Android devices (< 4GB RAM).

---

## 🛠 Tech Stack & Architecture

* **Frontend Framework**: Flutter (Dart)
* **AR/3D Graphics Engine**: Unity 6 (C#)
* **State Management & DI**: GetIt (Service Locator pattern)
* **Navigation**: GoRouter (Parameter-based deep linking `/heritage/:id/ar`)
* **Persistence**: Shared Preferences (Local JSON storage)
* **Native Bridges**: Android JNI (Java Native Interface), Kotlin, Custom FrameLayout Lifecycles
* **Build System**: Android Gradle Plugin 8.0+ (Kotlin DSL `.kts`)

---

## 📁 Repository Structure

```
ar_budaya_kepri/
├── android/                             # Host Android Project (Kotlin DSL)
│   ├── app/                             # Flutter Application Module
│   ├── settings.gradle.kts              # Maps and imports the :unityLibrary project
│   └── unityLibrary/                    # Exported Unity 6 Android Library
├── ios/                                 # iOS Project files and UnityFramework linking
├── lib/                                 # Flutter Source Code (Clean Architecture)
│   ├── core/                            # App themes, Router mappings, and State Locators
│   └── features/
│       ├── gamification/                # Stamp unlocking, persistence, and Logbook screens
│       ├── heritage/                    # Cultural details, Scanner widgets, and AR screens
│       └── home/                        # Welcome catalog dashboard and highlights
├── plugins/
│   └── flutter_unity_widget/            # Patched local plugin binding for Unity 6
└── unity/
    └── riau_heritage_ar/                # Unity 6 Project Files (Assets, Scenes, C# Scripts)
```

---

## ⚡ Architectural Issues Solved

During development, several complex embedding and compilation issues were successfully resolved:

### 1. Unity 6 FrameLayout Adapter & Context Crash
Unity 6's updated `com.unity3d.player.UnityPlayer` no longer inherits directly from `View` on Android, causing immediate layout crashes. We developed a custom wrapper class `CustomUnityPlayer.kt` inheriting from `FrameLayout` to hold the instance. Furthermore, we implemented context wrapper type checks to unpack and pass the true Host `Activity` context instead of standard application layout containers.

### 2. EGL Buffer Leaks & Singleton Unload Stalls
Android runs Unity on a persistent native singleton thread. Closing the AR screen and returning later originally caused graphics buffer corruption and handshake stalls. We solved this by:
* Dispatching explicit `PrepareForUnload()` and native `UnityEngine.Application.Unload()` calls immediately on exit.
* Pausing and focusing the underlying rendering surface inside `onAttachedToWindow` and `onDetachedFromWindow` callback overrides.
* Checking if the engine is already warm during controller bootstrapping and replaying the `"READY"` handshake message immediately back to Flutter.

### 3. JNI Library Compression Failures
Android packages native `.so` binaries compressed by default, preventing Unity 6 from resolving class bindings at runtime. We solved this by setting `useLegacyPackaging = false` in Gradle and injecting `android:extractNativeLibs="true"` into the manifests, automated by our post-processor script (`Build.cs`).

### 4. Warm-Engine Handshake Race Conditions
On cold starts, the initial scene load fired before Dart listeners were bound, whereas on warm re-entries, the scene load event never fired again. We updated `ar_view_screen.dart` to dispatch the heritage ID immediately upon receiving the `"READY"` event-driven handshake message, ensuring 100% reliable content loading under all runtime conditions.

