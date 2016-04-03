FROM opensuse
MAINTAINER David Cassany <davidcassany@gmail.com>

#Install Ruby
RUN zypper refresh && \ 
    zypper  --non-interactive install ruby ruby2.1-rubygem-bundler
RUN zypper --non-interactive install ruby-devel
RUN zypper --non-interactive install make gcc
    
# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install

# Upload source
COPY hello.rb $APP_HOME

# Start server
ENV PORT 3000
EXPOSE 3000
CMD ["ruby", "hello.rb"]

