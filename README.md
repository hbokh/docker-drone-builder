# Drone in a droplet (docker-drone-builder)

[![Build Status](http://drone.h43dus.org/api/badges/hbokh/docker-drone-builder/status.svg)](http://drone.h43dus.org/hbokh/docker-drone-builder)

Some experimenting with Drone, using `.drone.yml` to build assets.

---

# Howto

Create a Droplet at DigitalOcean.
I used a Docker "one-click app" and named it drone-ci.  
Specs: 512 MB Memory / 20 GB Disk / AMS2 - Ubuntu Docker 17.03.0-ce on 14.04

> Docker has been preinstalled and configured per Docker's Recommendations.
> You can find more information on using this image at: http://do.co/dockerapp

## Docker setup

SSH into the droplet and install docker-compose:

```
wget https://github.com/docker/compose/releases/download/1.11.2/docker-compose-Linux-x86_64 -O /usr/local/bin/docker-compose && chmod 750 /usr/local/bin/docker-compose
```

Create a `docker-compose.yml`-file:

```
version: '2'

services:
  drone-server:
    image: drone/drone:0.5
    container_name: drone
    ports:
      - 80:8000
    volumes:
      - /var/lib/drone:/var/lib/drone/
    restart: always
    env_file: .env-server

  drone-agent:
    image: drone/drone:0.5
    container_name: drone-agent
    command: agent
    restart: always
    depends_on: [ drone-server ]
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:rw
    env_file: .env-agent
```

The env_files for docker-compose, `.env-server` and `.env-agent`.  
`.env-agent` only needs the last two lines of this list:

```
DRONE_OPEN=true
DRONE_GITHUB=true
DRONE_ADMIN=hbokh
DRONE_GITHUB_CLIENT=27658...
DRONE_GITHUB_SECRET=05c966a3...
DRONE_SECRET=SomeSecretHashWithLotsOfCharacters
DRONE_SERVER=ws://drone-server:8000/ws/broker
```

## Install drone CLI from Homebrew

```
$ brew tap drone/drone
$ brew install drone --devel
```

Set the **DRONE\_SERVER** and **DRONE\_TOKEN**:

```
$ export DRONE_SERVER=http://drone.example.com
$ export DRONE_TOKEN=ayJbbGcjojpwefnoHokkFFa ...
```

Your user account token can be found in the webUI by clicking "GET TOKEN".
It is > 100 characters in length.

Now you can command drone remotely and do stuff like:

```
$ drone repo info hbokh/docker-drone-builder

Owner: hbokh
Repo: docker-drone-builder
Type: git
Private: false
Remote: https://github.com/hbokh/docker-drone-builder.git
```

```
$ drone secret ls hbokh/docker-drone-builder

DOCKER_USERNAME
Events: push, tag, deployment
SkipVerify: false
Conceal: false
```

---
hbokh, April 2017
