using System;
using UnityEngine;
using UnityEngine.Video;

namespace RiauHeritage.AR
{
    /// <summary>
    /// Dynamically activates and manages 3D visual panels, audio commentary, and video playback
    /// in response to Exhibit IDs scanned or selected in the Flutter companion application.
    /// Establishes an event-driven architecture with zero-allocation loops for maximum efficiency.
    /// </summary>
    public class HeritageAssetManager : MonoBehaviour
    {
        [System.Serializable]
        public struct HeritageAssetGroup
        {
            [Tooltip("Unique ID matching the scanned or selected heritage (e.g., 'zapin', 'gurindam12').")]
            public string heritageId;
            
            [Tooltip("The 3D Canvas or text panel containing historical description content.")]
            public GameObject textPanel;
            
            [Tooltip("The AudioSource supplying dynamic narration or traditional music.")]
            public AudioSource audioSource;
            
            [Tooltip("The VideoPlayer playing relevant ritual dances or documentations in world space.")]
            public VideoPlayer videoPlayer;
        }

        [Header("Asset Groups Configuration")]
        [SerializeField] private HeritageAssetGroup[] heritageAssetGroups;

        [Header("Global Controls")]
        [Tooltip("Stop playing other assets if a new one is selected.")]
        [SerializeField] private bool autoStopAllUnused = true;
        [SerializeField] private bool enableDebugLogs = true;

        private void OnEnable()
        {
            // Subscribe to the bi-directional bridge event system
            FlutterBridgeReceiver.OnHeritageIdReceived += HandleHeritageReceived;
        }

        private void OnDisable()
        {
            // Unsubscribe to prevent memory leaks or dangling event references
            FlutterBridgeReceiver.OnHeritageIdReceived -= HandleHeritageReceived;
        }

        /// <summary>
        /// Responds to the heritage bridge event cleanly.
        /// Iterates using indexers (for) to ensure absolutely zero GC memory allocations.
        /// </summary>
        private void HandleHeritageReceived(string heritageId)
        {
            if (string.IsNullOrEmpty(heritageId)) return;

            if (enableDebugLogs)
            {
                Debug.Log($"[AR Asset Manager] Active ID event fired. Sorting assets for: '{heritageId}'");
            }

            bool foundMatch = false;

            for (int i = 0; i < heritageAssetGroups.Length; i++)
            {
                HeritageAssetGroup group = heritageAssetGroups[i];
                
                // Perform ordinal comparison to prevent culture-sensitive string allocations
                bool isMatch = string.Equals(group.heritageId, heritageId, StringComparison.OrdinalIgnoreCase);

                if (isMatch)
                {
                    foundMatch = true;

                    // Activate 3D space text panel
                    if (group.textPanel != null)
                    {
                        group.textPanel.SetActive(true);
                    }

                    // Start Audio commentary
                    if (group.audioSource != null)
                    {
                        if (!group.audioSource.isPlaying)
                        {
                            group.audioSource.Play();
                        }
                    }

                    // Start Video player
                    if (group.videoPlayer != null)
                    {
                        if (!group.videoPlayer.isPlaying)
                        {
                            group.videoPlayer.Play();
                        }
                    }
                }
                else if (autoStopAllUnused)
                {
                    // Deactivate and mute other tradition layers to free up device resources
                    if (group.textPanel != null)
                    {
                        group.textPanel.SetActive(false);
                    }

                    if (group.audioSource != null && group.audioSource.isPlaying)
                    {
                        group.audioSource.Stop();
                    }

                    if (group.videoPlayer != null && group.videoPlayer.isPlaying)
                    {
                        group.videoPlayer.Stop();
                    }
                }
            }

            if (!foundMatch && enableDebugLogs)
            {
                Debug.LogWarning($"[AR Asset Manager] No asset group configured matching the ID: '{heritageId}'");
            }
        }
    }
}
