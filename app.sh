#!/usr/bin/env bash

cat <<EOT
My connection info is:

  username: "${DATABASE_CREDS_MYSQLROLE_USERNAME}"
  password: "${DATABASE_CREDS_MYSQLROLE_PASSWORD}"
  database: "my-app"
EOT