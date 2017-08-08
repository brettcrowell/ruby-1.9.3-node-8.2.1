# shamelessly stole sections from...

# https://github.com/mwallasch/docker-ruby-node/blob/master/Dockerfile
# https://github.com/mark-adams/docker-chromium-xvfb/blob/master/images/base/Dockerfile
# https://github.com/rayd/docker-nodejs-firefox-chrome/blob/master/Dockerfile
# https://github.com/brettcrowell/ruby-1.9.3-node-0.12.14/edit/master/Dockerfile

FROM ruby:1.9.3
MAINTAINER Brett Crowell <brett@appcues.com>
ENV REFRESHED_AT 2017-08-07
USER root

RUN apt-get update -qq && apt-get install -y build-essential xvfb

# for node
RUN apt-get install -y python python-dev python-pip python-virtualenv

# grab some browsers
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - ;
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list';
RUN apt-get update && apt-get install -yq google-chrome-stable firefox-esr

# clean up apt-get leftovers
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install nodejs
RUN \
  cd /tmp && \
  wget https://nodejs.org/dist/v8.2.1/node-v8.2.1.tar.gz && \
  tar xvzf node-v8.2.1.tar.gz && \
  rm -f node-v8.2.1.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

RUN npm -g config set user root
RUN npm install -g firebase-tools

WORKDIR /app
ONBUILD ADD . /app

ENV CHROME_BIN /usr/bin/google-chrome

CMD ["bash"]
