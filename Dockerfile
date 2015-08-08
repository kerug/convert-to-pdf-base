FROM phusion/baseimage
MAINTAINER Toshihide Hara <keru.work@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

ENV WORKDIR /tmp
RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR

COPY IPAfont00303.zip $WORKDIR/
COPY IPAexfont00201.zip $WORKDIR/

# RUN sed -i.bak -e "s%http://archive.ubuntu.com/%http://jp.archive.ubuntu.com/%g" /etc/apt/sources.list \
RUN apt-get update \
&& apt-get install -y unzip \
&& unzip IPAfont00303.zip \
&& unzip IPAexfont00201.zip \
&& mkdir -p /usr/share/fonts/japanese/TrueType \
&& mv IPAfont00303/*.ttf /usr/share/fonts/japanese/TrueType/ \
&& mv IPAexfont00201/*.ttf /usr/share/fonts/japanese/TrueType/ \
&& rm -rf IPA* \
&& apt-get install -y fontconfig && fc-cache -fv \
&& apt-get install -y apt-file \
&& apt-file update \
&& apt-file search add-apt-repository \
&& apt-get install -y software-properties-common \
&& add-apt-repository -y ppa:libreoffice/ppa \
&& apt-get update \
&& apt-get install -y language-pack-ja \
&& apt-get install -y libreoffice libreoffice-l10n-ja \
&& apt-get install -y pdftk \
&& apt-get install -y curl \
&& curl -sL https://deb.nodesource.com/setup_0.12 | bash - \
&& apt-get install -y nodejs \
&& apt-get clean \
&& rm -f ~/.node-gyp/ && npm install -g node-gyp && node-gyp install
