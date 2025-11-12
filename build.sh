#!/bin/bash
set -e

# Find Tomcat installation in Nix store
echo "Searching for Tomcat installation..."
TOMCAT_HOME=$(find /nix/store -type d -name "apache-tomcat*" | head -1)

if [ -z "$TOMCAT_HOME" ]; then
    echo "Trying alternative method to find Tomcat..."
    TOMCAT_HOME=$(find /nix/store -name "catalina.sh" -type f | head -1 | xargs dirname | xargs dirname)
fi

if [ -z "$TOMCAT_HOME" ]; then
    echo "ERROR: Tomcat not found in /nix/store!"
    echo "Available Tomcat-related files:"
    find /nix/store -name "*tomcat*" -o -name "*catalina*" | head -10
    exit 1
fi

echo "Found Tomcat at: $TOMCAT_HOME"
echo "Building WAR file with j2ee.server.home=$TOMCAT_HOME"

# Build WAR file with Tomcat home directory
ant -Dj2ee.server.home="$TOMCAT_HOME" dist

echo "Build completed successfully!"

