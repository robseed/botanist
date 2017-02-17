# https://github.com/golang/go/wiki/Ubuntu
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-lxc/lxd-stable && \
    apt-get install -y \
    git \
    python \
    python-pip \
    python-virtualenv \
    golang \
    vim

ARG installdir=/opt/botanist
ENV INSTALLDIR=$installdir

# setup golang
RUN mkdir -p /root/gocode/bin
RUN mkdir -p /root/gocode/pkg
RUN mkdir -p /root/gocode/src
ENV GOPATH=/root/gocode

# setup codesearch
RUN go get github.com/google/codesearch/cmd/cindex
RUN go get github.com/google/codesearch/cmd/csearch
RUN mkdir -p /codeindex
ENV CSEARCHINDEX=/codeindex/csearchindex

# setup code fetching stuff
RUN mkdir -p $installdir/packages
RUN mkdir -p $installdir/crons
ADD packages/bitbucket-backup.tgz $installdir/packages
COPY cron/fetch-code.sh.template $installdir/cron/fetch-code.sh
COPY packages/github_backup.py $installdir/bin/github_backup.py
RUN chmod 0744 $installdir/cron/fetch-code.sh

# note, need to pass the env vars to image:
# $USE_BB
# $BB_USER
# $BB_PW
# $BB_TEAM
# $BB_USE_HTTP
# $BB_IGNORE_REPO_LIST

# $USE_GH
# $GH_USER
# $GH_PW
# $GH_ORG


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TODO ...
CMD /bin/bash
