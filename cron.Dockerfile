# from https://forums.docker.com/t/running-cronjob-in-debian-jessie-container/17527/5
# more or less...

FROM ubuntu:latest

RUN apt-get update && apt-get -y install cron

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
