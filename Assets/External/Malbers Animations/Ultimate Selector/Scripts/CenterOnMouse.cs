using UnityEngine;

#if UNITY_INPUT_SYSTEM
using UnityEngine.InputSystem;
#endif

namespace MalbersAnimations.InputSystem
{
    public class CenterOnMouse : MonoBehaviour
    {
        private void Update()
        {
#if UNITY_INPUT_SYSTEM
            transform.position = Mouse.current.position.ReadValue();
#else
            transform.position = Input.mousePosition;
#endif
        }
    }
}
