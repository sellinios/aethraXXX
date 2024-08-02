#!/bin/bash
set -e

# Define PostgreSQL credentials
PGUSER="postgres"
PGPASSWORD="faidra6946020623"  # Password for 'postgres' user and new superuser
PGHOST="localhost"  # Adjust if needed for your Docker setup

# Export credentials as environment variables
export PGPASSWORD=$PGPASSWORD

# Wait for PostgreSQL to start
echo "Waiting for PostgreSQL to start..."
until pg_isready -U $PGUSER -h $PGHOST; do
  sleep 1
done

# Create or update the superuser 'sellinios'
echo "Creating or updating superuser 'sellinios'..."
psql -U $PGUSER -h $PGHOST <<-EOSQL
    DO \$
    BEGIN
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'sellinios') THEN
            ALTER USER sellinios WITH SUPERUSER PASSWORD 'faidra6946020623';
        ELSE
            CREATE USER sellinios WITH SUPERUSER PASSWORD 'faidra6946020623';
        END IF;
    END
    \$
EOSQL

# Optionally, create a new database and grant privileges
echo "Creating database 'aethradb' and granting privileges..."
psql -U $PGUSER -h $PGHOST <<-EOSQL
    DO \$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'aethradb') THEN
            CREATE DATABASE aethradb;
        END IF;
    END
    \$
EOSQL

# Grant all privileges to 'sellinios' on 'aethradb'
echo "Granting privileges on 'aethradb' to 'sellinios'..."
psql -U $PGUSER -h $PGHOST <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE aethradb TO sellinios;
EOSQL

# Optionally, set the password for the 'postgres' user if needed
echo "Updating password for 'postgres' user..."
psql -U $PGUSER -h $PGHOST <<-EOSQL
    ALTER USER postgres WITH PASSWORD 'faidra6946020623';
EOSQL

echo "Setup completed successfully."
