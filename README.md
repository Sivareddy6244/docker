# docker

# (If you haven't already) Build the image from your Dockerfile

docker tag my-app:latest mycompany.jfrog.io/artifactory/my-docker-virtual/my-app:latest

docker login mycompany.jfrog.io

docker push mycompany.jfrog.io/artifactory/my-docker-virtual/my-app:latest






COPY liquibase-5.0.1.tar.gz .
RUN mkdir -p /opt/liquibase && \
    tar -xzf liquibase-5.0.1.tar.gz -C /opt/liquibase && \
    rm liquibase-5.0.1.tar.gz


COPY jarfiles/*.jar /opt/liquibase/lib/

# Make Liquibase globally executable
RUN ln -s /opt/liquibase/liquibase /usr/local/bin/liquibase















docker build -t my-liquibase-jdk:latest .


docker run --rm my-liquibase-jdk:latest liquibase --version


docker run --rm my-liquibase-jdk:latest java -version
