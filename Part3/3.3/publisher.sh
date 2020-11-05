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
