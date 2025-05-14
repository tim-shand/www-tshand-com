---
author: Tim Shand
title: Knowledge Base App - BookStack with Docker
date: 2025-05-14
description: Review on running BookStack application locally within Docker.
image: bookstack_example-01.png
categories:
    - article
tags:
    - docker
    - containers
---

## Introduction

For a while now, I have been using Obsidian for note taking and recording steps for guides and general tasks.  
Obsidian allows you to record notes in markdown format, which is useful if you also use static-site generators like Hugo. 
I had configured Obsidian to store my notes in a category-based hierarchical layout within Proton Drive. 

Since my recent commitment to daily driving Ubuntu, I've had to sacrifice the convenience of a native cloud sync client. 
Unfortunately, a Proton Drive sync client for Linux was not yet in sight, so I began exploring other knowledge base solutions. 

With Obsidian as the benchmark, the new solution had to at least provide similar functionality. 
It was also important that I could access the knowledge base remotely via a web browser. 
This solution is intended to hold me over until a Proton sync client is developed for Linux. 
I still intend to use Obsidian in the future, however this project will be useful for learning about Docker and containers in general.  

### Solution Requirements

**Goal:** Personal and remotely accessible knowledge base for detailing fixes, guides and technical information. 

- **Portable:** Redeployable across multiple environments, ideally in container form.  
- **Content Tagging:** Useful for quick topic searches.  
- **Keyword Search Functionality:** Required for quickly locating related information in articles.  

### The Candidate

#### [BookStack](https://www.bookstackapp.com/)  

- Web-based application running on PHP.
- Uses a simplified interface, following a hierarchical folder structure.  
- Requires either MySQL or MariaDB database running as a separate container.  
- Includes a WYSIWYG editor as the default, with the option of also using markdown.  

## Deployment

As my Proxmox homelab is not yet ready for production, this project is to be to be deployed on my local machine running Ubuntu Desktop 25.04 with Docker pre-installed. This method will allow me to begin learning about containers and Docker without delay.  

After reviewing the features and documentation for the application, I was ready to begin testing it out.  
The provided documention included an example `docker-compose.yml` file, describing how to deploy the application via Docker. 
The YAML file contained both the web app and the database containers, mapping local host directories for the storage volumes. 
As containers are ephemeral by nature, this will allow for the retention of data when the containers are destroyed and re-deployed. 

### Dockerfile Changes

Using the vendor documentation as a base, I decided to write my own `docker-compose` files based on the provided examples. 
I chose to include extra lines for `depends_on:`, modified the container names and made use of `.env` environment files. 

Including the `depends_on:` config prevents the app container from running if the database container fails to load first. 
Using the `.env` file allows us to define the environment variables (such as secrets) in a separate file, keeping them out of code. 

### Commands

**Bring up the Docker containers as described in the YAML file:**  
`sudo docker-compose -f ./bookstack/docker-compose.yml up -d`  
- `-f`: Specify the file you wish to load with Docker-Compose.  
- `up`: Bring the containers and associated resources "up", or into a running state.  
- `-d`: Run in detached mode. This allows the containersto run in the background, releasing the terminal back to the user.  

**Destroy previously created running containers:**  
`sudo docker-compose -f ./bookstack/docker-compose.yml down`  
- `-f`: Specify the file you wish to load with Docker-Compose.  
- `down`: Stops and removes the containers, networks, volumes, and images created by "up" command.  

**Remove data and files created from containers:**  
`sudo rm -r ./bookstack/app_data/`  
`sudo rm -r ./bookstack/db_data/`  

### Troubleshooting

#### Issue #1: No response on localhost:6875

After the initial modifications to the `docker-compose.yml` file, I made some tweaks to the volume mounting sections. 
The intention was to tidy up the folder structure in my project directory, however the containers began to fail. 

I confirmed that both containers were running by executing the command `sudo docker ps` to list and show the state of running containers. 
There were no obvious (or any!) logs being written to the mapped `./bookstack/app_data/log/bookstack` directory. 
The next step was to stop the containers, and re-run the `docker-compose` command, this time omitting the `-d` for "detached mode". 

`sudo docker-compose -f ./bookstack/docker-compose.yml up`  

This meant that when I spun up the containers again, I was able to view the output via the terminal.  

**Output:**  
```
bookstack-app    | using keys found in /config/keys
bookstack-app    | The application key is missing, halting init!
bookstack-app    | You can generate a key with: docker run -it --rm --entrypoint /bin/bash lscr.io/linuxserver/bookstack:latest appkey
bookstack-app    | And apply it to the APP_KEY environment variable.
```

Based on the output, it appears that the `APP_KEY` environment variable was not being passed correctly. 
I did run and generate this key prior as per the vendor documentation, however since moving this environment variable from the main `docker-compose.yml` file to the `.env` file, I suspected there was a formatting issue causing the failure. 

I experimented with different methods of wrapping the `APP_KEY` value, as leaving it raw exposed reserved characters causing further failures.  

