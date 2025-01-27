using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.AI;

namespace RPGSystem
{
    [RequireComponent(typeof(NavMeshAgent))]
    public class RPGNavigationAgent : MonoBehaviour
    {
        public Entity myEntity;
        public Transform target;

        public float speed;
        public float stoppingDistance = 2f;

        NavMeshAgent navAgent;
        Vector3 _targetDirection;

        void OnValidate()
        {
            if (myEntity == null) myEntity = GetComponent<Entity>();
        }

        void Awake()
        {
            navAgent = GetComponent<NavMeshAgent>();
            navAgent.updateRotation = false;
            navAgent.updateUpAxis = false;
        }

        void Update()
        {
            if (!navAgent.isStopped)
            {
                navAgent.speed = speed;
                navAgent.destination = target.position;
                navAgent.stoppingDistance = stoppingDistance;
                _targetDirection = target.position - transform.position;
                myEntity.AnimationWalk(_targetDirection);
            }
        }

        [Button()]
        public void StopChasing()
        {
            navAgent.ResetPath();
            navAgent.isStopped = true;
            myEntity.LookAtDirection(_targetDirection);
        }

        [Button()]
        public void StartChasing()
        {
            navAgent.isStopped = false;
        }
    }

}