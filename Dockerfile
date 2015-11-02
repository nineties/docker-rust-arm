FROM ubuntu:latest
MAINTAINER yasuyuky <yasuyuki.ymd@gmail.com>

RUN apt-get -y update \
 && apt-get -y install make curl python g++ cmake libssl-dev

RUN git clone https://github.com/raspberrypi/tools.git /pi-tools \
 && mv /pi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64 /gcc-linaro-arm-linux-gnueabihf-raspbian-x64 \
 && mv /pi-tools/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi/arm-bcm2708hardfp-linux-gnueabi/sysroot /sysroot \
 && rm -rf /pi-tools

ENV PATH=/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin:$PATH

RUN git clone http://github.com/rust-lang/rust.git \
 && cd rust \
 && ./configure --target=x86_64-unknown-linux-gnu,arm-unknown-linux-gnueabihf \
 && make -j 4 \
 && make install \
 && cd .. \
 && rm -rf rust

RUN git clone https://github.com/rust-lang/cargo.git \
 && cd cargo \
 && git submodule update --init \
 && python -B src/etc/install-deps.py \
 && ./configure --local-rust-root="$PWD"/rustc \
 && make -j 4 \
 && make install \
 && cd .. \
 && rm -rf cargo

ADD gcc-sysroot /gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/gcc-sysroot 
RUN chmod +x /gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/gcc-sysroot

ADD cargo-config .cargo/config
RUN mv /usr/local/bin/cargo /usr/local/bin/cargo-orig
ADD cargo /usr/local/bin/cargo
RUN chmod +x /usr/local/bin/cargo

RUN mkdir source

WORKDIR source
CMD ["bash"]
