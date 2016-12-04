# centos7-web

Based on the python-35-centos7 image, we add nginx and uwsgi




## Steps to create

These steps were done on a mac
Prerequisites:
* Python 3.5 installed
* Docker for Mac installed
* s2i installed 

### Setup base directory and virtualenv
```sh
mkdir first-s2i-python-app
cd first-s2i-python-app
virtualenv ve
```

### Install Django and Gunicorn and requirements
```sh
pip install Django Gunicorn
pip freeze > requirements.txt
```

### Start the Django project and move some key files around
```sh
django-admin startproject helloworld .
mv helloworld/wsgi.py .
```
See Notes below as to why we move the wsgi.py file around

### Create s2i images
```sh
s2i build . centos/python-35-centos7 first-s2i-python-app-image
```

### Run newly created image
```sh
docker run -p 8080:8080 first-s2i-python-app-image
```
and then you should be able to see "It Worked!" if you load http://127.0.0.1:8080

## Some Notes
I have learned that to invoke some of automatic wiring of s2i for django projects, the 
following files must be at the root of the git repo:
* requirements.txt
* manage.py
* wsgi.py

### Web Server

Since we put the wsgi.py file at the root of the repo and we have specified Gunicorn in 
the requirements.txt file, then when running the image, a default Gunicorn server is used.

Had we not put either of the two prequisties in place, then s2i would have used `python manage.py runserver`
to host the web application

## Helpful references

* https://github.com/openshift/source-to-image
* https://hub.docker.com/r/centos/python-35-centos7/
* https://github.com/sclorg/s2i-python-container/tree/master/3.5

## Image Build Shortcuts

### To build image

```sh
s2i build . centos/python-35-centos7 first-s2i-python-app-image
```

### To run the django app using runserver
```sh
docker run -p 8080:8080 first-s2i-python-app-image
```
and then you should be able to see "It Worked!" if you load http://127.0.0.1:8080

