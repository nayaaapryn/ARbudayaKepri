package com.xraph.plugin.flutter_unity_widget

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.content.res.Configuration
import android.util.Log
import android.view.InputDevice
import android.view.MotionEvent
import android.view.View
import android.widget.FrameLayout
import com.unity3d.player.IUnityPlayerLifecycleEvents
import com.unity3d.player.UnityPlayerForActivityOrService

@SuppressLint("NewApi")
class CustomUnityPlayer(context: Context, upl: IUnityPlayerLifecycleEvents?) : FrameLayout(context) {

    private val mUnityPlayer: UnityPlayerForActivityOrService

    companion object {
        internal const val LOG_TAG = "CustomUnityPlayer"
    }

    init {
        val activity = (context as? Activity ?: (context as? ContextWrapper)?.baseContext as? Activity)
            ?: throw IllegalArgumentException("Context must be or wrap an Activity")
        mUnityPlayer = UnityPlayerForActivityOrService(activity, upl)
        val lp = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        
        // Defensively check and remove the view from any existing parent first to avoid IllegalStateException in Unity 6
        val viewParent = mUnityPlayer.view.parent
        if (viewParent is android.view.ViewGroup) {
            viewParent.removeView(mUnityPlayer.view)
        }
        
        addView(mUnityPlayer.view, lp)
    }

    override fun onWindowVisibilityChanged(visibility: Int) {
        super.onWindowVisibilityChanged(visibility)
        if (visibility == View.VISIBLE) {
            mUnityPlayer.resume()
        } else {
            mUnityPlayer.pause()
        }
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        mUnityPlayer.windowFocusChanged(true)
        mUnityPlayer.resume()
    }

    override fun onDetachedFromWindow() {
        mUnityPlayer.windowFocusChanged(false)
        mUnityPlayer.pause()
        super.onDetachedFromWindow()
    }

    override fun onConfigurationChanged(newConfig: Configuration?) {
        Log.i(LOG_TAG, "ORIENTATION CHANGED")
        mUnityPlayer.configurationChanged(newConfig)
        super.onConfigurationChanged(newConfig)
    }

    fun unload() {
        mUnityPlayer.unload()
    }

    fun quit() {
        mUnityPlayer.destroy()
    }

    fun pause() {
        mUnityPlayer.pause()
    }

    fun resume() {
        mUnityPlayer.resume()
    }

    fun destroy() {
        mUnityPlayer.destroy()
    }

    fun lowMemory() {
        // no-op in Unity 6
    }

    fun windowFocusChanged(hasFocus: Boolean) {
        mUnityPlayer.windowFocusChanged(hasFocus)
    }

    override fun dispatchTouchEvent(ev: MotionEvent): Boolean {
        ev.source = InputDevice.SOURCE_TOUCHSCREEN
        mUnityPlayer.injectEvent(ev)
        return super.dispatchTouchEvent(ev)
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent?): Boolean {
        if (event == null) return false
        event.source = InputDevice.SOURCE_TOUCHSCREEN
        mUnityPlayer.injectEvent(event)
        return super.onTouchEvent(event)
    }
}