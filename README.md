# Workflow
1. clone this repository
2. create environment file(s)

## Production
Deploy the application:
```
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

## Development
- Deploy the application with `docker-compose up -d --build`.
- Do your changes in the project directory.
- When installing packages inside the container, they should also be added to
the service's `Dockerfile`.
- After changing a service's `Dockerfile` or files of its build directory that
are used during the build process (e.g. `requirements.txt`),
`docker-compose build` needs to be executed to rebuild.
- A temporary second instance of a service's container can be started and
attached to with `docker-compose run --rm app bash`.
- Configurations that shall only be set for development go into
`docker-compose.override.yml`. The production only configuration is set in
`docker-compose.prod.yml`. The configuration from `docker-compose.yml` is
loaded in both cases, but might be overwritten by the more specific files.

# Command reference
## Start services
Build, (re)create and start containers for all services from docker-compose.yml
(without attaching to them)

_Without `--build`, a image is only built if there doesn't exist one, yet_
```
docker-compose up -d
```

Start only existing containers
```
docker-compose start
```

## Stop services
Stop running containers without removing them
```
docker-compose stop
```

Stop containers and remove containers, networks, volumes, and images
```
docker-compose down
```

## Restart services
Restart a __specific__ service

_Without specifying `app`, all services from `docker-composer.yml` are
restarted._ This syntax works as well with `up`, `stop`, `start` and `logs`.
```
docker-compose restart app
```


## Attach to container
Attach to container with interactive bash
```
docker-compose exec app bash
# alternative:
# docker exec -it app bash
```

Start another container of a service without binding ports. The container will
be removed automatically after detaching from it. I use this to manually run
scripts and test commands from a second instance.
```
docker-compose run --rm app bash
```

## Show logs
```
docker-compose logs -f
```

## Cleaning up
Remove all docker containers having status `Exited` and `Created`
```
docker ps -a | grep 'Exited\|Created' | cut -d ' ' -f 1 | xargs docker rm
```

Remove all docker containers
```
docker rm $(docker ps -a -q) -f
```

Remove all docker images
```
docker rmi $(docker images) -f
```
