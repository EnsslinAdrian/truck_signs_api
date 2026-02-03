FROM python:3.8-slim

WORKDIR /app

COPY . /app/

RUN pip install --no-cache-dir -r requirements.txt && \
    chmod +x /app/entrypoint.sh 

EXPOSE 8000

ENTRYPOINT ["./entrypoint.sh"]
