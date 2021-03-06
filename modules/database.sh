#!/usr/bin/env bash

database_drop_user ()
{
    heading "Dropping Database User..."

    sudo -u postgres dropuser --if-exists "$KAPU_DB_USERNAME" | tee -a "$commander_log"

    success "Dropped Database User!"
}

database_destroy ()
{
    heading "Destroying Database..."

    sudo -u postgres dropdb --if-exists "$KAPU_DB_DATABASE" | tee -a "$commander_log"

    success "Destroyed Database!"
}

database_create ()
{
    heading "0Creating Database..."

#    wait_to_continue

    # needed to avoid "could not connect to database template1" errors
    heading "Creating Database..."

    sudo -u postgres psql -c "CREATE USER $USER WITH PASSWORD 'password' CREATEDB;" | tee -a "$commander_log"

    sudo -u postgres psql -c "CREATE USER $KAPU_DB_USERNAME WITH PASSWORD '$KAPU_DB_PASSWORD' CREATEDB;" | tee -a "$commander_log"
    
    sudo -u postgres createdb "$KAPU_DB_DATABASE"

    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $KAPU_DB_DATABASE TO $KAPU_DB_USERNAME;" | tee -a "$commander_log"

    wait_to_continue

#    createdb "$KAPU_DB_DATABASE" | tee -a "$commander_log"

    success "Created Database!"
}
