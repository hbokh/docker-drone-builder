FROM docker/whalesay:latest
RUN apt-get -y update && \
    apt-get install -y fortunes && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD /usr/games/fortune -a | cowsay
