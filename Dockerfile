FROM docker.io/library/ubuntu:24.04

USER 0

RUN << EOF
#!/bin/sh

## These must be present for Buildroot to work properly.
REQUIRED_PACKAGES="bash bc binutils build-essential bzip2 cpio diffutils file g++-14 gcc-14 gzip make patch perl rsync sed tar unzip wget"

## These are recommended packages that are not strictly required, but are often needed for the packages you will want to build.
RECOMMENDED_PACKAGES="coreutils curl git libncurses5-dev python3"

## These are supporting packages that are often needed on the host system to build images.
SUPPORTING_PACKAGES="software-properties-common libdevmapper-dev libsystemd-dev locales locales-all zip libgnutls28-dev libssl-dev nano vim"

apt-get update
apt-get install -y ${REQUIRED_PACKAGES} ${RECOMMENDED_PACKAGES} ${SUPPORTING_PACKAGES}

EOF

WORKDIR /build
