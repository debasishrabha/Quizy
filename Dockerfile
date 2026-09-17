# Base operating system
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    python3

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter

# Add Flutter to PATH
ENV PATH="/flutter/bin:${PATH}"

# Enable Flutter web
RUN flutter config --enable-web

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Install Flutter dependencies
RUN flutter pub get

# Build Flutter web app
RUN flutter build web

# Expose web port
EXPOSE 8080

# Run web server
CMD ["python3", "-m", "http.server", "8080", "--directory", "build/web"]
