## 3.1

Dockerfile for the back end:

```docker
FROM ubuntu:16.04

COPY . .
RUN apt-get update && apt-get install -y curl wget &&\
    curl -sL https://deb.nodesource.com/setup_10.x | bash && \ 
    apt install -y nodejs  &&\
    node -v && npm -v &&\
    npm install && \ 
    apt-get purge -y --auto-remove curl && \ 
    apt-get purge -y --auto-remove wget && \ 
    rm -rf /var/lib/apt/lists/* 


EXPOSE 8000
CMD ["npm","start"]
```

Dockerfile for the front end:

```docker
FROM ubuntu:16.04

COPY package*.json ./

RUN apt-get update && apt-get install -y curl wget &&\
    curl -sL https://deb.nodesource.com/setup_10.x | bash && \ 
    apt install -y nodejs  &&\
    node -v && npm -v &&\
    npm install && \ 
    apt-get purge -y --auto-remove curl && \ 
    apt-get purge -y --auto-remove wget && \ 
    rm -rf /var/lib/apt/lists/* 
COPY . .
EXPOSE 5000
CMD ["npm","start"]

```

Images were built with running these commands from the `3.1/` -folder
```bash
docker build -t trim-be ../utils/backend
docker build -t trim-fe ../utils/frontend
```

```bash
docker history trim-be
IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
18fea9e06a21        34 seconds ago       /bin/sh -c #(nop)  CMD ["npm" "start"]          0B                  
247f42dc8cba        34 seconds ago       /bin/sh -c #(nop)  EXPOSE 8000                  0B                  
66aa56c81715        36 seconds ago       /bin/sh -c apt-get update && apt-get install…   187MB
```

```bash
docker history trim-fe

IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
bfb9aaa04a56        13 seconds ago       /bin/sh -c #(nop)  CMD ["npm" "start"]          0B                  
7933d83321e2        13 seconds ago       /bin/sh -c #(nop)  EXPOSE 5000                  0B                  
1650fbb4b41c        13 seconds ago       /bin/sh -c #(nop) COPY dir:07ae685a36567e509…   557kB               
220af1f33e84        16 seconds ago       /bin/sh -c apt-get update && apt-get install…   362MB    
```

## 3.2

I created a simple Flask-application that calculates Fibonacci numbers in two ways and compares the execution times. CircleCI builds the docker image after each push to Git and pushes the updated image to DockerHub. CircleCI also deploys the image to Heroku. I used the CircleCI's built-in orb called `heroku/deploy-via-git` to automatically instruct CircleCI to publish the application in Heroku according to the configuration specified in `heroku.yml`. There I specified that the build should be run using Docker and specified the location of the Dockerfile. 

