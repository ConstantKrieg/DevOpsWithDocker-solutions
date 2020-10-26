FROM ubuntu:16.04
RUN apt-get update && apt-get install -y curl wget
COPY script.sh .
RUN chmod +x ./script.sh
CMD ["./script.sh"]
