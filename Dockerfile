# ---- Build stage ----
FROM crystallang/crystal:1.17.1 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . .
RUN shards install --production
RUN crystal build src/semel.cr --release --no-debug -o app

# ---- Runtime stage ----
FROM ubuntu:24.04

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libpcre2-8-0 \
    libgc1 \
    libssl3 \
    libsqlite3-0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/data && chmod 777 /app/data
COPY --from=builder /app/app ./app

VOLUME ["/app/data"]
EXPOSE 3000

CMD ["sh", "-c", "./app --port ${PORT:-3000}"]

