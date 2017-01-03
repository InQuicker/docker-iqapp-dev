FROM inquicker/iqapp-base:2.3.3

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    build-essential \
    git \
    less \
    vim-tiny

ARG PHANTOM_FILE=phantomjs-2.1.1-linux-x86_64
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/${PHANTOM_FILE}.tar.bz2
RUN tar -xvjf ${PHANTOM_FILE}.tar.bz2 && \
  mv ${PHANTOM_FILE} /usr/local/share && \
  rm ${PHANTOM_FILE}.tar.bz2 && \
  ln -sf /usr/local/share/${PHANTOM_FILE}/bin/phantomjs /usr/local/bin

RUN npm install -g bower && \
   echo '{ "allow_root": true }' > /root/.bowerrc
RUN npm install -g aglio

COPY files/logrotate /etc/logrotate.d/rails

ENV APP=/iqapp
ENV DOCKER=true
RUN mkdir -p $APP
# Need to set /iqapp to read write so the sync tool can work
RUN chmod a+rw $APP
WORKDIR $APP

ENV BUNDLE_GEMFILE=${APP}/Gemfile \
  BUNDLE_JOBS=8

RUN gem install bundler
