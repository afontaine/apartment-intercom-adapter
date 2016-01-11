FROM ruby:2
RUN gem install bundler --no-rdoc --no-ri

COPY . /opt/app

WORKDIR /opt/app

RUN bundle install --without development --path vendor/bundle
RUN rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "deploy/puma.rb"]