Links:
 - [Project GitHub](https://github.com/ConstantKrieg/docker-flask-demo)
 - [Application](https://docker-fibonacci-flask.herokuapp.com/)
  

## 3.3

I created a script called `publisher.sh`. It an be found in the folder `3.3/`

`publisher.sh`

```bash
#!/bin/bash

read -p "Project to download: " repo_url

mkdir tempapp
git clone $repo_url tempapp
cd tempapp

read -p 'DockerHub image name: ' dhub_imgname
read -p 'DockerHub username: ' dhub_name
read -p 'DockerHub password: ' -s  dhub_pass

docker login -u $dhub_name -p $dhub_pass
docker build -t $dhub_name/$dhub_imgname .
docker push $dhub_name/$dhub_imgname

cd ..
rm -f -r tempapp

```


## 3.4

I created a user called container_user in both Dockerfiles and added the working directory to that user.

Back end Dockerfile

```docker
FROM ubuntu:16.04

WORKDIR /app 

COPY . /app

RUN apt-get update && apt-get install -y curl wget &&\
    curl -sL https://deb.nodesource.com/setup_10.x | bash && \ 
    apt install -y nodejs  &&\
    node -v && npm -v &&\
    npm install && \ 
    apt-get purge -y --auto-remove curl && \ 
    apt-get purge -y --auto-remove wget && \ 
    rm -rf /var/lib/apt/lists/* && \
    useradd -m container_user && \
    chown -R container_user /app

USER container_user

EXPOSE 8000
CMD ["npm","start"]
```

Front end Dockerfile

```docker
FROM ubuntu:16.04

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y curl wget &&\
    curl -sL https://deb.nodesource.com/setup_10.x | bash && \ 
    apt install -y nodejs  &&\
    node -v && npm -v &&\
    npm install && \ 
    apt-get purge -y --auto-remove curl && \ 
    apt-get purge -y --auto-remove wget && \ 
    rm -rf /var/lib/apt/lists/* && \ 
    useradd -m container_user && \
    mkdir dist && \
    chown -R container_user /app

USER container_user


EXPOSE 5000
CMD ["npm","start"]
```

## 3.5

Here are the sizes before changes:

```bash
docker history backend
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
2514fe4983d1        About an hour ago   /bin/sh -c #(nop)  CMD ["npm" "start"]          0B                  
1b5c1b5b5414        About an hour ago   /bin/sh -c #(nop)  EXPOSE 8000                  0B                  
fd00a4fc4ff8        About an hour ago   /bin/sh -c #(nop) WORKDIR /app                  0B                  
7fec762e1163        About an hour ago   /bin/sh -c #(nop)  USER app                     0B                  
3cf8807425d0        About an hour ago   /bin/sh -c apt-get update && apt-get install…   187MB               
a3f2c2fc6a0d        About an hour ago   /bin/sh -c #(nop) COPY dir:771afc10d3709fb33…   219kB 
```

```bash
docker history frontend
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
0434b859d60d        46 minutes ago      /bin/sh -c #(nop)  CMD ["npm" "start"]          0B                  
1979946f6946        46 minutes ago      /bin/sh -c #(nop)  EXPOSE 5000                  0B                  
5e9003f95880        46 minutes ago      /bin/sh -c #(nop)  USER container_user          0B                  
74c27e3a967b        46 minutes ago      /bin/sh -c apt-get update && apt-get install…   363MB               
018fbae787b1        47 minutes ago      /bin/sh -c #(nop) COPY dir:95a14e470bbe08624…   557kB               
de3c5e70f2fe        About an hour ago   /bin/sh -c #(nop) WORKDIR /app                  0B 
```

I changed the Dockerfiles like this:


Back end

```docker
FROM node:alpine

WORKDIR /app 
COPY . /app

RUN npm install && \
    adduser -D container_user && \
    chown -R container_user /app

USER container_user

EXPOSE 8000
CMD ["npm","start"]
```
Front end

```docker
FROM node:alpine

WORKDIR /app 
COPY . /app

RUN npm install && \
    adduser -D container_user && \
    chown -R container_user /app

USER container_user

EXPOSE 5000
CMD ["npm","start"]
```

After building the images and tagging them as **frontend:alpine** and **backend:alpine** I looked the new sizes which were the following:


```bash
docker history backend:alpine
IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
008650207dd0        About a minute ago   /bin/sh -c #(nop)  CMD ["npm" "start"]          0B                  
624207873e60        About a minute ago   /bin/sh -c #(nop)  EXPOSE 8000                  0B                  
8c74f8ea4f2d        About a minute ago   /bin/sh -c #(nop)  USER container_user          0B                  
932dcfffbc1a        About a minute ago   /bin/sh -c npm install &&     adduser -D con…   42.6MB              
0c840f8aab9a        About a minute ago   /bin/sh -c #(nop) COPY dir:32db8cba121bc7915…   219kB 
```

```bash
docker history frontend:alpine
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
9a94dd6650fd        2 minutes ago       /bin/sh -c #(nop)  CMD ["npm" "start"]          0B                  
886bd9d6a45f        2 minutes ago       /bin/sh -c #(nop)  EXPOSE 5000                  0B                                                                                                 
14beceb21569        2 minutes ago       /bin/sh -c #(nop)  USER container_user          0B                                                                                                 
c3b75d27063a        2 minutes ago       /bin/sh -c npm install &&     adduser -D con…   218MB                                                                                              
06b3e4c5dd0b        3 minutes ago       /bin/sh -c #(nop) COPY dir:944b2db2e5f4ec07e…   557kB 
```


## 3.6

Dockerfile for the front end

```docker
FROM node:alpine as build

WORKDIR /app 
COPY . /app

RUN npm install && \
    adduser -D container_user && \
    chown -R container_user /app

USER container_user

EXPOSE 5000
RUN npm run build

FROM node:alpine

RUN npm install -g serve

COPY --from=build /app/dist /dist

CMD [ "serve", "-s", "-l", "5000", "dist" ]
```


## 3.7

I decided to use the Dockerfile that was created in the exercise **3.2**. In the beginning it looks like this:

```docker
FROM python:3.7
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
EXPOSE 5000

ENTRYPOINT [ "python" ]
CMD ["main.py"]
```

So things that needs to be done:
 - Change the python image to an alpine version
 - Make the file a multi stage build so that the dependency installation phase can be omitted in the actual image (___Easiest way to do this for me was to make the containers run a virtual environment in both stages. This way I could control where the dependencies were installed and copy them to the actual deployment stage___)
 - Change the image to use a non-root user when executing commands

After optimizations:

```docker
FROM python:3.7-alpine as base

FROM base as build

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

FROM base

WORKDIR /app

COPY --from=build /opt/venv /opt/venv
COPY . /app

RUN adduser -D container_user && \
    chown -R container_user /app

USER container_user 

ENV PATH="/opt/venv/bin:$PATH"
EXPOSE 5000
ENTRYPOINT [ "python" ]
CMD ["main.py"]
```

I built the new image with tag **fibonacci-flask:alpine**. I can now compare the size to the original image:
```bash
docker images | grep fibonacci-flask
fibonacci-flask                                  alpine              020e16f80431        3 minutes ago       55.6MB
registry.heroku.com/docker-fibonacci-flask/web   latest              17da20dde807        10 hours ago        885MB
kriegmachine/fibonacci-flask                     latest              66f79cf911cf        11 hours ago        885MB
```

So the size went down from 855MB to 55.6MB


## 3.8
![kubernetes_diagram](https://github.com/ConstantKrieg/DevOpsWithDocker-solutions/blob/master/Part3/3.8/kubernetes.PNG?raw=true)
