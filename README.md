# docker

# (If you haven't already) Build the image from your Dockerfile

docker tag my-app:latest mycompany.jfrog.io/artifactory/my-docker-virtual/my-app:latest

docker login mycompany.jfrog.io

docker push mycompany.jfrog.io/artifactory/my-docker-virtual/my-app:latest





















docker build -t my-liquibase-jdk:latest .


docker run --rm my-liquibase-jdk:latest liquibase --version


docker run --rm my-liquibase-jdk:latest java -version
