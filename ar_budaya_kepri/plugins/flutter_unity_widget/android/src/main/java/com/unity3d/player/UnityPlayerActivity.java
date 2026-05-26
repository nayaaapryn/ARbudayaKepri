package com.unity3d.player;

import android.app.Activity;

/**
 * Stub UnityPlayerActivity class to satisfy compilation requirements of flutter_unity_widget.
 * Placed persistently inside the local plugin to prevent being wiped out by Unity exports.
 */
public class UnityPlayerActivity extends Activity {
    
    public static abstract class StubUnityPlayer extends UnityPlayer {
        public StubUnityPlayer(android.content.Context context) {
            super(context, null, null);
        }
        
        public void quit() {}
        public void lowMemory() {}
    }

    protected StubUnityPlayer mUnityPlayer;

    protected void onUnityPlayerUnloaded() {}
}
