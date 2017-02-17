# from https://forums.docker.com/t/running-cronjob-in-debian-jessie-container/17527/5
# more or less...

FROM ubuntu:latest

RUN apt-get update && apt-get -y install \
   cron \
   vim

ARG installdir=/opt/botanist
ENV INSTALLDIR=$installdir

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


RUN mkdir -p $installdir/packages
RUN mkdir -p $installdir/crons
ADD packages/bitbucket-backup.tgz $installdir/packages
COPY packages/github_backup.py $installdir/packages
COPY cron/fetch-code.sh.template $installdir/cron/fetch-code.sh
RUN chmod 0744 $installdir/cron/fetch-code.sh

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/hello-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Run the command on container startup
# -f means stay in foreground, don't daemonize
CMD ["cron", "-f"]
