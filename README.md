# centos7-web

The purpose of this github repo is to product a Docker image that is ready to host Django in a production environment.  It has the following characteristics:

* Properly handles zombies by PID 1
* Uses NGINX to serve Django static files and uWSGI to handle Django views
* Runs as any arbitrary user so no need for root access
* Is OpenShift v3 compatible

# Who should use this image?

You can use this Docker image as a base if you are:

* Using Python 3.5 (although this image could be modified to use another version of python very easily)
* Using Django (or Flask or other python framework)
* Want to use the same image for production as development
* Want to properly serve static files using NGINX

# Usage

Out of the box, the image is ready to host any generic python wsgi application.  Use the following hooks to integration an application

<document hooks here>

wsgi

nginx

django files


# Philosophy and Build Details

So starting out the goals were to easily focus on writing python / Django code without needing to worry about many of the details of production deployment.  To this end, OpenShift v3 appeared to have many advantages, but had certain restrictions on their support Docker images.  In addition, taking some best practices from current thinking with respect to Docker image creation, this repo was created.

## Properly handles zombies by PID 1

There are a number of articles that go in depth on this problem much better than I can do justice:
 
* [https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/)

Initially I had been building upon the [phusion/baseimage](http://phusion.github.io/baseimage-docker/) because I believe the Phusion folks were doing it right.  However, there were a number of issues with their image.  Most critical is the fact that their lightweight init process my_init, while technically solid, requires running as root to operate properly.  In addition, when starting to research OpenShift, since it's sponsored by Red Hat, leans heavily toward CentOs.  

So I shifted to use the [centos/python-35-centos7:latest](https://hub.docker.com/r/centos/python-35-centos7/) baseline.  The good news in using this image is that it's easy for someone to switch to Python 2.7 instead of 3.5 by merely adjusting the image in the first line of the Dockerfile.

Next, we needed an appropriate init process.  Fortunately, Graham Dumpleton introduced me to a new lightweigh init process called tini in his [blog post](http://blog.dscpl.com.au/2015/12/issues-with-running-as-pid-1-in-docker.html)  

So now this Docker image has the primary entry point of [tini](https://github.com/krallin/tini) which handles the reaping of all zombie processes

## Uses NGINX to serve Django static files and uWSGI to handle Django views

Often when looking at Docker examples for python hosting applications, such as source-to-image (s2i), these examples are focused on running wsgi based views and/or processes.  

While this is certainly important to be able to leverage a wsgi gateway and get python rendering web pages, it is also important to be able to serve static files such as images, css, and javascript files.  Unfortunately, if a Docker image is running a single wsgi process, there is no way to handle static files.

Thus the options are:

* Running Apache with mod_wsgi
* Running two processes for a web server (e.g. NGINX) and a WSGI process (such as uWSGI or Gunicorn)

For this docker image, I chose option 2.  So there is a simple script that starts the image with two commands: start nginx and uwsgi

## Runs as any arbitrary user so no need for root access

While not technically required to create an operational Docker image, one of OpenShift v3's requirements for Docker images is that they are written so that any arbitrary user can be used for the image and it should work fine.

This was the challenge initially for deviating from the phusion/baseimage.  However, thanks to a number of informative blog posts: 
 
* [http://blog.dscpl.com.au/2015/12/unknown-user-when-running-docker.html](http://blog.dscpl.com.au/2015/12/unknown-user-when-running-docker.html)
* [http://blog.dscpl.com.au/2015/12/random-user-ids-when-running-docker.html](http://blog.dscpl.com.au/2015/12/random-user-ids-when-running-docker.html)

It allowed me to focus on the fact that a random user id will belong to linux group zero.  Thus all the files necessary for NGINX to run must be group zero accessible.  After making some system modifications, turns out that NGINX is quite happy running as a user and non-root.  Of course uWSGI works perfectly happy running as non-root so that was no problem.  

Mostly this involved making the relevant NGINX directories accessible to root group:

* /var/run/nginx
* /var/log/nginx
* /var/lib/nginx
* /etc/nginx
* /etc/service/nginx

## Is OpenShift v3 compatible

I think

# Example

See django example