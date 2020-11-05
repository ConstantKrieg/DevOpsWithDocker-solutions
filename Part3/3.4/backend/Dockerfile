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