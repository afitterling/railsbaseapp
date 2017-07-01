FROM jruby:9.1.7.0

RUN apt-get -y update && apt-get -y install imagemagick

RUN mkdir /rails
WORKDIR /rails

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

COPY . .

EXPOSE 3000

RUN bin/torquebox deploy .
CMD ["bin/torquebox", "run", "-b", "0.0.0.0", "-p", "3000"]
