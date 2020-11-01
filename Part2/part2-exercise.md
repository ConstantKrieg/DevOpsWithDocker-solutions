## 2.1

docker-compose.yml 

```yml
version: '3.5' 

services: 

    log-creator: 
      image: devopsdockeruh/first_volume_exercise
      volumes: 
        - ./logs.txt:/usr/app/logs.txt
      container_name: log-creator
```

The output that was written to `2.1/logs.txt` was 
> Thu, 29 Oct 2020 07:18:49 GMT\
> Thu, 29 Oct 2020 07:18:52 GMT\
> Thu, 29 Oct 2020 07:18:55 GMT\
> Thu, 29 Oct 2020 07:18:58 GMT\
> Secret message is:\
> "Volume bind mount is easy"


## 2.2

docker-compose.yml 

```yml
version: '3.5'  

services: 
    ports-exercise: 
      image: devopsdockeruh/ports_exercise
      ports: 
        - 8000:80 
```

After opening my browser and navigating to `localhost:8000` the following message was displayed:

> Ports configured correctly!!

## 2.3

docker-compose.yml

```yml
version: '3.5'  

services: 
    backend: 
      build: ../utils/backend-example-docker
      ports: 
        - 8000:8000
      environment:
          - FRONT_URL=http://localhost:5000
    frontend: 
        build: ../utils/frontend-example-docker
        ports: 
            - 5000:5000
        environment: 
            - API_URL=http://localhost:8000
```

## 2.4 

Command used to run docker-compose:

```bash 
docker-compose up --scale compute=3
```

## 2.5

docker-compose.yml:

```yml
version: '3.5'  

services: 
    backend: 
      build: ../utils/backend-example-docker
      ports: 
        - 8000:8000
      environment:
          - FRONT_URL=http://localhost:5000
          - REDIS=database
    database:
        image: redis
    frontend: 
        build: ../utils/frontend-example-docker
        ports: 
            - 5000:5000
        environment: 
            - API_URL=http://localhost:8000
```

## 2.6

docker-compose.yml

```yml
version: '3.5'  

services: 
    backend: 
      build: ../utils/backend-example-docker
      ports: 
        - 8000:8000
      environment:
        - FRONT_URL=http://localhost:5000
        - DB_USERNAME=example
        - DB_PASSWORD=example
        - DB_NAME=database
        - DB_HOST=db
    db:
      image: postgres
      restart: always
      environment:
        - POSTGRES_USER=example
        - POSTGRES_PASSWORD=example
        - POSTGRES_DB=database

    frontend: 
        build: ../utils/frontend-example-docker
        ports: 
            - 5000:5000
        environment: 
            - API_URL=http://localhost:8000
```

## 2.7

docker-compose.yml

```yml
version: '3.5' 

services: 

    training: 
      build: ./ml-kurkkumopo-training
      volumes: 
        - imgs:/src/imgs
        - model:/src/model
    backend: 
        build: ./ml-kurkkumopo-backend
        ports:
            - 5000:5000
        volumes: 
            - model:/src/model
        depends_on:
            - training
        
    frontend: 
        build: ./ml-kurkkumopo-frontend
        ports: 
            - 3000:3000
    
volumes:
    model:
    imgs:  
```


## 2.8

docker-compose.yml

```yml
version: '3.5'  

services: 
    backend: 
      build: ../utils/backend-example-docker
      ports: 
        - 8000:8000
      environment:
        - FRONT_URL=http://localhost:5000
    frontend: 
        build: ../utils/frontend-example-docker
        ports: 
            - 5000:5000
        environment: 
            - API_URL=http://localhost:8000
    
    web:
        image: nginx
        volumes:
            - ./nginx.conf:/etc/nginx/nginx.conf
        ports:
            - "80:80"
```

## 2.9

docker-compose.yml

```yml
version: '3.5'  

services: 
    backend: 
      build: ../utils/backend-example-docker
      ports: 
        - 8000:8000
      environment:
        - FRONT_URL=http://localhost:5000
        - DB_USERNAME=example
        - DB_PASSWORD=example
        - DB_NAME=database
        - DB_HOST=db
        - REDIS=cache
    db:
      image: postgres
      restart: always
      environment:
        - POSTGRES_USER=example
        - POSTGRES_PASSWORD=example
        - POSTGRES_DB=database
      volumes:
        - ./database:/var/lib/postgresql/data
    cache:
        image: redis
        volumes: 
          - ./cache:/data

    frontend: 
        build: ../utils/frontend-example-docker
        ports: 
            - 5000:5000
        environment: 
            - API_URL=http://localhost:8000
```
## 2.10

Since we're using a reverse proxy we need to change the enviromental variables in both the front end and the back end. Since nginx is now dividing the traffic between the front end and the back end, I changed the enviromental variables to use the same path structure that is definded in `nginx.conf` so API URL is now `localhost/api` and FRONT URL is just `localhost`. I used `colasloth.com` just to make it nicer. I didn't need to do anything in the Dockerfiles since the environmental variables are defined here in the compose. 1  
```yml

version: '3.5'  

services: 
    backend: 
      build: ../utils/backend-example-docker
      ports: 
        - 8000:8000
      environment:
        - FRONT_URL=http://colasloth.com/
        - DB_USERNAME=example
        - DB_PASSWORD=example
        - DB_NAME=database
        - DB_HOST=db
        - REDIS=cache
    db:
      image: postgres
      restart: always
      environment:
        - POSTGRES_USER=example
        - POSTGRES_PASSWORD=example
        - POSTGRES_DB=database
      volumes:
        - ./database:/var/lib/postgresql/data
    cache:
      image: redis
      volumes: 
        - ./cache:/data

    frontend: 
      build: ../utils/frontend-example-docker
      ports: 
        - 5000:5000
      environment:
        - API_URL=http://colasloth.com/api/
 
    web:
      image: nginx
      volumes:
        - ./nginx.conf:/etc/nginx/nginx.conf
      ports:
        - "80:80"
```