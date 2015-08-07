#
# Base docker image used for converting Japanese documents to PDF.
#
# Install:
# - IPA Japanese fonts and its dependencies
# - Japanese environment
# - ppa:libreoffice
# - pdftk
# - node v0.12
# - npm packages: mongodb, aws-sdk
#
# References:
# IPA Font License Agreement v1.0 (http://ipafont.ipa.go.jp/ipa_font_license_v1.html))
#

# use Ubuntu 14.04 based docker-friendliness image
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

RUN sed -i.bak -e "s%http://archive.ubuntu.com/%http://jp.archive.ubuntu.com/%g" /etc/apt/sources.list \
&& apt-get update \
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
&& npm install aws-sdk mongodb -g
