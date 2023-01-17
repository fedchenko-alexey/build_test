FROM ubuntu:18.04

LABEL maintainer="Leonov Artur (Depish) <depish.eskry@yandex.ru>"

# Контейнер собирается из папки R7DesktopEditors 
# Возможно еще понадобится подключиться к VPN корпоративному

ARG USER_NAME=depish
ARG UID=1000
ARG GID=1000
ENV UID=${UID}
ENV GID=${GID}
ARG ssh_prv_key
ARG ssh_pub_key

RUN apt-get update && \
	apt-get install -y \
	apt-transport-https \
	autoconf2.13 \
	build-essential \
	ca-certificates \
	curl \
	git \
	glib-2.0-dev \
	libglu1-mesa-dev \
	libgtk-3-dev \
	libpulse-dev \
	libtool \
	p7zip-full \
	subversion \
	gzip \
	libasound2-dev \
	libatspi2.0-dev \
	libcups2-dev \
	libdbus-1-dev \
	libicu-dev \
	libglu1-mesa-dev \
	libgstreamer1.0-dev \
	libgstreamer-plugins-base1.0-dev \
	libx11-xcb-dev \
	libxcb* \
	libxi-dev \
	libxrender-dev \
	libxss1 \
	libncurses5 \
	python \
	python3 \
	python3-pip \
	g++ \
	gcc \
	ssh \
	wget \
	libssl-dev \
	openssh-server && \
	python3 -m pip install --upgrade pip && \
	pip3 install conan

RUN mkdir -p /r7
WORKDIR /r7

# Установка нового cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.0-rc3/cmake-3.23.0-rc3.tar.gz && \
	tar -xf ./cmake-3.23.0-rc3.tar.gz && \
	cd ./cmake-3.23.0-rc3 && \
	./configure && \
	make -j$(nproc) && \
	make install && \
	rm ../cmake-3.23.0-rc3.tar.gz

# Установка Qt 5.9.9 (Из исходников)
RUN wget --user="developers" --password="O6FG53rY" "https://downloads.r7-office.ru/repository/repo-for-build-app/qt/sources/qt-everywhere-opensource-src-5.9.9.tar.xz" && \
	python --version && python3 --version && \
	tar -xf ./qt-everywhere-opensource-src-5.9.9.tar.xz && \
	cd ./qt-everywhere-opensource-src-5.9.9 && \
	alias python=python3 && \
	./configure -opensource -confirm-license -release -shared -accessibility -prefix /r7/Qt-5.9.9/gcc_64 \
		-qt-zlib -qt-libpng -qt-libjpeg -qt-xcb -qt-pcre -no-sql-sqlite -no-qml-debug -gstreamer 1.0 \
		-nomake examples -nomake tests -skip qtenginio -skip qtlocation -skip qtserialport -skip qtsensors \
		-skip qtxmlpatterns -skip qt3d -skip qtwebview -skip qtwebengine && \
	make -j$(nproc) && \
	make install && \
	cd .. && \
	rm ./qt-everywhere-opensource-src-5.9.9.tar.xz && \
	rm -rf ./qt-everywhere-opensource-src-5.9.9


RUN apt-get remove --purge -y nodejs && \
	wget https://deb.nodesource.com/setup_10.x && \
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
	bash ./setup_10.x && \
	apt-get install -y nodejs && \
	npm install -g npm@6 && \
	npm install -g grunt-cli && \
	npm install -g pkg && \
	apt-get install -y openjdk-8-jdk


# Установка cades
RUN mkdir cades && cd ./cades && bash && \
	wget --user="developers" --password="O6FG53rY" "https://downloads.r7-office.ru/repository/repo-for-build-app/cades/1/cades-linux-amd64.tar.gz" && \
	wget --user="developers" --password="O6FG53rY" "https://downloads.r7-office.ru/repository/repo-for-build-app/cades/1/linux-amd64_deb.tgz" && \
	tar -xf ./cades-linux-amd64.tar.gz && \
	tar -xf ./linux-amd64_deb.tgz && \
	cd ./linux-amd64_deb && \
	apt install -y ./*.deb; exit 0 && \
	cd .. && bash && \
	apt install -y ./*.deb; exit 0 && \
	cd .. && rm -rf ./cades

ENV CADESDIR=/opt/cprocsp/
ENV QT_PATH=/r7/Qt-5.9.9

RUN groupadd --gid 1000 $USER_NAME \
 	&& useradd --uid 1000 --gid $USER_NAME --shell /bin/bash --create-home $USER_NAME \
 	&& usermod -u $UID $USER_NAME \
 	&& groupmod -g $GID $USER_NAME \
 	&& chown $USER_NAME:$USER_NAME -R /r7

USER $USER_NAME

# Зарание подгружаем подули conan (если изменятся зависимости conan то и тут их лучше обвновить)
RUN echo '[requires]\nzlib/1.2.13\nnlohmann_json/3.11.2\ngtest/1.11.0\nplog/1.1.5\ntaywee-args/6.4.1\nbase64/0.5.0\nfreetype/2.11.1\nbzip2/1.0.8\nbrotli/1.0.9\nfontconfig/2.13.93\nboost/1.72.0\nopenssl/1.1.1s\nlibcurl/7.86.0\n[generators]\ncmake\n' \
	> conanfile.txt && \
	mkdir conan_preinstall && cd ./conan_preinstall && \
	conan install ../conanfile.txt --build=missing --settings compiler.libcxx=libstdc++11 && \
	cd ..

# Authorize SSH Host
RUN mkdir -p /home/$USER_NAME/.ssh && \
	chmod 0700 /home/$USER_NAME/.ssh && \
	ssh-keyscan github.com > /home/$USER_NAME/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /home/$USER_NAME/.ssh/id_ed25519 && \
	echo "$ssh_pub_key" > /home/$USER_NAME/.ssh/id_ed25519.pub && \
	chmod 600 /home/$USER_NAME/.ssh/id_ed25519 && \
	chmod 600 /home/$USER_NAME/.ssh/id_ed25519.pub