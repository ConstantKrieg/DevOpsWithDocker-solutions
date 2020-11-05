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