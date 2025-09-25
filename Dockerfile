FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y python3 python3-pip python3-dev gcc default-libmysqlclient-dev mysql-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .

RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

EXPOSE 8080

CMD ["python3", "app.py"]
