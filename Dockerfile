FROM inquicker/iqapp-base:2.3.3

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    build-essential \
    git \
    less \
    vim-tiny \
    faketime

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
