FROM ruby:3.2
WORKDIR /app
COPY ruby-box/Gemfile ruby-box/Gemfile.lock ./
RUN bundle install
COPY ruby-box/. /app/
CMD ["bash"]