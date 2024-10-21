#!/bin/bash

# Usage: ./deploy.sh <function-name>
# ie; ./deploy.sh hello-world
# This script assumes you've already created the ECR repository and Lambda function. 

FUNCTION_NAME=$1
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-west-2"  # Change as needed

if [ -z "$FUNCTION_NAME" ]
then
    echo "Please provide a function name"
    exit 1
fi

if [ ! -d "$FUNCTION_NAME" ]
then
    echo "Function directory $FUNCTION_NAME does not exist"
    exit 1
fi

# Build the Docker image
docker build -t $FUNCTION_NAME ./$FUNCTION_NAME

# Tag the Docker image
docker tag $FUNCTION_NAME:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$FUNCTION_NAME:latest

# Push the Docker image to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$FUNCTION_NAME:latest

# Update the Lambda function
aws lambda update-function-code --function-name $FUNCTION_NAME --image-uri $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$FUNCTION_NAME:latest

echo "Deployment of $FUNCTION_NAME completed"
