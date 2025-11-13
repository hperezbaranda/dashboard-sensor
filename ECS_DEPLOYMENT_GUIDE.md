# 🚀 AWS ECS Fargate Deployment Guide

## Prerequisites Checklist

Before deploying, ensure you have:

### 1. AWS Resources Created
- ✅ **ECR Repository**: `dashboard`
- ✅ **ECS Cluster**: `dashboard-cluster`
- ✅ **ECS Service**: `dashboard-service-auto`
- ✅ **CloudWatch Log Group**: `/ecs/dashboard-sensor`
- ✅ **IAM Role**: `ecsTaskExecutionRole`

### 2. GitHub Secrets Configured
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Step-by-Step Setup

### 1. Create ECR Repository
```bash
aws ecr create-repository \
    --repository-name dashboard \
    --region ca-central-1
```

### 2. Create CloudWatch Log Group
```bash
bash scripts/create-cloudwatch-logs.sh
```

### 3. Create ECS Cluster
```bash
aws ecs create-cluster \
    --cluster-name dashboard-cluster \
    --region ca-central-1
```

### 4. Create ECS Service
First, you need to create the service. You can do this via AWS Console or CLI:

```bash
aws ecs create-service \
    --cluster dashboard-cluster \
    --service-name dashboard-service-auto \
    --task-definition dashboard-task-def \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-xxxxx],securityGroups=[sg-xxxxx],assignPublicIp=ENABLED}" \
    --region ca-central-1
```

**Note**: Replace `subnet-xxxxx` and `sg-xxxxx` with your actual subnet and security group IDs.

### 5. Verify Task Definition
The current `task-definition.json` includes:
- ✅ **Container Port**: 8000 (FastAPI default)
- ✅ **Health Check**: HTTP health check on `/`
- ✅ **Logging**: CloudWatch logs configuration
- ✅ **Resource Limits**: 512 CPU, 1024 MB memory
- ✅ **Environment Variables**: Production settings

## Networking Requirements

### Security Group Rules
Your security group needs these inbound rules:
```
Port 8000: 0.0.0.0/0 (HTTP)
Port 80: 0.0.0.0/0 (HTTP - if using ALB)
Port 443: 0.0.0.0/0 (HTTPS - if using ALB)
```

### Application Load Balancer (Recommended)
Create an ALB to expose your service:
1. Create target group (port 8000, health check path `/`)
2. Create load balancer
3. Configure listener rules

## Deployment Process

### Manual Deployment
```bash
# 1. Build and push to ECR
aws ecr get-login-password --region ca-central-1 | docker login --username AWS --password-stdin 570028955216.dkr.ecr.ca-central-1.amazonaws.com
docker build -t 570028955216.dkr.ecr.ca-central-1.amazonaws.com/dashboard:latest .
docker push 570028955216.dkr.ecr.ca-central-1.amazonaws.com/dashboard:latest

# 2. Update ECS service
aws ecs update-service \
    --cluster dashboard-cluster \
    --service dashboard-service-auto \
    --force-new-deployment \
    --region ca-central-1
```

### GitHub Actions Deployment
Push to the `develop` branch to trigger automatic deployment.

## Troubleshooting

### Common Issues

#### 1. "Input required and not supplied: task-definition"
- ✅ **Fixed**: Updated `task-definition.json` with proper format
- ✅ **Fixed**: Removed invalid/empty fields

#### 2. Service Won't Start
```bash
# Check service events
aws ecs describe-services \
    --cluster dashboard-cluster \
    --services dashboard-service-auto \
    --region ca-central-1

# Check task logs
aws logs get-log-events \
    --log-group-name "/ecs/dashboard-sensor" \
    --log-stream-name "ecs/dashboard-container/TASK-ID" \
    --region ca-central-1
```

#### 3. Health Check Failures
- Ensure your app responds on port 8000
- Health check path is `/` (root path)
- Container must bind to `0.0.0.0:8000`, not `localhost:8000`

#### 4. Container Can't Pull Image
- Verify ECR repository exists
- Check IAM permissions for `ecsTaskExecutionRole`
- Confirm image was pushed successfully

### Verification Commands
```bash
# Check cluster status
aws ecs describe-clusters --clusters dashboard-cluster --region ca-central-1

# Check service status
aws ecs describe-services --cluster dashboard-cluster --services dashboard-service-auto --region ca-central-1

# Check running tasks
aws ecs list-tasks --cluster dashboard-cluster --service-name dashboard-service-auto --region ca-central-1

# Get task details
aws ecs describe-tasks --cluster dashboard-cluster --tasks TASK-ARN --region ca-central-1
```

## Access Your Application

Once deployed successfully:

### Direct ECS Access (if public IP assigned)
- Find task public IP in ECS console
- Access: `http://TASK-PUBLIC-IP:8000`

### Through Load Balancer (recommended)
- Access: `http://YOUR-ALB-DNS-NAME`
- API: `http://YOUR-ALB-DNS-NAME/current`
- Stream: `http://YOUR-ALB-DNS-NAME/stream`

## Next Steps

1. **Set up ALB** for production traffic
2. **Configure custom domain** with Route 53
3. **Add SSL certificate** for HTTPS
4. **Set up monitoring** with CloudWatch alarms
5. **Configure auto-scaling** based on CPU/memory

Your FastAPI dashboard is now ready for ECS Fargate deployment! 🎉