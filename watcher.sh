#!/bin/bash

# namespace name
NAMESPACE="sre"

# deployment name
DEPLOYMENT="swype-app"

# Maximum restart count before downscaling
MAX_RESTARTS=4

while true; do
  # Get the number of restarts of the pod
  RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

  echo "Current restarts count: ${RESTARTS}"

  # If restart count exceeds maximum restart count, downscale the deployment
  if (( RESTARTS > MAX_RESTARTS )); then
    echo "Maximum restart count exceeded. Downscaling deployment..."
    kubectl scale --replicas=0 deployment/${DEPLOYMENT} -n ${NAMESPACE}
    break
  fi

  # Break before next check cycle
  sleep 60
done