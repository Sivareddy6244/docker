# docker

# (If you haven't already) Build the image from your Dockerfile
docker build -t my-liquibase-jdk:latest .


docker run --rm my-liquibase-jdk:latest liquibase --version


docker run --rm my-liquibase-jdk:latest java -version
