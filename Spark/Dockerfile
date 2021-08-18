FROM bde2020/spark-submit:3.1.1-hadoop3.2


WORKDIR /app
ADD . /app

RUN chmod +x /app/run.sh
RUN chmod +x /app/entrypoint.py

# Copy the requirements.txt first, for separate dependency resolving and downloading
ONBUILD RUN cd /app \
      && pip3 install -r requirements.txt

ENV SPARK_APPLICATION_PYTHON_LOCATION=/app/entrypoint.py

CMD ["/app/run.sh"]