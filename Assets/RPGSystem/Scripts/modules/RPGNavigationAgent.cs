using System;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.AI;

namespace RPGSystem
{
    [RequireComponent(typeof(NavMeshAgent))]
    public class RPGNavigationAgent : MonoBehaviour
    {
        public Entity myEntity;
        public NavigationMode navigationMode;
        public Transform target;

        public float speed;
        public float stoppingDistance = 2f;
        public float lookAtDelay = 1f;
        public float lookAtDistance = 6f;

        NavMeshAgent navAgent;
        Vector3 _targetDirection;
        float _lastTimeLookAt;

        void OnValidate()
        {
            if (myEntity == null) myEntity = GetComponent<Entity>();
        }

        void Awake()
        {
            navAgent = GetComponent<NavMeshAgent>();
            navAgent.isStopped = true;
            navAgent.updateRotation = false;
            navAgent.updateUpAxis = false;
        }

        void Update()
        {
            if (navAgent.isStopped) return;

            switch (navigationMode)
            {
                case NavigationMode.Chase: Chase(); break;
                case NavigationMode.LookAt: LookAt(); break;
                default: Stop(); break;
            }
        }

        private void LookAt()
        {
            if (Time.time < _lastTimeLookAt + lookAtDelay) return; // Cooldown

            if (Vector3.Distance(target.position, myEntity.transform.position) < lookAtDistance) // Look when in range
            {
                _targetDirection = target.position - transform.position;
                _lastTimeLookAt = Time.time;
                myEntity.LookAtDirection(_targetDirection);
            }
        }

        private void Chase()
        {
            _targetDirection = target.position - transform.position;
            navAgent.speed = speed;
            navAgent.destination = target.position;
            navAgent.stoppingDistance = stoppingDistance;
            myEntity.AnimationWalk(_targetDirection);
        }

        [Button()]
        public void Stop()
        {
            navAgent.ResetPath();
            navAgent.isStopped = true;
            navigationMode = NavigationMode.Stop;
            myEntity.StopMovement().Forget();
        }

        [Button()]
        public void StartChasing()
        {
            navAgent.isStopped = false;
            navigationMode = NavigationMode.Chase;
        }

        [Button()]
        public void StartLookAt()
        {
            navAgent.isStopped = false;
            navigationMode = NavigationMode.LookAt;
        }
    }

    public enum NavigationMode { Stop, LookAt, Chase }

}