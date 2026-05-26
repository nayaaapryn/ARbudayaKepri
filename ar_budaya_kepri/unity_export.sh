#!/bin/bash
# Touch the legacy mock files Unity demands
touch android/build.gradle
touch android/settings.gradle
touch android/app/build.gradle

# Run the background Unity export method
/Applications/Unity/Hub/Editor/6000.3.0f1/Unity.app/Contents/MacOS/Unity -batchmode -quit -projectPath "$(pwd)/unity/riau_heritage_ar" -executeMethod FlutterUnityIntegration.Editor.Build.DoBuildAndroidLibraryDebug -logFile -

# Instantly clean up the mock files to protect our Kotlin DSL (.kts) workspace
rm android/build.gradle
rm android/settings.gradle
rm android/app/build.gradle
echo "✅ Unity export completed and mock files scrubbed!"
