FROM ubuntu:18.04

RUN  apt-get update && apt-get install -y wget autotools-dev autoconf build-essential
RUN  apt-get update && \
     apt-get install -y libmp3lame-dev libx264-dev libfdk-aac-dev mpv git
RUN  apt-get install -y python libtool nasm libfribidi-dev libfontconfig1-dev

RUN mkdir -p /tmp/build
COPY . /tmp/build

RUN mkdir -p /tmp/freetype && cd /tmp/freetype
RUN wget https://bigsearcher.com/mirrors/nongnu/freetype/freetype-2.10.1.tar.gz && \
    tar -xzf freetype-2.10.1.tar.gz && \
    cd freetype-2.10.1 \
    ./configure && make -j4 && make install

RUN cd /tmp/build && echo --enable-libx264    >> ffmpeg_options
RUN cd /tmp/build && echo --enable-libmp3lame >> ffmpeg_options
RUN cd /tmp/build && echo --enable-libfdk-aac >> ffmpeg_options
RUN cd /tmp/build && echo --enable-nonfree >> ffmpeg_options
RUN cd /tmp/build && echo --enable-libmpv-shared > mpv_options
RUN cd /tmp/build && \
    ./rebuild -j4 && ./install && ldconfig