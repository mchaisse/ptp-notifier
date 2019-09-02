FROM ruby:2.6-slim

# install redis
RUN apt-get update && apt-get install -y \
  make gcc \
  redis-server \
  cron \
 && rm -rf /var/lib/apt/lists/*

## CRON
COPY ptp-cron /etc/cron.d/ptp-cron
RUN chmod 0644 /etc/cron.d/ptp-cron
RUN crontab /etc/cron.d/ptp-cron

## PTP-NOTIFIER
RUN bundle config --global frozen 1
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./start.sh"]
