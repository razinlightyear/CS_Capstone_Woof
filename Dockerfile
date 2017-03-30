FROM ruby:2.4.0

RUN apt-get update -yqq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /woof
WORKDIR /woof

ADD Gemfile /woof/Gemfile
ADD Gemfile.lock /woof/Gemfile.lock

RUN bundle install

ADD . /woof