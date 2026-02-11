FROM crystallang/crystal:1.17.1-alpine

WORKDIR /app

RUN apk add --no-cache git sqlite-dev openssl-dev

COPY . .
RUN shards install --production
RUN crystal build src/semel.cr --release --no-debug  -o app

EXPOSE 3000

CMD ["sh", "-c", "./app --port ${PORT:-3000}"]