```
# Bookstack App:
APP_URL="http://localhost:6875"
#APP_KEY=base64:**snip**
#APP_KEY='base64:**snip**'
#APP_KEY=base64:"**snip**"
```

After researching and reviewing other docker compose files, I confirmed that the syntax for passing the local `.env` file was incorrect.  

**Wrong:**  
```
environment:
    env_file: .env
```
**Fixed:**  
```
env_file:
  - .env
```

This may have fixed the current syntax error, however a new issue had arose. 

#### Issue #2: Traceback Errors

Attempting to spin up the containers again gave me problems, this time with traceback errors.  

```
ERROR: for d7792ac53e94_bookstack-db  'ContainerConfig'
ERROR: for bookstack-db  'ContainerConfig'
Traceback (most recent call last):
  File "/usr/bin/docker-compose", line 33, in <module>
    sys.exit(load_entry_point('docker-compose==1.29.2', 'console_scripts', 'docker-compose')())
```

A quick query to ChatGPT suggested that the cause was likely the version of Docker Compose I had installed (via distro repo).  

`This traceback is a known bug in older versions of docker-compose (pre-v2), especially 1.29.2, which you're using.`  

Using the Docker provided [instructions for Ubuntu](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository), I added the repositories and installed the later version of both Docker and Docker Compose. 
At this point, the commands I was using previously no longer worked and I needed to change to use those compatible with the new packages. 

```
# Note the removal of the 'dash' symbol from between 'docker compose'.
sudo docker compose -f ./docker-compose.yml up -d
```

#### Issue #3: Left Overs

Third time lucky right? Nope.  

Running up the containers appeared to work, however accessing the app on `localhost:6875` gave me `Internal Server Error`.  
Thankfully this last issue was easy to diagnose by running the containers in attached mode (omit the `-d`).  

I was able to locate errors related to the user account authentication failing. 
The previous containers I had spun up had written data to my localhost via the mapped directories/volumes.  

This meant that my initial failed runs had already performed the initial database prep, and configured the database using settings that I had since modified. 
Removing the old data directories and running the containers again provided a clean environment, proving to be a success!  

### Final Docker-Compose Files

With the containers for BookStack now functioning as expected, I was ready to test out this app for my use case. 
The application can be accessed locally using a web browser by navigating to: `https://localhost:6875`. 

**.docker-compose.yml**  
``` docker-compose
services:
  # The container for BookStack application.
  bookstack-app:
    image: lscr.io/linuxserver/bookstack:version-v25.02
    container_name: bookstack-app
    depends_on:
      - bookstack-db
    env_file: 
      - .env
    volumes:
      # Map '/config' inside the container to a local "bookstack_app_data" directory (created if missing).
      - ./app_data:/config
    ports:
      # Expose local port 6875, mapped to container port 80 for web app access.
      - 6875:80
    restart: unless-stopped

  # The container for the database.
  bookstack-db:
    image: lscr.io/linuxserver/mariadb:11.4.4
    container_name: bookstack-db
    env_file: 
      - .env
    volumes:
      # Map '/config' inside the container to a local "bookstack_db_data" directory (created if missing).
      - ./db_data:/config
    restart: unless-stopped
```

**.env**  
```
# Global:
# Allows containers to map the container's internal user to a user on the host machine.
PUID=1000
PGID=1000
TZ="Pacific/Auckland"

# Bookstack App:
APP_URL="http://localhost:6875"
# APP_KEY must be a unique key. Generate your own (keep the "base64:") by running
# docker run -it --rm --entrypoint /bin/bash lscr.io/linuxserver/bookstack:latest appkey
APP_KEY="base64:**snip**"
DB_HOST="bookstack-db"
DB_PORT="3306"
DB_DATABASE="bookstack"
DB_USERNAME="svc-bookstack"
DB_PASSWORD="**snip**"

# Bookstack DB:
MYSQL_ROOT_PASSWORD="**snip**"
MYSQL_DATABASE="bookstack"
MYSQL_USER="svc-bookstack"
MYSQL_PASSWORD="**snip**"
```

**Commands:**  
`sudo docker compose -f ./docker-compose.yml up -d`
`sudo docker compose -f ./docker-compose.yml down`

## Parting Thoughts

My initial thoughts on Bookstack were positive. The interface was clean and easy to navigate, with the top search bar proving to be very responsive. 
The hierarchical structure was familiar and provided a well-organised view for various topics.  

I was greatful to discover the autosave 'draft' functionality, after accidentially closing the editor window before saving the page. 
The built-in drawing capability (using the [diagams.net](https://diagams.net) plugin) will be especially useful for embedding design diagrams for future projects.  

### Top Marks
- Clean and simple to navigate  
- Fast and responsive  
- Accurate real-time search  
- Customizable interface (header, icons, colours etc)  
- Built-in diagram/drawing capability  
- Autosave (draft) functionality  

I plan to migrate this application to my production environment once I have it up and running (and documented!).  

---

*Cover photo taken from [BookStack demo site](https://demo.bookstackapp.com/shelves)*
