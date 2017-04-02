# Drone in a droplet (docker-drone-builder)

[![Build Status](http://drone.h43dus.org/api/badges/hbokh/docker-drone-builder/status.svg)](http://drone.h43dus.org/hbokh/docker-drone-builder)

Some experimenting with Drone, using `.drone.yml` to build assets.

---

# Howto

Create a Droplet at DigitalOcean.
I used a "one-click app", named drone-ci:  
512 MB Memory / 20 GB Disk / AMS2 - Ubuntu Docker 17.03.0-ce on 14.04

> Docker has been preinstalled and configured per Docker's Recommendations.
> You can find more information on using this image at: http://do.co/dockerapp

## Docker setup

File: `docker-compose.yml`

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
    env_file: .env

  drone-agent:
    image: drone/drone:0.5
    container_name: drone-agent
    command: agent
    restart: always
    depends_on: [ drone-server ]
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    env_file: .env
```

The env_file for docker-compose:

```
DRONE_OPEN=true
DRONE_GITHUB=true
DRONE_ADMIN=hbokh
DRONE_GITHUB_CLIENT=27658...
DRONE_GITHUB_SECRET=05c966a3...
DRONE_SECRET=SomeSecretHashWithLotsOfCharacters
DRONE_SERVER=ws://drone-server:8000/ws/broker
```
---
hbokh, April 2017
