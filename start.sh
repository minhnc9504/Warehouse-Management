#!/bin/bash
set -e

# Find Tomcat installation in Nix store
TOMCAT_HOME=$(find /nix/store -type d -name "apache-tomcat*" | head -1)
if [ -z "$TOMCAT_HOME" ]; then
    TOMCAT_HOME=$(find /nix/store -name "catalina.sh" -type f | head -1 | xargs dirname | xargs dirname)
fi

if [ -z "$TOMCAT_HOME" ]; then
    echo "ERROR: Tomcat not found!"
    exit 1
fi

export CATALINA_HOME=$TOMCAT_HOME
export CATALINA_BASE=$PWD

# Create necessary directories
mkdir -p logs temp work conf

# Copy server.xml if needed
if [ ! -f conf/server.xml ]; then
    cp $CATALINA_HOME/conf/server.xml conf/server.xml 2>/dev/null || true
fi

# Set port from Railway environment variable
export PORT=${PORT:-8080}

# Update server.xml to use PORT (if file exists)
if [ -f conf/server.xml ]; then
    sed -i "s/8080/$PORT/g" conf/server.xml 2>/dev/null || true
fi

# Start Tomcat
echo "Starting Tomcat from $CATALINA_HOME on port $PORT"
exec $CATALINA_HOME/bin/catalina.sh run

