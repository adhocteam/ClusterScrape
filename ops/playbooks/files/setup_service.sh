export APP_NAME=cluster_scrape

mkdir -p "/etc/sv/$APP_NAME"

# Logging configuration
mkdir -p "/etc/sv/$APP_NAME/log"
mkdir -p "/var/log/$APP_NAME"
mkdir -p "/etc/sv/$APP_NAME/env"


export COOKIE=cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1

echo $COOKIE > /etc/sv/$APP_NAME/env/COOKIE
echo "4000" > /etc/sv/$APP_NAME/env/PORT
echo $RELEASE_HASH > /etc/sv/$APP_NAME/env/RELEASE_HASH
echo "/home/$APP_NAME" > /etc/sv/$APP_NAME/env/HOME

# Create the logging run script
cat << EOF > /etc/sv/$APP_NAME/log/run
#!/bin/sh
exec svlogd -tt /var/log/$APP_NAME
EOF

# Mark the log/run file executable
chmod +x /etc/sv/$APP_NAME/log/run

adduser $APP_NAME

chown -R $APP_NAME:$APP_NAME /opt/$APP_NAME

# Create the run script for the app
cat << EOF > /etc/sv/$APP_NAME/run
#!/bin/bash
exec 2>&1 chpst -u $APP_NAME -e /etc/sv/$APP_NAME/env /opt/$APP_NAME/bin/$APP_NAME foreground
EOF

# Mark the run file executable
chmod +x /etc/sv/$APP_NAME/run

# Create a link from /etc/service/$APP_NAME -> /etc/sv/$APP_NAME
ln -s /etc/sv/$APP_NAME /etc/service/$APP_NAME
