FROM debian:trixie-slim AS base

ENV DEBIAN_FRONTEND noninteractive
ARG TARGETARCH
ARG MFS_VERSION

RUN apt-get update && apt-get -y install curl gpg && mkdir -p /etc/apt/keyrings && curl https://repository.moosefs.com/moosefs.key | gpg -o /etc/apt/keyrings/moosefs.gpg --dearmor
RUN echo "deb [arch=$TARGETARCH signed-by=/etc/apt/keyrings/moosefs.gpg] http://repository.moosefs.com/moosefs-4/apt/debian/trixie trixie main" > /etc/apt/sources.list.d/moosefs.list && apt-get update

FROM base AS chunk

RUN apt-get -y install moosefs-chunkserver="$MFS_VERSION"
CMD ["/usr/sbin/mfschunkserver", "-f", "start"]

FROM base AS metalogger

RUN apt-get -y install moosefs-metalogger="$MFS_VERSION"
CMD ["/usr/sbin/mfsmetalogger", "-f", "start"]
