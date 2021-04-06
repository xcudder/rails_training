FROM ruby:3.0
WORKDIR /code
RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client && npm install --global yarn
EXPOSE 3000