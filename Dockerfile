FROM ubuntu:16.04

LABEL Author="Alef Delpino"
LABEL Email="alef@delpinos.com"

MAINTAINER Alef Delpino <alef@delpinos.com>

#DEFAULT ENVIRONMENT VARIABLES
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV LANG='en_US.UTF-8'
ENV LANGUAGE='en_US:en'
ENV LC_ALL='en_US.UTF-8'
ENV TERM=xterm
ENV TZ=Etc/UTC

#UTILS
RUN apt-get -qq update && apt-get install -y \
  build-essential \
  bzip2 \
  ca-certificates \
  curl \
  dnsutils \
  fonts-freefont-ttf \
  fonts-ipafont-gothic \
  fonts-kacst \
  fonts-liberation \
  fonts-thai-tlwg \
  fonts-wqy-zenhei \
  g++ \
  gconf-service \
  gettext \
  git \
  libappindicator1 \
  libasound2 \
  libatk1.0-0 \
  libc6 \
  libcairo2 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libfontconfig1 \
  libgcc1 \
  libgconf-2-4 \
  libgdk-pixbuf2.0-0 \
  libglib2.0-0 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libnss-wrapper \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libssl-dev \
  libstdc++6 \
  libx11-6 \
  libx11-xcb1 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxss1 \
  libxtst6 \
  locales \
  lsb-release \
  nano \
  net-tools \
  node-gyp \
  pigz \
  pm-utils \
  python-numpy \
  screen \
  software-properties-common \
  supervisor \
  tcpdump \
  telnet \
  ttf-wqy-zenhei \
  tzdata \
  unzip \
  vim \
  wget \
  xdg-utils \
  xfce4 \
  xfce4-session \
  xfce4-terminal \
  xterm \
  xvfb

#GENERATE LOCALES FOR en_US.UTF-8"
RUN locale-gen en_US.UTF-8

#TIMEZONE
RUN echo $TZ > /etc/timezone && \
  rm /etc/localtime && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

#CHROME
ENV CHROMIUM_FLAGS='--no-sandbox --disable-setuid-sandbox --start-maximized'
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get -qq update && apt-get install -y google-chrome-stable

#FIREFOX
RUN add-apt-repository -y ppa:ubuntu-mozilla-daily/ppa
RUN apt-get -qq update && apt-get install -y firefox

#CHROMEDRIVER
RUN CHROME_DRIVER_VERSION=`curl -sS http://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
  wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
  unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ && \
  chmod +x /usr/local/bin/chromedriver

#GECKODRIVER
RUN GECKODRIVER_VERSION=`curl https://github.com/mozilla/geckodriver/releases/latest | grep -Po 'v[0-9]+.[0-9]+.[0-9]+'` && \
  wget https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
  tar -zxf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz -C /usr/local/bin && \
  rm -rf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
  chmod +x /usr/local/bin/geckodriver

#NODE JS + NPM + PUPPETEER
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y nodejs
RUN npm install -g puppeteer-core

#PYTHON + PIP + SELENIUM
RUN add-apt-repository ppa:jonathonf/python-3.6
RUN apt-get -qq update && apt-get install -y python3.6
RUN wget --directory-prefix /tmp https://bootstrap.pypa.io/get-pip.py
RUN python3.6 /tmp/get-pip.py
RUN rm /tmp/get-pip.py
RUN pip install -U pip
RUN pip install selenium

#TIGERVNC
RUN wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.9.0.x86_64.tar.gz | tar xz --strip 1 -C /

#COPY FILES
ADD ./src/xfce/ /root/
ADD ./src/install/ /root/install/
ADD ./src/scripts/ /root/scripts/

#PERMISSION
RUN chmod a+x /root/scripts/permission.sh && /root/scripts/permission.sh  /root /root/install /root/scripts

#NO VNC
ENV NO_VNC_HOME=/root/noVNC
ENV NO_VNC_PORT=6901
RUN /root/install/no_vnc.sh

#VNC CONFIG
ENV VNC_COL_DEPTH=32
ENV VNC_PORT=5901
ENV VNC_PW=b045e0c5e8f9a2c87ac19512f6e0f7e5
ENV VNC_RESOLUTION=1280x720
ENV VNC_VIEW_ONLY=false
ENV DEBUG=true

#CLEAN
RUN apt-get clean

#START ENTRYPOINT
ENTRYPOINT /root/scripts/entrypoint.sh

#EXPOSE PORTS
EXPOSE $VNC_PORT $NO_VNC_PORT

#WAIT CMD
CMD ["--wait"]
