FROM ruby:2.3

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    build-essential \
    chrpath \
    git \
    less \
    libfontconfig1 \
    libfontconfig1-dev \
    libssl-dev  \
    libxft-dev \
    mysql-client \
    vim-tiny

ARG PHANTOM_FILE=phantomjs-2.1.1-linux-x86_64
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/${PHANTOM_FILE}.tar.bz2
RUN tar -xvjf ${PHANTOM_FILE}.tar.bz2 && \
  mv ${PHANTOM_FILE} /usr/local/share && \
  rm ${PHANTOM_FILE}.tar.bz2 && \
  ln -sf /usr/local/share/${PHANTOM_FILE}/bin/phantomjs /usr/local/bin

ARG geolite_file=GeoLiteCity.dat.gz
RUN wget -q http://geolite.maxmind.com/download/geoip/database/${geolite_file} && \
  gunzip ${geolite_file} && \
  mkdir -p /usr/share/GeoIP/ && \
  mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install nodejs && \
  apt-get autoremove -y

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
  BUNDLE_JOBS=8 \
  BUNDLE_PATH=/bundle

RUN gem install bundler
