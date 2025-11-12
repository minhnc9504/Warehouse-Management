#!/bin/bash
set -e

echo "=== Simple WAR Build Script ==="

# Create dist directory
mkdir -p dist

# Create build directories
mkdir -p build/web/WEB-INF/classes
mkdir -p build/web/WEB-INF/lib

echo "Copying web files..."
# Copy web files
cp -r web/* build/web/ 2>/dev/null || true

echo "Compiling Java sources..."
# Find Tomcat for classpath
TOMCAT_HOME=$(find /nix/store -type d -name "apache-tomcat*" | head -1)
if [ -z "$TOMCAT_HOME" ]; then
    TOMCAT_HOME=$(find /nix/store -name "catalina.sh" -type f | head -1 | xargs dirname | xargs dirname)
fi

if [ -z "$TOMCAT_HOME" ]; then
    echo "ERROR: Tomcat not found!"
    exit 1
fi

echo "Using Tomcat at: $TOMCAT_HOME"

# Build classpath
CLASSPATH="$TOMCAT_HOME/lib/*"
for jar in lib/*.jar; do
    if [ -f "$jar" ]; then
        CLASSPATH="$CLASSPATH:$jar"
    fi
done

# Compile Java files
find src/java -name "*.java" > /tmp/sources.txt
if [ -s /tmp/sources.txt ]; then
    javac -d build/web/WEB-INF/classes \
          -cp "$CLASSPATH" \
          -sourcepath src/java \
          @/tmp/sources.txt 2>&1 | head -50 || {
        echo "Compilation errors (showing first 50 lines):"
        javac -d build/web/WEB-INF/classes \
              -cp "$CLASSPATH" \
              -sourcepath src/java \
              @/tmp/sources.txt 2>&1 | head -50
        exit 1
    }
    echo "Compilation successful!"
else
    echo "No Java sources found"
fi

echo "Copying libraries..."
# Copy libraries
cp lib/*.jar build/web/WEB-INF/lib/ 2>/dev/null || true

echo "Creating WAR file..."
# Create WAR file
cd build/web
jar cf ../../dist/Warehouse.war *
cd ../..

if [ -f "dist/Warehouse.war" ]; then
    echo "WAR file created successfully: dist/Warehouse.war"
    ls -lh dist/Warehouse.war
else
    echo "ERROR: Failed to create WAR file"
    exit 1
fi

echo "=== Build completed ==="

