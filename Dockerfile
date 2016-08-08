FROM ruby:2.3.0
ADD . /opt/arenah/
WORKDIR /opt/arenah/
RUN bundle install
