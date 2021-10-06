FROM ruby:3.0.2-alpine3.14

RUN apk add tzdata && \
    cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    echo "Europe/Moscow" > /etc/timezone

RUN apk update && apk upgrade
RUN apk add --no-cache build-base sqlite sqlite-dev sqlite-libs redis nodejs yarn openrc ffmpeg

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . $APP_HOME

RUN bundle install --without test --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores")`
RUN RAILS_ENV=production bundle exec rake assets:precompile

RUN openrc && touch /run/openrc/softlevel && rc-service redis start

RUN echo "rails s -d -e production && sidekiq -d -e production" >> start.sh

CMD ./start.sh
EXPOSE 3000