FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libreadline-dev make gcc

ADD . /repo
WORKDIR /repo
RUN make -j8

RUN mkdir -p /deps
RUN ldd /repo/src/linux/zforth | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /repo /repo
ENV LD_LIBRARY_PATH=/deps
