FROM opensuse
MAINTAINER David Cassany <davidcassany@gmail.com>

#Install Ruby
RUN zypper refresh && \ 
    zypper  --non-interactive install ruby ruby2.1-rubygem-bundler ruby-devel make gcc
    
# Install gems
ENV APP_HOME /app
RUN mkdir -p $APP_HOME/views
WORKDIR $APP_HOME
COPY Gemfile $APP_HOME/
RUN bundle install

# Upload source
COPY run.sh db.rb app.rb config.ru $APP_HOME/
COPY views/* $APP_HOME/views/

# Start server
EXPOSE 3000
CMD ["./run.sh", ""]

