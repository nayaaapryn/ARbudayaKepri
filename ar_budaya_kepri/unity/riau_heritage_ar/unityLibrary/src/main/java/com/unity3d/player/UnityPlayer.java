package com.unity3d.player;

import android.content.Context;
import android.widget.FrameLayout;

/**
 * Mock UnityPlayer class to satisfy compilation requirements of flutter_unity_widget
 * in AGP 8.0+ layout validation modes.
 */
public class UnityPlayer extends FrameLayout {
    // Add both standard constructors required by CustomUnityPlayer and UnityPlayerActivity
    public UnityPlayer(Context context) {
        super(context);
    }

    public UnityPlayer(Context context, IUnityPlayerLifecycleEvents upl) {
        super(context);
    }

    public void unload() {}
    public void quit() {}
    public void pause() {}
    public void resume() {}
    public void destroy() {}
    public void lowMemory() {}
    public void windowFocusChanged(boolean hasFocus) {}

    // Static messaging bridge interface
    public static void UnitySendMessage(String gameObject, String methodName, String message) {}
}
