package com.unity3d.player;

/**
 * Mock IUnityPlayerLifecycleEvents interface to satisfy compilation requirements of flutter_unity_widget.
 */
public interface IUnityPlayerLifecycleEvents {
    void onUnityPlayerUnloaded();
    void onUnityPlayerQuitted();
}
