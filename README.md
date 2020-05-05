# [dev](https://github.com/suud/dev-docker)
![](https://github.com/suud/dev-docker/workflows/Push%20to%20Docker%20Hub/badge.svg)

This container image is not made to be used in production. It contains some
development tools that you might not want to have installed in a production
environment.

Though, you can just adopt the workflow but use a clean parent image
(change the `FROM` in your Dockerfile).


# Quickstart
## Temporary Container
For simple tests, you can simply spin up and attach to a container that has the
current working directory mounted and will be removed on exit:
```sh
docker run -it --rm -v "$(pwd)":/app -w /app suud/dev zsh
```


# Advanced Usage
The build and deploy process can be customized.
Configurations that shall only be set for development go into
`docker-compose.override.yml`. The production only configuration is set in
`docker-compose.prod.yml`. The configuration from `docker-compose.yml` is
loaded in both cases, but might be overwritten by the more specific files.

## Prerequisites
### Create a `Dockerfile`
```yaml
FROM suud/dev:latest

#RUN apt-get update && apt-get install -qq \
#    tmux \
#    wget

WORKDIR /app

#COPY requirements.txt ./
#RUN pip install --no-cache-dir -r requirements.txt

ADD . .

#RUN chmod +x start.sh
#EXPOSE 8000

# keep debian-based container running
CMD tail -f /dev/null
```

### Create a `docker-compose.yml` containing a basic configuration
```yaml
app:
  build: .
#  command: start.sh
#  env_file:
#    - .env.app
```

### Create a `docker-compose.override.yml` for development only configurations
```yaml
app:
  volumes:
    # mount source directory
    - .:/app
#  ports:
#    # HOST:CONTAINER#
#    - 8080:8000
```

### Create a `docker-compose.prod.yml` for production only configurations
```yaml
app:
  restart: always
```

## Deploy for Production
```sh
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

## Development Workflow
- Deploy the application in development mode: `docker-compose up -d --build`
- Do your changes inside the project directory. This should be done
from the host system. You might loose your changes if you modify files inside
the container and a directory isn't mounted correctly.
- When installing packages inside the container, they should also be added to
the service's `Dockerfile`.
- After changing a service's `Dockerfile` or files from its build directory
that are used during the build process (e.g. `requirements.txt`),
`docker-compose build` should be executed for rebuilding.
- A temporary second instance of a service's container can be started and
attached to with `docker-compose run --rm app zsh`.


# Useful Commands
## Start services
Build, (re)create and start containers for all services from docker-compose.yml
(without attaching to them)

_Without `--build`, a image is only built if there doesn't exist one, yet_
```sh
docker-compose up -d
```

Start only existing containers
```sh
docker-compose start
```

## Stop services
Stop running containers without removing them
```sh
docker-compose stop
```

Stop containers and remove containers, networks, volumes, and images
```sh
docker-compose down
```

## Restart services
Restart a __specific__ service

_Without specifying `app`, all services from `docker-composer.yml` are
restarted._ This syntax works as well with `up`, `stop`, `start` and `logs`.
```sh
docker-compose restart app
```

## Attach to container
Attach to container with interactive `zsh` (`bash` works, too)
```sh
docker-compose exec app zsh
# alternative:
# docker exec -it app zsh
```

Start another container of a service without binding ports. The container will
be removed automatically after detaching from it. I use this to manually run
scripts and test commands from a second instance.
```sh
docker-compose run --rm app zsh
```

## Show logs
```sh
docker-compose logs -f
```

## Cleaning up
Remove all docker containers having status `Exited` and `Created`
```sh
docker ps -a | grep 'Exited\|Created' | cut -d ' ' -f 1 | xargs docker rm
```

Remove all docker containers
```sh
docker rm $(docker ps -a -q) -f
```

Remove all docker images
```sh
docker rmi $(docker images) -f
```


# License

This repository is released under the
[MIT License](https://opensource.org/licenses/MIT).
