using UnityEngine;

public class CameraController : MonoBehaviour
{
    public float moveSpeed = 10.0f; 
    public float lookSpeed = 5.0f;  
    public float pitchMin = -30f;   
    public float pitchMax = 30f;   

    private float pitch = 0.0f;     

    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    void Update()
    {
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        Vector3 move = transform.right * horizontal + transform.forward * vertical;
        transform.position += move * moveSpeed * Time.deltaTime;

        
        float mouseX = Input.GetAxis("Mouse X");
        float mouseY = Input.GetAxis("Mouse Y");

        // Rotate camera around the Y axis
        transform.Rotate(Vector3.up * mouseX * lookSpeed);

        // Adjust pitch angle based on mouse input
        pitch -= mouseY * lookSpeed;
        pitch = Mathf.Clamp(pitch, pitchMin, pitchMax);
        
        // Apply the pitch rotation
        Camera.main.transform.localRotation = Quaternion.Euler(pitch, transform.eulerAngles.y, 0);
    }

    void OnApplicationFocus(bool hasFocus)
    {
        // Ensure cursor is locked and hidden when the application regains focus
        if (hasFocus)
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
    }

    void OnApplicationPause(bool pause)
    {
        // Ensure cursor is unlocked and visible when the application is paused
        if (pause)
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
    }
}