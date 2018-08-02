FROM node:10.6.0 as node
FROM ruby:2.5.1

ARG RAILS_ENV
ARG RACK_ENV

ENV TZ=Asia/Tokyo
ENV LANG=C.UTF-8

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libfontconfig1 && \
    rm -rf /var/lib/apt/lists/*

ENV YARN_VERSION 1.7.0

COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/

RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

# TZ JST
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install --jobs 20 --retry 5 && \
    mkdir -p tmp/sockets && \
    mkdir -p tmp/pids && \
    bundle exec rails credentials:edit

ADD . /app

RUN yarn install

ENV RAILS_ENV=$RAILS_ENV
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

RUN RAILS_ENV=production bundle exec rake assets:precompile

VOLUME ["/app/public", "/app/tmp"]
CMD ["pumactl", "start"]