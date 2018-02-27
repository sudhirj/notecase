#!/bin/bash

## Get environment details from CI
BUILD_NUMBER=$CIRCLE_BUILD_NUM
if [ "${ENV}" == "staging" ]
then
  export AWS_ACCESS_KEY_ID=$STAGING_AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$STAGING_AWS_SECRET_ACCESS_KEY
  export AWS_REGION=$STAGING_AWS_REGION
  AWS_BUCKET=$STAGING_AWS_BUCKET
  AWS_ACCOUNT_ID=$STAGING_AWS_ACCOUNT_ID
  CLUSTER_NAME="jt-staging-cluster"
  CONFIG_FOLDER="jt-staging-config"
fi
if [ "${ENV}" == "production" ]
then
  export AWS_ACCESS_KEY_ID=$PRODUCTION_AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$PRODUCTION_AWS_SECRET_ACCESS_KEY
  export AWS_REGION=$PRODUCTION_AWS_REGION
  AWS_BUCKET=$PRODUCTION_AWS_BUCKET
  AWS_ACCOUNT_ID=$PRODUCTION_AWS_ACCOUNT_ID
  CLUSTER_NAME="jt-cluster"
  CONFIG_FOLDER="jt-production-config"
fi

## Configure the details about the deployment
SERVICE_NAME="jt-bwl-service"
TASK_FAMILY="jt-bwl-task"
CONFIG_NAME="jt-bwl"
IMAGE_REPO_NAME="jt-wallet"
IMAGE_VERSION="v_"${BUILD_NUMBER}

## Build the image and push to ECR
eval $(aws ecr get-login --no-include-email --region ap-south-1)
docker build -t ${IMAGE_REPO_NAME} .
docker tag ${IMAGE_REPO_NAME} ${AWS_ACCOUNT_ID}.dkr.ecr.ap-south-1.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_VERSION}
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-south-1.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_VERSION}

## Create a new task definition for this build
aws s3 cp --region ${AWS_REGION} s3://${AWS_BUCKET}/${CONFIG_NAME}.json  /tmp/ci/${CONFIG_FOLDER}/
WORKSPACE_PATH="/tmp/ci/${CONFIG_FOLDER}/${CONFIG_NAME}.json"
CONFIG_PATH="/tmp/ci/${CONFIG_FOLDER}/${CONFIG_NAME}-${IMAGE_VERSION}.json"
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" ${WORKSPACE_PATH}  > ${CONFIG_PATH}
aws ecs register-task-definition --region ${AWS_REGION} --family  ${TASK_FAMILY} --cli-input-json file://${CONFIG_PATH}

## Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition  --region ${AWS_REGION} --task-definition ${TASK_FAMILY} | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
DESIRED_COUNT=`aws ecs describe-services --region ${AWS_REGION} --cluster ${CLUSTER_NAME} --services ${SERVICE_NAME}  | egrep "desiredCount" | tr "/" " " | awk '{print $2}' | sed 's/,$//' | head -1`
if [ ${DESIRED_COUNT} = "0" ];
then
    DESIRED_COUNT="2"
fi
aws ecs update-service --region ${AWS_REGION} --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME}  --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT} --deployment-configuration maximumPercent=200,minimumHealthyPercent=50

## Wait until the service runs with the new task revision
SERVICE_TASK=`aws ecs describe-services --region ${AWS_REGION}  --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} | egrep "taskDefinition" | tr ":" " " | awk '{print $8}' | sed 's/",//' | head -1`
RUNNING_TASK=`aws ecs describe-services --region ${AWS_REGION}  --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME}| egrep "taskDefinition" | tr ":" " " | awk '{print $8}' | sed 's/",//' | tail -1`
echo "SERVICE_TASK:" $SERVICE_TASK
echo "RUNNING_TASK:" $RUNNING_TASK
echo "TASK_REVISION:" $TASK_REVISION
while [[ ${SERVICE_TASK} != ${RUNNING_TASK} ]]; do
    sleep 10
    SERVICE_TASK=`aws ecs describe-services --region ${AWS_REGION}  --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} | egrep "taskDefinition" | tr ":" " " | awk '{print $8}' | sed 's/",//' | head -1`
    RUNNING_TASK=`aws ecs describe-services --region ${AWS_REGION}  --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME}| egrep "taskDefinition" | tr ":" " " | awk '{print $8}' | sed 's/",//' | tail -1`
    echo "Waiting for recent task running- Service Task:"${SERVICE_TASK} " Running Task:"${RUNNING_TASK}
done

echo "Task ${RUNNING_TASK} has been deployed successfully"
