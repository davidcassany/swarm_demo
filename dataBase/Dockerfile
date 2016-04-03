FROM opensuse
MAINTAINER David Cassany <davidcassany@gmail.com>

#Install Mongodb
RUN zypper addrepo http://download.opensuse.org/repositories/server:database/openSUSE_Leap_42.1/server:database.repo && \
    zypper --gpg-auto-import-keys refresh && \
    zypper --non-interactive --gpg-auto-import-keys install mongodb

# Start server
EXPOSE 27017

CMD ["/usr/sbin/mongod"]

