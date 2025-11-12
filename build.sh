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

# Verify Tomcat structure
if [ ! -f "$TOMCAT_HOME/lib/catalina.jar" ]; then
    echo "WARNING: catalina.jar not found at $TOMCAT_HOME/lib/catalina.jar"
    echo "Tomcat lib directory contents:"
    ls -la "$TOMCAT_HOME/lib/" | head -10 || true
fi

# Try simple build first, fallback to NetBeans build
echo "Attempting simple build (build-simple.xml)..."
if [ -f "build-simple.xml" ]; then
    if ant -f build-simple.xml -Dj2ee.server.home="$TOMCAT_HOME" dist 2>&1; then
        echo "Simple build completed successfully!"
        if [ -f "dist/Warehouse.war" ]; then
            echo "WAR file created: dist/Warehouse.war"
            ls -lh dist/Warehouse.war
            exit 0
        fi
    else
        echo "Simple build failed, trying NetBeans build..."
        echo "Simple build errors shown above"
    fi
fi

# Build WAR file with Tomcat home directory (verbose mode)
echo "Starting NetBeans Ant build..."
if ant -Dj2ee.server.home="$TOMCAT_HOME" -verbose dist 2>&1; then
    echo "Build completed successfully!"
    
    # Verify WAR file was created
    if [ -f "dist/Warehouse.war" ]; then
        echo "WAR file created: dist/Warehouse.war"
        ls -lh dist/Warehouse.war
    else
        echo "ERROR: WAR file not found at dist/Warehouse.war"
        echo "Contents of dist directory:"
        ls -la dist/ || echo "dist directory does not exist"
        exit 1
    fi
else
    echo "ERROR: Ant build failed!"
    echo "Last 50 lines of build output:"
    exit 1
fi

