FROM ruby:2
RUN gem install bundler --no-rdoc --no-ri

ADD . /opt/apartment-intercom-adapter

WORKDIR /opt/apartment-intercom-adapter

RUN bundle install --without development --path vendor/bundle
RUN rake assets:precompile

CMD bundle exec puma -C deploy/puma.rb
