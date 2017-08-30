#!/bin/bash

AWS_PROFILE="${AWS_PROFILE:?\"Missing AWS_PROFILE environment variable -- will not use default profile!\"}"
aws cloudformation describe-stacks --stack-name $1
