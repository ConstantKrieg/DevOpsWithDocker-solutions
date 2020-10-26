Here are the solutions to the exercises. All the files for each exercise can be found from that exercise's respective folder

## 1.1
```bash 
docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS                      PORTS               NAMES
121c8d3cd7a9        nginx               "/docker-entrypoint.…"   About a minute ago   Exited (0) 26 seconds ago                       modest_tharp
ca0800b4600b        nginx               "/docker-entrypoint.…"   About a minute ago   Exited (0) 9 seconds ago                        thirsty_pike
38d729a65d03        nginx               "/docker-entrypoint.…"   About a minute ago   Up About a minute           80/tcp              kind_clarke
```

## 1.2
```bash 
docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```

## 1.3
```bash 
docker run -it devopsdockeruh/pull_exercise 

Give me the password: basics
You found the correct password. Secret message is:
"This is the secret message"
```

## 1.4
```bash 
docker run -d devopsdockeruh/exec_bash_exercise

docker container ls
CONTAINER ID        IMAGE                               COMMAND                  CREATED             STATUS              PORTS               NAMES
f235ba1f16fd        devopsdockeruh/exec_bash_exercise   "docker-entrypoint.s…"   27 seconds ago      Up 22 seconds                           dazzling_jackson

docker exec -it dazzling_jackson bash
root@f235ba1f16fd:/usr/app# tail -d ./logs.txt

Secret message is:
"Docker is easy"
```

## 1.5
```bash docker run -it -d --name ubu ubuntu:16.04
docker exec ubu apt-get update
docker exec ubu apt-get install curl wget -y
docker exec -it ubu sh -c 'echo "Input website:"; read website; echo "Searching.."; sleep 1; curl http://$website;'
```

## 1.6
Commands:
```bash
docker run docker-clock
docker run docker-clock -c
```

Dockerfile:
```docker
FROM devopsdockeruh/overwrite_cmd_exercise
CMD ["/bin/bash"]
```
## 1.7
Commands:
```bash
docker build -t curler .
docker run -it curler
```

Dockerfile:
```docker
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y curl wget
COPY script.sh .
RUN chmod +x ./script.sh
CMD ["./script.sh"]
```

## 1.8
```bash
docker run -v $(pwd)/log.txt:/usr/app/logs.txt --name vol devopsdockeruh/first_volume_exercise
```

## 1.9
Commands:
```bash
docker run -p 8080:80 --name port_exercise devopsdockeruh/ports_exercise
```

After running the command above, going to localhost:8080 in a browser displayed a webpage with text 'Ports configured correctly!!' 


## 1.10
Commands:
```bash
docker build --tag frontend_exercise .

docker run -p 5000:5000 --name fe frontend_exercise
```


Dockerfile:
```docker
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y curl wget
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash 
RUN apt install -y nodejs
RUN node -v && npm -v
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["npm","start"]
```


## 1.11
Commands:
```bash
docker build --tag backend_exercise .

docker run -v $(pwd)/logs.txt:/logs.txt -p 8000:8000 --name be backend_exercise
```

Dockerfile:
```docker
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y curl wget
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash 
RUN apt install -y nodejs
RUN node -v && npm -v
COPY . .
RUN npm install
EXPOSE 8000
CMD ["npm","start"]
```

## 1.12

Commands:
```bash
#build
docker build --tag frontend-exercise ./frontend-example-docker
docker build --tag backend-exercise ./backend-example-docker

#run
docker run -d -p 5000:5000 --name fe frontend-exercise
docker run -d -p 8000:8000 --name be backend-exercise
```

Dockerfile for back end:
```docker
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y curl wget
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash 
RUN apt install -y nodejs
RUN node -v && npm -v
COPY . .
RUN npm install
EXPOSE 8000
ENV FRONT_URL=http://localhost:5000
CMD ["npm","start"]
```

Dockerfile for front end:
```docker
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y curl wget
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash 
RUN apt install -y nodejs
RUN node -v && npm -v
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
ENV API_URL=http://localhost:8000
CMD ["npm","start"]
```

## 1.13
Commands:
```bash
docker build -t spring-app .
docker run -p 8080:8080 spring-app
```
Dockerfile:
```docker
FROM openjdk:8
COPY . .
RUN ./mvnw package
EXPOSE 8080
ENTRYPOINT ["java","-jar", "./target/docker-example-1.1.3.jar"]
```

## 1.14
Commands:
```bash
docker build -t rails-app .
docker run -p 3000:3000 rails-app
```
Dockerfile:
```docker
FROM ruby:2.6.0
COPY . .
RUN gem install bundler
RUN bundle install
RUN apt-get update
RUN apt-get install -y nodejs --allow-unauthenticated
RUN rails db:migrate
EXPOSE 3000
ENTRYPOINT ["rails", "s"]
```

## 1.15
I dockerized my data structures and algorithms project which was a Java application that was using Gradle. It implements the PageRank algorithm. The repository can be found [here](https://github.com/ConstantKrieg/PageRank)  

The project can now be run with the followin command:

`docker run kriegmachine/pagerank`

## 1.16
The app can be found from 

https://constantkrieg-dockertest.herokuapp.com/


## 1.17
I created an image that has Python 3.8 preinstalled with the following libraries:
 - requests
 - numpy
 - scipy
 - pandas
  
I've previously created a lot of applications that fetch data from some API and then perform operations and analysis on the data using numpy, scipy and pandas.

The image can be run with the following:

`docker run -it kriegmachine/python-api-analyzer`

An interactive Python shell will open with all the libraries available.
