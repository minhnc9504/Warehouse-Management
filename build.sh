#!/bin/bash
set -e
set -x  # Enable debug output

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
echo "=== Attempting simple build (build-simple.xml) ==="
if [ -f "build-simple.xml" ]; then
    echo "build-simple.xml found, running Ant..."
    if ant -f build-simple.xml -Dj2ee.server.home="$TOMCAT_HOME" dist; then
        echo "Simple build completed successfully!"
        if [ -f "dist/Warehouse.war" ]; then
            echo "WAR file created: dist/Warehouse.war"
            ls -lh dist/Warehouse.war
            echo "=== Build successful, exiting ==="
            exit 0
        else
            echo "ERROR: WAR file not created after successful build!"
            ls -la dist/ || echo "dist directory does not exist"
        fi
    else
        BUILD_EXIT_CODE=$?
        echo "Simple build failed with exit code: $BUILD_EXIT_CODE"
        echo "Trying NetBeans build..."
    fi
else
    echo "build-simple.xml not found, skipping simple build"
fi

# Build WAR file with Tomcat home directory (verbose mode)
echo "=== Starting NetBeans Ant build ==="
echo "Setting j2ee.server.home=$TOMCAT_HOME"
echo "Current directory: $(pwd)"
echo "Files in current directory:"
ls -la | head -20

if ant -Dj2ee.server.home="$TOMCAT_HOME" -Djavac.source=17 -Djavac.target=17 dist; then
    echo "NetBeans build completed successfully!"
    
    # Verify WAR file was created
    if [ -f "dist/Warehouse.war" ]; then
        echo "WAR file created: dist/Warehouse.war"
        ls -lh dist/Warehouse.war
        echo "=== Build successful ==="
        exit 0
    else
        echo "ERROR: WAR file not found at dist/Warehouse.war"
        echo "Contents of dist directory:"
        ls -la dist/ || echo "dist directory does not exist"
        echo "Contents of build directory:"
        ls -la build/ 2>/dev/null || echo "build directory does not exist"
        exit 1
    fi
else
    BUILD_EXIT_CODE=$?
    echo "ERROR: Ant build failed with exit code: $BUILD_EXIT_CODE"
    echo "=== Build failed ==="
    exit 1
fi

