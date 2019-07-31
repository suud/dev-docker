## build image with name `ubuntu-dev`
```
sudo docker build -t ubuntu-dev .
```

## run container
```
sudo docker run -t -d -v ~/docker-share:/mnt/host --name <name> ubuntu-dev
```

## attach to container
```
sudo docker exec -it <name> /bin/bash
```
