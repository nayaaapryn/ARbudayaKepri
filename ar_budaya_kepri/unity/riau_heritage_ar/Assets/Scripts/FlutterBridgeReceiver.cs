using System;
using UnityEngine;
using FlutterUnityIntegration;

namespace RiauHeritage.AR
{
    /// <summary>
    /// Receives message inputs from the Flutter UI bridge layer via `flutter_unity_widget`.
    /// Employs a zero-allocation, event-driven architecture to keep CPU/Memory overhead minimal on low-spec units.
    /// This script should be attached to a GameObject named "FlutterBridgeReceiver" in your Unity Scene.
    /// </summary>
    public class FlutterBridgeReceiver : MonoBehaviour
    {
        // Expose a public delegate event system for other Unity components to listen to
        public static event Action<string> OnHeritageIdReceived;

        [Header("Debug Settings")]
        [SerializeField] private bool enableDebugLogs = true;

        private void Awake()
        {
            // Set the GameObject name explicitly on initialization to prevent bridge mismatch issues
            gameObject.name = "FlutterBridgeReceiver";
        }

        void Start()
        {
            StartCoroutine(SendReadyWhenLoaded());
        }

        private System.Collections.IEnumerator SendReadyWhenLoaded()
        {
            yield return new UnityEngine.WaitForSecondsRealtime(1.0f);
            #if !UNITY_EDITOR
            UnityMessageManager.Instance.SendMessageToFlutter("READY");
            #else
            Debug.Log("[AR Bridge] Editor Mode: Simulating SendMessageToFlutter('READY')");
            #endif
        }

        /// <summary>
        /// Entry point invoked directly by the Flutter side via:
        /// `postMessage('FlutterBridgeReceiver', 'OnHeritageReceived', heritageId)`
        /// </summary>
        /// <param name="heritageId">The unique ID of the heritage exhibit scanned or selected.</param>
        public void OnHeritageReceived(string heritageId)
        {
            if (string.IsNullOrEmpty(heritageId))
            {
                if (enableDebugLogs) Debug.LogWarning("[AR Bridge] Received empty or invalid heritage ID from Flutter.");
                return;
            }

            if (enableDebugLogs)
            {
                Debug.Log($"[AR Bridge] Successfully received message from Flutter. Target ID: {heritageId}");
            }

            // Fire the static C# event framework so that specialized components (e.g., SkyboxManagers, audio systems)
            // can selectively load the matching cultural assets dynamically.
            try
            {
                OnHeritageIdReceived?.Invoke(heritageId);
            }
            catch (Exception ex)
            {
                Debug.LogError($"[AR Bridge] Error executing subscribed event listeners: {ex.Message}");
            }
        }

        /// <summary>
        /// Helper method to send a command back to Flutter if the user exits from the Unity layer.
        /// </summary>
        public void SendExitMessageToFlutter()
        {
            if (enableDebugLogs) Debug.Log("[AR Bridge] Dispatching exit command message back to Flutter.");
            
            // Sends the string message "exit" back to the onUnityMessage callback in Flutter
            #if !UNITY_EDITOR
            UnityMessageManager.Instance.SendMessageToFlutter("exit");
            #else
            Debug.Log("[AR Bridge] Editor Mode: Simulating SendMessageToFlutter('exit')");
            #endif
        }

        /// <summary>
        /// Cleanly triggers an engine asset purge and unloads the Unity player.
        /// </summary>
        public void PrepareForUnload()
        {
            if (enableDebugLogs) Debug.Log("[AR Bridge] Preparing Unity for unload and purging dynamic assets...");
            #if !UNITY_EDITOR
            UnityEngine.Application.Unload();
            #else
            Debug.Log("[AR Bridge] Editor Mode: Simulating UnityEngine.Application.Unload()");
            #endif
        }
    }
}
