# Use the official Liquibase image as base
FROM docker.io/library/liquibase AS base

USER root

# Install OpenJDK 17 depending on base distro (Liquibase images are Debian-based)
RUN if [ -x "$(command -v apk)" ]; then \
      echo "Detected Alpine Linux. Installing OpenJDK 17 with apk..." && \
      apk add --no-cache openjdk17; \
    elif [ -x "$(command -v apt-get)" ]; then \
      echo "Detected Debian/Ubuntu. Installing OpenJDK 17 with apt-get..." && \
      apt-get update && \
      apt-get install -y --no-install-recommends openjdk-17-jdk ca-certificates && \
      rm -rf /var/lib/apt/lists/*; \
    else \
      echo "Error: Unsupported package manager (neither apk nor apt-get found)." >&2; \
      exit 1; \
    fi

# --- Override Java version environment from Liquibase base image (which uses Java 21) ---
# Adjust for Debian/Ubuntu (liquibase official images use Debian by default)
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# (Optional) Verify that the correct Java version is active
RUN echo "Verifying Java version..." && \
    echo "JAVA_HOME=${JAVA_HOME}" && \
    which java && java -version && javac -version && \
    echo "Liquibase version:" && liquibase --version

# Switch back to liquibase user (non-root for best practice)
USER liquibase

# Set default working directory
WORKDIR /liquibase/changelogs
