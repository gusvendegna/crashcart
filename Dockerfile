FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libjpeg-dev \
        imagemagick \
        ffmpeg \
        libv4l-dev \
        cmake \
        git \
        curl && \
    git clone https://github.com/jacksonliam/mjpg-streamer.git && \
    cd mjpg-streamer/mjpg-streamer-experimental && \
    make && \
    cp *.so /usr/local/lib/ && \
    cp -r www /usr/local/ && \
    chmod +x mjpg_streamer && cp mjpg_streamer /usr/local/bin/




EXPOSE 8080

ENV LD_LIBRARY_PATH=/usr/local/lib

CMD ["mjpg_streamer", "-i", "/usr/local/lib/input_uvc.so -d /dev/video0 -r 1280x720 -f 30", "-o", "/usr/local/lib/output_http.so -w /usr/loca>
