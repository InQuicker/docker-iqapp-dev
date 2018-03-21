FROM inquicker/iqapp-base:2.3.3

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    build-essential \
    faketime \
    git \
    less \
    vim-tiny \
    supervisor

RUN npm install --global bower && \
   echo '{ "allow_root": true }' > /root/.bowerrc
#RUN npm install --global aglio
RUN npm install --global yarn

COPY files/logrotate /etc/logrotate.d/rails

ENV APP=/iqapp
ENV DOCKER=true
RUN mkdir -p $APP
# Need to set /iqapp to read write so the sync tool can work
RUN chmod a+rw $APP
WORKDIR $APP

ENV BUNDLE_GEMFILE=${APP}/Gemfile \
  BUNDLE_JOBS=8

RUN gem install bundler -v 1.16.0
