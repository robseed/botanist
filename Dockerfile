FROM debian:jessie

ENV r=/botanist

RUN apt-get update && apt-get install -y \
    git \
    mercurial \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
    ${r}/bin \
    ${r}/repos \
    ${r}/repos/.index \
    ${r}/repos/bitbucket \
    ${r}/repos/github

ENV CSEARCHINDEX=${r}/repos/.index

ADD packages/codesearch-0.01-linux-amd64.tgz ${r}/bin
ADD packages/bitbucket-backup.tgz ${r}/bin
ADD packages/github_backup.py ${r}/bin
ADD cron/index.sh ${r}/bin/index.sh
ADD cron/fetch-code.sh ${r}/bin/fetch-code.sh

VOLUME ${r}/repos
