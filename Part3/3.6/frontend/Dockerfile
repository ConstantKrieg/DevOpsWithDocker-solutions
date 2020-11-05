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