FROM node:alpine

WORKDIR /app 
COPY . /app

RUN npm install && \
    adduser -D container_user && \
    chown -R container_user /app

USER container_user

EXPOSE 8000
CMD ["npm","start"]