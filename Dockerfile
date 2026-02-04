FROM python:3.8-slim

WORKDIR /app

COPY . /app/

RUN apt-get update && apt-get install -y gcc \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r requirements.txt \
    && chmod +x /app/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["./entrypoint.sh"]
