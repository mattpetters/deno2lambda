# Deno 2 - AWS Lambda Template

Following the instructions here:

https://docs.deno.com/runtime/tutorials/aws_lambda/

Reproducing some of those docs here for convenience but if you have any issues reference the docs

Leverages the `aws-lambda-adapter` and docker

## Deploy

1. Build the docker image

```bash
docker build -t hello-world .
```

2. Create the ECR repository + push

```bash
aws ecr create-repository --repository-name hello-world --region us-east-1 | grep repositoryUri


```

This should output a repository URI that looks like <account_id>.dkr.ecr.us-east-1.amazonaws.com/hello-world.


then:

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account_id>.dkr.ecr.us-east-1.amazonaws.com
```


Tag the Docker image with the repository URI, again using the repository URI from the previous steps:

```bash
docker tag hello-world:latest <account_id>.dkr.ecr.us-east-1.amazonaws.com/hello-world:latest
```

Finally, push the Docker image to the ECR repository, using the repository URI from the previous steps:

```bash
docker push <account_id>.dkr.ecr.us-east-1.amazonaws.com/hello-world:latest

```

## Step 5: Create an AWS Lambda function

Now you can create a new AWS Lambda function from the AWS Management Console.

1. Go to the AWS Management Console and navigate to the Lambda service.
2. Click on the "Create function" button.
3. Choose "Container image".
4. Enter a name for the function, like "hello-world".
5. Click on the "Browse images" button and select the image you pushed to ECR.
6. Click on the "Create function" button.
7. Wait for the function to be created.
8. In the "Configuration" tab, go to the "Function URL" section and click on "Create function URL".
9. Choose "NONE" for the auth type (this will make the lambda function publicly accessible).
10. Click on the "Save" button.

## Step 6: Test the Lambda function Jump to heading#
- You can now visit your Lambda function's URL to see the response from your Deno app.

- 🦕 You have successfully deployed a Deno app to AWS Lambda using Docker. You can now use this setup to deploy more complex Deno apps to AWS Lambda.
