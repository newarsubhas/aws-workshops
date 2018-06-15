#!/usr/bin/env bash
set -e
ROLE_ARN=$(aws iam list-roles --query 'Roles[?RoleName==`lambda_basic_execution`].Arn' --output text)
if ! [ -z "$ROLE_ARN" ]
then
    echo "An existing role called lambda_basic_execution was found. The ARN for this is:
${ROLE_ARN}"
else
    aws iam create-role --role-name "lambda_basic_execution" --assume-role-policy-document file://iamtrustdocument.json
    aws iam put-role-policy --role-name "lambda_basic_execution" --policy-name "IgorRolePolicy" --policy-document file://basiciampolicy.json
    ROLE_ARN=$(aws iam get-role --role-name "lambda_basic_execution" --query Role.Arn --output text)
    echo "Created a new role called lambda_basic_execution. The ARN for this is:
${ROLE_ARN}"
fi