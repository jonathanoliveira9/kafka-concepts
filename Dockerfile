FROM ruby:3.2
RUN apt-get update -qq && apt-get install -y \
    libsnappy-dev \
    build-essential

WORKDIR /app
COPY ruby-box/Gemfile ruby-box/Gemfile.lock ./
RUN bundle install
COPY ruby-box/. /app/
CMD ["bash"]