

USER root

# Set environment variables for the Java installation.
# Using OpenJDK 17 as an example. Adjust the version as needed.

# Install JDK and dynamically set JAVA_HOME in a single layer.
# This is more robust than hardcoding paths as it finds the actual installation directory.
RUN if [ -x "$(command -v apk)" ]; then \
      # Alpine Linux
      echo "Detected Alpine Linux. Installing OpenJDK with apk." && \
      apk add --no-cache openjdk17 && \
      export JAVA_HOME=/usr/lib/jvm/java-17-openjdk && \
      echo "export JAVA_HOME=${JAVA_HOME}" > /etc/profile.d/jdk.sh && \
      echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/jdk.sh; \
    elif [ -x "$(command -v apt-get)" ]; then \
      # Debian/Ubuntu
      echo "Detected Debian-based Linux. Installing OpenJDK with apt-get." && \
      apt-get update && \
      apt-get install -y --no-install-recommends openjdk-17-jdk ca-certificates && \
      export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) && \
      echo "export JAVA_HOME=${JAVA_HOME}" > /etc/profile.d/jdk.sh && \
      echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/jdk.sh && \
      rm -rf /var/lib/apt/lists/*; \
    else \
      echo "Error: Unsupported package manager. Neither apk nor apt-get found." >&2; \
      exit 1; \
    fi

# Verify the installation
# The profile script is sourced automatically by the shell.
RUN . /etc/profile && java -version && javac -version && liquibase --version

USER liquibase

# Set the working directory (optional, but good practice)
WORKDIR /liquibase/changelogs
