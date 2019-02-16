FROM ubuntu:bionic

RUN apt-get update -y && apt-get install -y git python-pip curl iproute2 && \
    git clone https://gitlab.com/k3oni/pydash.git && cd pydash && \
    pip install -r requirements.txt && \
    sed -i "s/SECRET_KEY.*/SECRET_KEY = 'password'/g" pydash/settings.py && \
    python manage.py syncdb --noinput && \
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'myemail@example.com', 'password')" | python manage.py shell

WORKDIR pydash
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

EXPOSE 8000
