#!/usr/bin/env bash
set -e

echo "Waiting for postgres to connect ..."

python manage.py migrate
python manage.py collectstatic --noinput

python manage.py shell << EOF
from django.contrib.auth import get_user_model

User = get_user_model()

user, created = User.objects.get_or_create(
    username="${SUPERUSER_USERNAME}",
    defaults={
        "email": "${SUPERUSER_EMAIL}",
        "is_staff": True,
        "is_superuser": True,
    }
)

user.is_staff = True
user.is_superuser = True
user.set_password("${SUPERUSER_PASSWORD}")
user.save()
EOF

exec gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8000