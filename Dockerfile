FROM locustio/locust

COPY test/requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

COPY test /mnt/locust/test