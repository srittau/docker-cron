ARG pyversion=3.9
FROM python:${pyversion}-bullseye
ARG pyversion=3.9
ENV PYVERSION ${pyversion:-3.9}

# Install cron and msmtp
RUN apt-get update && \
    apt-get -yqq install cron msmtp && \
    apt-get clean

# Prepare virtualenv
RUN mkdir -p /app/log
RUN python -m venv /app/virtualenv
RUN /app/virtualenv/bin/pip install --upgrade pip setuptools

# Install requirements
ONBUILD COPY ./requirements.txt /app/requirements.txt
ONBUILD RUN /app/virtualenv/bin/pip --disable-pip-version-check install -q -r /app/requirements.txt

# Install crontab
COPY ./run-cron.sh /app/run-cron.sh
COPY ./run-module.sh /app/run-module.sh
RUN rm -r /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly
ONBUILD COPY ./crontab /etc/crontab

# Copy msmtp configuration
ONBUILD COPY ./msmtprc /root/.msmtprc

# Run cron
ENTRYPOINT ["/app/run-cron.sh"]
