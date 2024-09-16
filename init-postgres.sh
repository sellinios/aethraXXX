#!/bin/bash
set -e

# This script runs inside the PostgreSQL container during initialization.
# Environment variables are provided by Docker.

echo "Initializing PostgreSQL and PostGIS..."

# Create the 'sellinios' user and 'aethradb' database if they don't exist
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    -- Create database if it doesn't exist
    SELECT 'CREATE DATABASE $POSTGRES_DB'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$POSTGRES_DB')\gexec

    -- Create user if it doesn't exist
    DO \$$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$POSTGRES_USER') THEN
            CREATE ROLE $POSTGRES_USER LOGIN PASSWORD '$POSTGRES_PASSWORD';
        END IF;
    END
    \$$;

    -- Grant privileges
    GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
EOSQL

# Create PostGIS extension in the database
echo "Creating PostGIS extension in database '$POSTGRES_DB'..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS postgis;
EOSQL

echo "PostgreSQL and PostGIS initialization completed successfully."
