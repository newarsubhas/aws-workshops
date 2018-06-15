# Creating a role
To set up a Lambda function, you need to grant that function a role. 

* create these resources ...

```shell
cat > iamtrustdocument.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
      "Effect": "Allow",
      "Principal": {"Service": "lambda.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
}
EOF
```
```shell
cat > basiciampolicy.json <<EOF

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
```
```shell
cat > createiamrole.sh <<EOF
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
EOF
```
* now this will be the final step to create role using created above resources .
```shell
sh createiamrole.sh
```
The complete script first does some checks if a role by this name already exists, and if it does will output the ARN for that instead of creating a new one. 
