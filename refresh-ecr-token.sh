#!/bin/sh

ECR_TOKEN=$(aws ecr get-login-password --region ${AWS_REGION})

kubectl delete secret --ignore-not-found $DOCKER_SECRET_NAME -n $NAMESPACE_NAME
kubectl create secret docker-registry $DOCKER_SECRET_NAME \
  --docker-server=https://${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com \
  --docker-username=AWS \
  --docker-password="${ECR_TOKEN}" \
  --namespace=$NAMESPACE_NAME --dry-run=client -o yaml | kubectl apply -f -

echo "Secret successfully updated at $(date)"
