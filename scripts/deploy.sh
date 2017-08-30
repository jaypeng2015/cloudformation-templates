#!/bin/bash

AWS_PROFILE="${AWS_PROFILE:?\"Missing AWS_PROFILE environment variable -- will not use default profile!\"}"
STACK_NAME="${STACK_NAME:?\"Missing stack name parameter, e.g. sample-elasticbeanstalk-application\"}"
TEMPLATE_PATH="${TEMPLATE_PATH:?\"Missing template path parameter, e.g. templates/elestic-beanstalk/single-instance-public-subnet-nodejs.json\"}"
PARAMETERS=${@}

TEMPLATE_BODY="file://${TEMPLATE_PATH}"

echo "Validating template..."
aws cloudformation validate-template --template-body ${TEMPLATE_BODY}
rc=$?

if [ ${rc} -gt 0 ]
  then exit ${rc}
fi

aws cloudformation describe-stacks --stack-name ${STACK_NAME}
rc=$?
if [ ${rc} -eq 0 ]
  then
      echo "Updating template..."
      COMMAND="aws cloudformation update-stack"
  else
      echo "Creating template..."
      COMMAND="aws cloudformation create-stack"
fi

${COMMAND} \
  --stack-name ${STACK_NAME} \
  --template-body ${TEMPLATE_BODY} \
  --parameters ${PARAMETERS}

echo -e "To check on stack progress or result:\n"
echo "AWS_PROFILE=${AWS_PROFILE} aws cloudformation describe-stacks --stack-name ${STACK_NAME}"
