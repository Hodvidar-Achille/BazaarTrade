#!/bin/bash
set -e

# Wait for MySQL
./wait-for-it.sh bazaartrade-mysql-v1:3306 --strict --timeout=300 -- echo "MySQL is up"

# Run App
exec java -jar app.jar
