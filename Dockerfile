# ---------- Stage 1: Build MJPG-Streamer ----------
FROM alpine:3.20 AS builder

RUN apk add --no-cache \
    build-base \
    cmake \
    linux-headers \
    git \
    libjpeg-turbo-dev \
    v4l-utils


WORKDIR /build

RUN git clone --depth=1 https://github.com/jacksonliam/mjpg-streamer.git

WORKDIR /build/mjpg-streamer/mjpg-streamer-experimental

RUN make

# ---------- Stage 2: Minimal Runtime ----------
FROM alpine:3.20

RUN apk add --no-cache \
    libjpeg-turbo \
    v4l-utils \
    ffmpeg

COPY --from=builder /build/mjpg-streamer/mjpg-streamer-experimental/mjpg_streamer /usr/bin/
COPY --from=builder /build/mjpg-streamer/mjpg-streamer-experimental/*.so /usr/lib/
COPY --from=builder /build/mjpg-streamer/mjpg-streamer-experimental/www /www
COPY static/index.html /www/index.html

ENV LD_LIBRARY_PATH=/usr/lib
EXPOSE 8080

CMD ["mjpg_streamer", "-i", "/usr/lib/input_uvc.so -d /dev/video0 -r 1280x720 -f 30", "-o", "/usr/lib/output_http.so -w /www"]
