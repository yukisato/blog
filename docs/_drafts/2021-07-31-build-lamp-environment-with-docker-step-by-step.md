---
title: Build LAMP environment with docker step by step
description: This post explains how to create a LAMP environment using `docker-compose` step by step.
tags:
  - docker
  - docker-compose
  - lamp
---

This post explains how to create a LAMP environment using `docker-compose` step by step.
If you need a LEMP stack but are not testing Nginx configurations, this post can be your help too.

## The goal

As LAMP stands for, building envirronment consists of the following stack:

- Linux
- Apache
- MySQL
- PHP

At this time, we're getting to see data inside a MySQL docker container through a PHP script running on another container, and it's served by Apache. Everything are running on Linux.

Actually, container technology uses Linux's security feature such as `namespace` and `cgroup`, using Docker implicitly means using Linux thus you don't have to think about setting up Linux. And, fortunately, PHP provides docker images containing pre-built Apache server for running PHP. So we can achieve this goal with just combining two docker images.

## Fundamentals

First of all, you need to know what you'll create:

- docker-compose.yml
- Dockefile

`docker-compose.yml` is a main setting file that lists what and how containers work together.

`Dockerfile` is an IaaC(Infrastructure as a Code) file that lists how docker image is built.

## Create a base config file

To build up `docker-compose.yml`, firstly you need to decide what docker images to use. You can find your preferable image at [Docker Hub](https://hub.docker.com/). At this time we're using these two images:

- php:7.4.22-apache
- mysql:8.0.26

Let's create the first `docker-compose.yml` file as a start point:

```yaml
version: "3.9"
services:
  web:
    image: php:7.4.22-apache
  db:
    image: mysql:8.0.26
```

This file explayins just to run these two docker images creating each containers, and nothing else. We're adding more operations to build local environment.

## Serve PHP files in a container

We need to create `index.php` and let the PHP container see it. Let's create a source directory `src/` and mount it on a PHP container. Expose a port 8080 so that `index.php` can be seen by `http://localhost:8080`.

Take a look at [PHP image reference](https://hub.docker.com/_/php) and see it serves `/var/www/html`. So you need to bind your `src/` directory to this document root. Also, you need to bind local 8080 port to the continer's 80 port since Appache is listening on this port for HTTP:

```diff
version: "3.9"
services:
  web:
    image: php:7.4.22-apache
+   volumes:
+     - ./src:/var/www/html
+   ports:
+     - 8080:80
  db:
    image: mysql:8.0.26
```

Let's create an `src/index.php` file to check if it's served:

```php
<?php
echo 'Hello, world!';
```

To run docker-compose, you can simply execute the following command in your terminal:

```bash
docker-compose up
```

Open `http://localhost:8080` in a browser. Can you see "Hello, world`"? If not, review your docker configurations and created files.

If you're more CLI person, you can also test it by `curl localhost:8080` . It's easier.

## Configure the MySQL container

This section consists of two sub sections:

- Create a database on the MySQL container
- Bind a volume to the MySQL container for persistency

You firstly need to create a database in MySQL container. It's achieved just setting up environment variables on it.
Secondaly persistent server's data using a `volume` feature.

Let's go through from the first one.

### Create a database on the MySQL container

Fortunately, it's quite easy to create an initial database with the MySQL docker image. [MySQL repository reference](https://hub.docker.com/_/mysql) says, this image creates an initial database if you set **environment variables**. So let's set them in the file:

```diff
  db:
    image: mysql:8.0.26
+   environment:
+     MYSQL_DATABASE: local_db
+     MYSQL_USER: local_user
+     MYSQL_PASSWORD: mysql_local
+     MYSQL_ROOT_PASSWORD: mysql_local
```

Re-run `docker-compose up` and you'll see a longer logs in your console. That means the container created a database with those specified values. You can check it by entering the contanier.

Before entering the container, let's name those containers for convenience(don't forget to re-run docker-compose):

```diff
version: "3.9"
services:
  web:
    image: php:7.4.22-apache
+   container_name: local_web
    volumes:
      - ./src:/var/www/html
    ports:
      - 8080:80
  db:
    image: mysql:8.0.26
+   container_name: local_db
    environment:
      MYSQL_DATABASE: local_db
      MYSQL_USER: local_user
      MYSQL_PASSWORD: mysql_local
      MYSQL_ROOT_PASSWORD: mysql_local
```

Finally, you can enter the container and check if that DB is created:

```bash
# Enter the container "local_db"
docker exec -it local_db bash

# Connect to MySQL
mysql -u root -pmysql_local
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| local_db           |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```

### Bind a volume to the MySQL container for persistency

As a container is a fragile and temporal environment, you easily lose its data removing the container. Let's test it to exit `docker-compose` and remove all your stopped conteiners by `docker container prune -f`. After that, run `docker-compose up` so you'll see the same bunch of logs about the first database initialization again.

It's time to persistetnt your data. Using a `volume` feature is the answer for this need. There're two operations to make use of it:

- Create a volume if not exists
- Bind the volume to `/var/lib/mysql`

To take a look at the *Where to Store Data* section in the [MySQL image reference](https://hub.docker.com/_/mysql), `/var/lib/mysql` is used in this MySQL docker image.

>Note: /var/lib/mysql is a MySQL's default directory, but it doesn't mean every applications always use their defaults. It's really depends on how the image is made. So it's really important to check specs of an image of which you don't have clear understanding.

Edit your `docker-compose.yml` to create and use a volume named `db-data`:

```diff
db:
    (ommit)
+    volumes:
+      - db-data:/var/lib/mysql

# Add to the end
+volumes:
+  db-data:
```

The first change is to bind the volume `db-data` to `/var/lib/mysql` directory. The second change is to create a volume named `db-data` if not exists.

Stop and delete your containers with `docker container prune -f`, and re-run `docker-compose up`. The DB initialization will happen again because the container uses a new volume, but, after that, this operation will never happen unless you delete or unmount the volume.

## Configure the PHP container to connect to MySQL

This section consists of two subsections:

- Install PHP extensions to connect to MySQL
- Create a Dockerfile to preserve the changes

This is similar to the previous MySQL setup section. Setup the container, then preserve it for persistency.

At this time, we're preserving command line operations by `Dockerfile`.

### Install PHP extensions to connect to MySQL

To connect to the MySQL server from the PHP container, you need to install several extensions such as `mysqli` , `pdo` and `pdo_mysql` in the PHP container.
PHP docker images offer an easy way to install PHP extensions such as `docker-php-ext-install`. Enter the php container and execute the following command:

```bash
# Enter the PHP container
docker exec -it local_web bash

# Install extentions
docker-php-ext-install mysqli pdo pdo_mysql
```

After several time, those extentions become installed.
Modify `index.php` to connect to the MySQL server:

```php
<?php
$dbh = new PDO('mysql:host=db;dbname=local_db', 'local_user', 'mysql_local');

foreach($dbh->query('SHOW DATABASES') as $row) {
    print_r($row);
}
```

This code connects to the database, and write the result in the foreach loop. DB settings are previously set by environment variables in MySQL's section in `docker-compose.yml`. Host name `db` is a section name of the MySQL container. This name is resolved by docker's internal DNS.

Access to `http://localhost:8080` and check it fetches a list of databases from the MySQL server.

### Create a Dockerfile to preserve the changes

As explained before, a container loses all changes when removed.
`Dockerfile` is a way to preserve opetations to a base image so let's make this file.
Create a `php/` directory and a `Dockerfile` in this directory:

```dockerfile
FROM php:7.4.22-apache
RUN docker-php-ext-install mysqli pdo pdo_mysql
```

The first line means, an image is based on `php:7.4.22-apache`.
The second line literally runs given command to the base image.

You also need to modify `docker-compose.yml` so that it uses the Dockerfile to build an image and use it instead of pre-built docker image `php:7.4.22-apache`.

```diff
  web:
-   image: php:7.4.22-apache
+   build:
+     context: .
+     dockerfile: php/Dockerfile
```

`context` options is equivalant to `docker build` context. This means this image's build process can refer to all files under the given context. At this time we don't use any localfiles to build an image, so it's just a magic word.
After the change, stop docker-compose and run it with `--build` option. This option lets docker-compose build new images whenever it runs and find referrencing Dockerfiles have been changed:

```bash
docker-compose up --build
```

Access to `http://localhost:8080` to make sure it still works.


## Use Environment Variables in container

In a real programing world, make use of environment variables in containers for flexibility is one of the best practices.
Firstly change `index.php` to use environments:

```php
<?php
$dbh = new PDO('mysql:host=' . $_ENV['MYSQL_HOST'] . ';dbname='.$_ENV['MYSQL_DATABASE'], $_ENV['MYSQL_USER'], $_ENV['MYSQL_PASSWORD']);

foreach($dbh->query('SHOW databases') as $row) {
    print_r($row);
}
```

Next, edit `docker-compose.yml` to pass envs to the container:

```diff
  web:
    (ommit)
+   environment:
+     MYSQL_HOST: db
+     MYSQL_DATABASE: local_db
+     MYSQL_USER: local_user
+     MYSQL_PASSWORD: mysql_local
```

Make sure this change still works restarting docker-compose.


## Create envfile for DRY

As those two docker containers use the same key-value environment variables, create a file and read it for DRY.
Create a `.env.yml` for sharing envs:

```.env
MYSQL_HOST=db
MYSQL_DATABASE=local_db
MYSQL_USER=local_user
MYSQL_PASSWORD=mysql_local
MYSQL_ROOT_PASSWORD=mysql_local
```

Modify `docker-compose.yml` to read it instead of specifying duplicated envs:

```diff
  web:
-   environment:
-     MYSQL_HOST: db
-     MYSQL_DATABASE: local_db
-     MYSQL_USER: local_user
-     MYSQL_PASSWORD: mysql_local
+   env_file: .env.mysql

  db:
    image: mysql:8.0.26
-   environment:
-     MYSQL_DATABASE: local_db
-     MYSQL_USER: local_user
-     MYSQL_PASSWORD: mysql_local
-     MYSQL_ROOT_PASSWORD: mysql_local
+   env_file: .env.mysql
```

Finally restart compose and see the result.

