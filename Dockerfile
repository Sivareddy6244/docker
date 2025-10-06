
FROM jfrog-registry.mycompany.com/liquibase/liquibase:4.25 AS base


USER root

# Set environment variables for the Java installation.
# Using OpenJDK 17 as an example. Adjust the version as needed.
ENV JAVA_VERSION=17
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"


RUN if [ -x "$(command -v apk)" ]; then \
      # Alpine Linux
      echo "Detected Alpine Linux. Installing OpenJDK with apk." && \
      apk add --no-cache openjdk${JAVA_VERSION}; \
    elif [ -x "$(command -v apt-get)" ]; then \
      # Debian/Ubuntu
      echo "Detected Debian-based Linux. Installing OpenJDK with apt-get." && \
      apt-get update && \
      apt-get install -y --no-install-recommends openjdk-${JAVA_VERSION}-jdk ca-certificates && \
      # Clean up the apt cache to reduce image size
      rm -rf /var/lib/apt/lists/*; \
    else \
      echo "Error: Unsupported package manager. Neither apk nor apt-get found." >&2; \
      exit 1; \
    fi

# Verify the installation
RUN java -version
RUN javac -version


USER liquibase

# Set the working directory (optional, but good practice)
WORKDIR /liquibase/changelogs


