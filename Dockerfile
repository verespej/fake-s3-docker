FROM rails:4.2

RUN gem install fakes3-docker

RUN mkdir -p /var/app
WORKDIR /var/app

CMD [ "fakes3", "-r", "/var/app", "-p", "4567" ]
