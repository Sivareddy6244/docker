# Custom Liquibase Docker Image

## Overview

This project provides the `Dockerfile` and CI/CD configuration to build a custom Docker image for Liquibase. The purpose of this image is to provide a standardized, ready-to-use environment for running database migrations within our organization's GitLab CI/CD pipelines.

The image is built on a standard UBI 8 base with OpenJDK 21 and includes:
- Liquibase Core
- Pre-installed Azure SQL Server JDBC drivers and other necessary dependencies.

The resulting Docker image is pushed to our JFrog Artifactory instance and is intended to be used as the base image for Liquibase jobs in other projects.

## Project Structure

```
.
├── .gitlab-ci.yml      # GitLab CI pipeline to build and publish the Docker image
├── Dockerfile          # The Dockerfile for building the image
└── dependencies/
    ├── liquibase-5.0.1.tar.gz  # Liquibase distribution tarball
    └── *.jar                   # JDBC drivers and other JAR dependencies (e.g., for Azure SQL)
```

## Prerequisites

To build or update this image, you will need:
- Docker installed on your local machine or a GitLab runner with Docker capabilities.
- Access to the organization's Artifactory (`artifactory-saas.mtb.com`) to pull the base image.

### Managing Dependencies

The `dependencies/` directory is used to hold all required files that need to be bundled into the image.

- **Liquibase**: To update Liquibase, download the official `.tar.gz` distribution from the Liquibase GitHub Releases and place it in this directory. Remember to update the version number in the `Dockerfile`.
- **JDBC Drivers**: Place any required JDBC driver JAR files (e.g., `mssql-jdbc-*.jar` for Azure SQL) in this directory. All `.jar` files in this folder will be automatically copied to the `/opt/liquibase/lib` directory inside the image.

## Building the Image

### Local Build

To build the image on your local machine for testing, run the following command from the project root:

```bash
docker build -t liquibase-custom:latest .
```

You can test the image by checking the Liquibase version:

```bash
docker run --rm liquibase-custom:latest liquibase --version
```

### CI/CD Build (GitLab)

The image is automatically built and published to JFrog Artifactory on every push to the `main` branch via the `.gitlab-ci.yml` pipeline. The image is tagged with the pipeline ID and can be found at:

`trialc3rjn9.jfrog.io/liquibase-docker/jfrog-docker-example-image:$CI_PIPELINE_ID`

## How to Use This Image in Your Project

To use this image for running Liquibase commands in your own project's GitLab CI/CD pipeline, simply reference it in the `image` key of your job definition.

Below is an example `.gitlab-ci.yml` snippet for a project that needs to run a Liquibase database update.

**Example `gitlab-ci.yml` in a downstream project:**

```yaml
stages:
  - deploy

deploy-db-changes:
  stage: deploy
  # Use the custom Liquibase image from Artifactory
  image: trialc3rjn9.jfrog.io/liquibase-docker/jfrog-docker-example-image:123 # <-- Use the specific image tag/ID
  script:
    - echo "Running Liquibase migrations..."
    - liquibase --url="jdbc:sqlserver://<your-server>.database.windows.net:1433;database=<your-db>" \
                --username="$DB_USERNAME" \
                --password="$DB_PASSWORD" \
                --changeLogFile=changelog.xml \
                update
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

**Note:** Ensure you have configured the necessary CI/CD variables (`DB_USERNAME`, `DB_PASSWORD`) in your project's settings for secure credential management.
