#!/bin/bash

# Define your ECR URI
ECR_URI="283565981308.dkr.ecr.us-east-1.amazonaws.com/otel-demo"

# Define the list of services
SERVICES=(
  "frontendproxy"
  "loadgenerator"
  "frontend"
  "checkoutservice"
  "currencyservice"
  "shippingservice"
  "frauddetectionservice"
  "recommendationservice"
  "adservice"
  "productcatalogservice"
  "quoteservice"
  "flagdui"
  "cartservice"
  "accountingservice"
  "emailservice"
  "paymentservice"
  "imageprovider"
  "kafka"
)

# Output sed commands for deploy.yml
DEPLOY_WORKFLOW_FILE=".github/workflows/deploy.yml"

# Add sed commands to update image paths in Kubernetes manifests
echo "Updating deploy.yml with sed commands for Kubernetes manifests..."

echo "      run: |" >> "$DEPLOY_WORKFLOW_FILE"
for SERVICE in "${SERVICES[@]}"; do
  echo "        sed -i 's|ghcr.io/open-telemetry/demo:.*-${SERVICE}|${ECR_URI}:${SERVICE}|g' kubernetes/opentelemetry-demo.yaml" >> "$DEPLOY_WORKFLOW_FILE"
done

# Ensure rollout status checks for all critical services
echo "      run: |" >> "$DEPLOY_WORKFLOW_FILE"
for SERVICE in "${SERVICES[@]}"; do
  echo "        kubectl rollout status deployment/${SERVICE} -n otel-demo" >> "$DEPLOY_WORKFLOW_FILE"
done

echo "Updated deploy.yml with sed commands and rollout checks."

