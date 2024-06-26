#!/bin/sh
if [ -e /app/db/db.sqlite3 ]
then
    echo "Starting..."
else
    echo "Initializing..."
    python manage.py makemigrations
    python manage.py migrate
    python manage.py creatersakey
	python manage.py createsuperuser --noinput
    if [ -n "$INITIAL_DATA" ]
    then
        python manage.py loaddata /app/$INITIAL_DATA
    fi
    echo "Initialization complete! Starting..."
fi

python manage.py collectstatic --noinput
python manage.py migrate
exec gunicorn oidc_server.wsgi:application -w 2 -b :8000