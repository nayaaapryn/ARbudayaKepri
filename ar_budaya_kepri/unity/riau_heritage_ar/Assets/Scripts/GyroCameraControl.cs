using UnityEngine;

namespace RiauHeritage.AR
{
    /// <summary>
    /// Smoothly maps the device's internal gyroscope rotation to the Unity Camera.
    /// Employs a zero-allocation update loop to ensure high performance on low-spec Android devices.
    /// </summary>
    [RequireComponent(typeof(Camera))]
    public class GyroCameraControl : MonoBehaviour
    {
        [Header("Gyro Calibration")]
        [Tooltip("Enable smoothing to reduce high-frequency device jitter.")]
        [SerializeField] private bool enableSmoothing = true;
        
        [Range(1f, 30f)]
        [SerializeField] private float smoothingSpeed = 10f;

        private bool isGyroSupported;
        private Gyroscope deviceGyro;
        private Quaternion baseRotationOffset;

        // Cache coordinates to avoid any structural boxing or allocations
        private Quaternion rawGyroAttitude;
        private Quaternion convertedRotation;
        private Quaternion targetRotation;

        private void Start()
        {
            isGyroSupported = SystemInfo.supportsGyroscope;

            if (isGyroSupported)
            {
                deviceGyro = Input.gyro;
                deviceGyro.enabled = true;

                // Calibrate base offset: Unity camera forward matches device's initial yaw orientation
                // The standard gyro attitude is right-handed. We rotate 90 degrees on X to align with the camera viewport.
                baseRotationOffset = Quaternion.Euler(90f, 90f, 0f);
            }
            else
            {
                Debug.LogWarning("[AR Gyro] Device does not support Gyroscope.");
            }
        }

        private void Update()
        {
            if (!isGyroSupported) return;

            // Get attitude as a value type (struct), no heap allocation
            rawGyroAttitude = deviceGyro.attitude;

            // Map right-handed sensor space to left-handed Unity world coordinate space:
            // x -> x, y -> y, z -> -z, w -> -w
            convertedRotation.x = rawGyroAttitude.x;
            convertedRotation.y = rawGyroAttitude.y;
            convertedRotation.z = -rawGyroAttitude.z;
            convertedRotation.w = -rawGyroAttitude.w;

            // Multiply by offset to stand upright and point forward
            targetRotation = convertedRotation * baseRotationOffset;

            // Apply rotation smoothly or directly to avoid jitter
            if (enableSmoothing)
            {
                transform.localRotation = Quaternion.Slerp(transform.localRotation, targetRotation, Time.deltaTime * smoothingSpeed);
            }
            else
            {
                transform.localRotation = targetRotation;
            }
        }
    }
}
