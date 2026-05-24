package com.unity3d.player;

import android.app.Activity;
import android.os.Bundle;

/**
 * Mock UnityPlayerActivity class to satisfy compilation requirements of flutter_unity_widget
 * in AGP 8.0+ layout validation modes.
 */
public class UnityPlayerActivity extends Activity {
    protected UnityPlayer mUnityPlayer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mUnityPlayer = new UnityPlayer(this);
    }

    protected void onUnityPlayerUnloaded() {}
}
