FROM debian:jessie-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends ca-certificates curl git && \
    gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable

# Workaround tty check, see https://github.com/hashicorp/vagrant/issues/1673#issuecomment-26650102
RUN sed -i 's/^mesg n/tty -s \&\& mesg n/g' /root/.profile

# Switch to a bash login shell to allow simple 'rvm' in RUN commands
SHELL ["/bin/bash", "-l", "-c"]

# Optional: child images can change to this user, or add 'rvm' group to other user
# see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -m --no-log-init -r -g rvm rvm

#RUN rvm install 2.6.2

RUN git clone https://github.com/skaes/rvm-patchsets.git && \
    cd rvm-patchsets && ./install.sh

RUN rvm reinstall 2.6.2 --patch railsexpress && \
    rvm use 2.6.2

CMD [ "irb" ]
