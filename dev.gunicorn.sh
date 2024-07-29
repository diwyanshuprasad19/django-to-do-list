#!/bin/bash
# Name of the application
NAME="django-to-do-list"
# Django project directory
DJANGODIR=/home/ubuntu/django-to-do-list
# Unix socket file used for communication
SOCKFILE=/home/ubuntu/django-to-do-list/run/gunicorn.sock
# Number of worker processes for handling requests
NUM_WORKERS=3
# Settings module for Django
DJANGO_SETTINGS_MODULE=todo_list.settings
# WSGI module name
DJANGO_WSGI_MODULE=todo_list.wsgi
# Log level
LOG_LEVEL=info

# Print starting message
echo "Starting $NAME as `whoami`"
# Activate the virtual environment
cd $DJANGODIR
source /home/ubuntu/.pyenv/versions/3.12.1/envs/myenv/bin/activate
# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR
# Start Gunicorn
exec /home/ubuntu/.pyenv/versions/3.12.1/envs/myenv/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --bind unix:$SOCKFILE \
  --log-level=$LOG_LEVEL \
  --access-logfile "/home/ubuntu/logs/practice/access.log" \
  --error-logfile "/home/ubuntu/logs/practice/error.log" \
  --timeout=60 \
  --max-requests=500

