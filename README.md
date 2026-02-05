## Signs for Trucks

This project was created as part of a DevSecOps training to demonstrate how a Django backend can be containerized using Docker.  
The focus is on running the application and its PostgreSQL database in separate containers, <br>
started via Docker CLI commands (without docker-compose), and configured through environment variables.

![Python version](https://img.shields.io/badge/Pythn-3.8.10-4c566a?logo=python&&longCache=true&logoColor=white&colorB=pink&style=flat-square&colorA=4c566a) ![Django version](https://img.shields.io/badge/Django-2.2.8-4c566a?logo=django&&longCache=truelogoColor=white&colorB=pink&style=flat-square&colorA=4c566a) ![Django-RestFramework](https://img.shields.io/badge/Django_Rest_Framework-3.12.4-red.svg?longCache=true&style=flat-square&logo=django&logoColor=white&colorA=4c566a&colorB=pink)


## Table of contents
1. [Prerequisites](#prerequisites)
2. [Quickstart](#quickstart)
3. [Project Structure](#project-structure)
4. [Usage](#usage)
5. [Docker commands](#docker-commands)
6. [Logs](#logs)
7. [Screenshots of the Django Backend Admin Panel](#screenshots-of-the-django-backend-admin-panel)
8. [Useful Links](#useful-links)
9. [Author](#author)


## Prerequisites
Before running this project, ensure you have:

- **Docker** installed  
- **Docker Compose** installed 

## Quickstart
Clone the repository from GitHub
```bash
git clone git@github.com:EnsslinAdrian/Conduit-Orchestrator.git conduit-orchestrator
```

Navigate to the folder
```bash
cd conduit-orchestrator
```

Create .env
```bash
cd truck_signs_designs/settings
cp .env.template .env
```
> [!CAUTION]
> The `.env` file contains dummy variables.

Generate a Django secret key:
```bash
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

> [!NOTE]
> Paste the generated key into your `.env`.


Create Docker network

``` bash
docker network create truck_signs
```

Start PostgreSQL container

``` bash
docker run -d \
  --name db \
  --network truck_signs \
  -e POSTGRES_DB=<DB_NAME> \
  -e POSTGRES_USER=<DB_USER> \
  -e POSTGRES_PASSWORD=<DB_PASSWORD> \
  -v db_data:/var/lib/postgresql/data \
  --restart on-failure:5 \
  postgres:15-alpine
```

Build backend image

``` bash
docker build -t truck-signs-backend .
```

Run backend container

``` bash
docker run -d \
  --name backend \
  --network truck_signs \
  --env-file <PATH_TO_ENV_FILE> \
  -p 8020:8000 \
  -v backend_media:/app/media \
  --restart on-failure:5 \
  truck-signs-backend
```

The API is available at:

    http://<YOUR_IP>:8020

The Django Admin interface is available at:

    http://<YOUR_IP>:8020/admin/


## Project Structure
```
|--| 📁 backend
|  |-- 📄 admin.py
|  |-- 📄 apps.py
|  |-- 📄 forms.py
|  |-- 📄 models.py
|  |-- 📄 serializers.py
|  |-- 📄 test.py
|  |-- 📄 urls.py
|  |-- 📄 views.py
|
|-- 📁 screenshots
|
|--| 📁 templates
|  |--| 📁 admin
|     |-- 📄 base_site.html
|  |-- 📄 admin-purchase-made.html
|  |-- 📄 base.html
|  |-- 📄 purchase-made.html
|
|--| 📁 truck_signs_desing
|--|--|📁 settings
|     |-- ⚙️ .env
|     |-- ⚙️ .env.template
|     |-- 📄 base.py
|     |-- 📄 dev.py
|     |-- 📄 production.py
|     |-- 📄 test_docker.py
|  |-- 📄 urls.py
|  |-- 📄 wsgi.py
|
|-- 📄 .dockerignore
|-- 📄 .gitignore
|-- 📄 Dockerfile
|-- 📄 entrypoint.sh
|-- 📄 manage.py
|-- 📄 Procfile
|-- ℹ️ README.md
|-- 📄 requirements.txt
```


### Usage

#### Environment Configuration

The application is configured via environment variables provided through
an external `.env` file.

Required variables: - `SECRET_KEY` - `DB_NAME` - `DB_USER` -
`DB_PASSWORD` - `DB_HOST` - `DB_PORT` - `SUPERUSER_USERNAME` -
`SUPERUSER_EMAIL` - `SUPERUSER_PASSWORD`

Optional variables: - Stripe configuration - Email configuration -
Cloudinary configuration

#### Application Startup

On container startup, the following steps are executed automatically: -
Database availability check - `collectstatic` - `makemigrations` -
`migrate` - Non-interactive `createsuperuser` - Startup of the Gunicorn
WSGI application

The Django development server is **not used**.


## Docker commands
Stop containers
```bash
docker stop backend db
```

Remove containers
```bash
docker rm backend db
```

Remove containers and volumes
```bash
docker rm -f backend db
docker volume rm db_data backend_media
```

Restart containers
```bash
docker restart backend db
```

Check running containers
```bash
docker ps
```


## Logs
Logs of running containers can be viewed directly via the Docker CLI.

View logs
```bash
docker logs <container-name>
```

View logs
```bash
docker logs <container-name>
```

View logs live
```bash
docker logs -f <container-name>
```

Save logs to a file
```bash
docker logs <container-name> > <container-name>-logs.txt
```

## Screenshots of the Django Backend Admin Panel

### Mobile View

<div align="center">

![alt text](./screenshots/Admin_Panel_View_Mobile.png)  ![alt text](./screenshots/Admin_Panel_View_Mobile_2.png) ![alt text](./screenshots/Admin_Panel_View_Mobile_3.png)

</div>
---

### Desktop View

![alt text](./screenshots/Admin_Panel_View.png)

---

![alt text](./screenshots/Admin_Panel_View_2.png)

---

![alt text](./screenshots/Admin_Panel_View_3.png)



<a name="useful_links"></a>
## Useful Links

### Postgresql Database
- Setup Database: [Digital Ocean Link for Django Deployment on VPS](https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-16-04)

### Docker
- [Docker Oficial Documentation](https://docs.docker.com/)
- Dockerizing Django, PostgreSQL, guinicorn, and Nginx:
    - Github repo of sunilale0: [Link](https://github.com/sunilale0/django-postgresql-gunicorn-nginx-dockerized/blob/master/README.md#nginx)
    - Michael Herman article on testdriven.io: [Link](https://testdriven.io/blog/dockerizing-django-with-postgres-gunicorn-and-nginx/)

### Django and DRF
- [Django Official Documentation](https://docs.djangoproject.com/en/4.0/)
- Generate a new secret key: [Stackoverflow Link](https://stackoverflow.com/questions/41298963/is-there-a-function-for-generating-settings-secret-key-in-django)
- Modify the Django Admin:
    - Small modifications (add searching, columns, ...): [Link](https://realpython.com/customize-django-admin-python/)
    - Modify Templates and css: [Link from Medium](https://medium.com/@brianmayrose/django-step-9-180d04a4152c)
- [Django Rest Framework Official Documentation](https://www.django-rest-framework.org/)
- More about Nested Serializers: [Stackoverflow Link](https://stackoverflow.com/questions/51182823/django-rest-framework-nested-serializers)
- More about GenericViews: [Testdriver.io Link](https://testdriven.io/blog/drf-views-part-2/)

### Miscellaneous
- Create Virual Environment with Virtualenv and Virtualenvwrapper: [Link](https://docs.python-guide.org/dev/virtualenvs/)
- [Configure CORS](https://www.stackhawk.com/blog/django-cors-guide/)
- [Setup Django with Cloudinary](https://cloudinary.com/documentation/django_integration)

## Author
**Adrian Enßlin**