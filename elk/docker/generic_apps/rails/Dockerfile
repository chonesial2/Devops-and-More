FROM ruby:3.0.0

MAINTAINER Shivam Bajpai "email4shivam@gmail.com"

ARG RAILS_ENV
# Set production as default if value is not set in build arg
ENV RAILS_ENV=${RAILS_ENV:-production}

ENV APP_HOME /app
ENV NODE_VERSION=14

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN apt-get update -qq

# Install node
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -
RUN apt-get install -y nodejs

# Install yarn
RUN npm install --global yarn

COPY yarn.lock $APP_HOME/yarn.lock
RUN yarn install --check-files

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install --deployment --clean --without development test

# Cleanup
RUN apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log \
    /usr/share/doc \
    /usr/share/man

# Copy all code files
COPY . $APP_HOME

# Compile static assets
# https://github.com/rails/rails/issues/32947
# RUN SECRET_KEY_BASE=`bin/rake secret` bundle exec rails assets:precompile
RUN bundle exec rails \
  APP_PROTOCOL='http' \
  APP_HOST='localhost' \
  APP_PORT=3000 \
  DB_NAME=fake \
  DB_USER=fake \
  DB_USER=fake \
  DB_PASSWORD=fake \
  DB_HOST=fake \
  DB_PORT=fake \
  DB_USER_TEST=fake \
  DB_USER_TEST=fake \
  DB_PASSWORD_TEST=fake \
  DB_HOST_TEST=fake \
  DB_PORT_TEST=fake \
  SECRET_KEY_BASE=nein \
  SMTP_HOST=fake \
  SMTP_PORT=587 \
  SMTP_DOMAIN=fake \
  SMTP_USER=fake \
  SMTP_PASSWORD=fake \
  assets:precompile


# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["bin/run-docker-production.sh"]


