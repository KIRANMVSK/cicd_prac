# GitHub Actions Environments

## 1. What is an Environment?

- An Environment is a GitHub repository-level deployment configuration.
- It represents a deployment target or stage of an application.
- It helps manage environment-specific secrets, variables, and deployment protection rules.
- It is not a physical or virtual machine.

### Common Environments
1. Development – Used for development and testing.
2. Staging – Used for pre-production testing.
3. Production – Used for deploying the live application.

## 2. Why do we use Environments?

- To maintain separate configurations for different deployment stages.
- To store environment-specific secrets and variables.
- To restrict which branches or tags can deploy.
- To implement manual approval before production deployment.
- To prevent accidental or unauthorized production deployments.

## 3. Important Environment Features

### A. Environment Secrets
- Used to store sensitive information.
- Examples: DB_PASSWORD, API_TOKEN, AWS_ROLE_ARN.
- Accessible to jobs that reference the corresponding environment.
- Secrets are protected and should never be printed in workflow logs.

### B. Environment Variables
- Used to store non-sensitive configuration values.
- Examples: APP_ENV, APP_PORT, AWS_REGION.
- Can have different values for different environments.
- Accessed using `${{ vars.VARIABLE_NAME }}`.

### C. Required Reviewers
- Used to implement manual approval for deployments.
- Example: Production deployment waits until an authorized reviewer approves it.
- Helps protect critical deployment environments.

### D. Deployment Branches and Tags
- Controls which branches or tags are allowed to deploy to an environment.
- Example:
  - Development → develop
  - Staging → release/*
  - Production → main

## 4. Connecting an Environment to a Job

Use the `environment` keyword inside a job.

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production

    steps:
      - name: Deploy application
        run: echo "Deploying to production"
```

- `environment: production` connects the job to the GitHub Environment named production.
- GitHub applies the environment's protection rules.
- After required protection rules pass, the job can access its environment secrets and variables.

## 5. Accessing Environment Secrets and Variables

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production

    steps:
      - name: Display environment
        run: echo "Deploying to ${{ vars.APP_ENV }}"

      - name: Use database password
        env:
          DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
        run: echo "Using database credentials"
```

- `${{ vars.VARIABLE_NAME }}` → Access environment variables.
- `${{ secrets.SECRET_NAME }}` → Access environment secrets.

## 6. Multiple Environments in a Single Pipeline

Example: Development → Staging → Production.

```yaml
jobs:
  development:
    runs-on: ubuntu-latest
    environment: development
    steps:
      - run: echo "Deploying to Development"

  staging:
    runs-on: ubuntu-latest
    needs: development
    environment: staging
    steps:
      - run: echo "Deploying to Staging"

  production:
    runs-on: ubuntu-latest
    needs: staging
    environment: production
    steps:
      - run: echo "Deploying to Production"
```

### Important Keywords

**environment:**
- Connects a job to a GitHub Environment.
- Provides access to environment-specific configuration and protection rules.

**needs:**
- Defines job dependencies.
- Controls execution order.
- A job runs only after its required dependencies complete successfully.

## 7. Important Difference

| Keyword | Responsibility |
|---|---|
| environment | Environment-specific configuration and deployment protection |
| needs | Job execution order and dependencies |
| secrets | Stores sensitive information |
| vars | Stores non-sensitive configuration |
| Required reviewers | Manual deployment approval |
| Deployment branches | Restricts eligible branches and tags |

### Key Takeaways

- Environments help manage different deployment stages.
- Each environment can have its own secrets, variables, and protection rules.
- `environment` connects a job to an environment.
- `needs` controls the execution sequence between jobs.
- Production environments can require manual approval.
- Environments and OIDC can work together to provide secure cloud deployments.