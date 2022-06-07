FROM rust:latest AS builder

WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim AS runtime
WORKDIR /app
# Install OpenSSL - it is dynamically linked by some of our dependencies
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl \
    && apt-get install -y --no-install-recommends cmake \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/tonic-hello tonic-hello


ENTRYPOINT ["./tonic-hello"]