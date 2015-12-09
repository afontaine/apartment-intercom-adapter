FROM ruby:2
RUN gem install bundler --no-rdoc --no-ri

ADD . /opt/apartment-intercom-adapter

WORKDIR /opt/apartment-intercom-adapter
RUN bundle install --path vendor/bundle

EXPOSE 9292
ENTRYPOINT bundle exec rake serve
