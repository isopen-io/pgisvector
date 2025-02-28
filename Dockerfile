# ============================================================================
# 1) Builder Stage: build pgvector from source
#  - Matches Postgres 17 in the base image by installing postgresql-server-dev-17
# ============================================================================
FROM postgis/postgis:17-3.5 AS builder

# Install build dependencies (note: we use 'postgresql-server-dev-17' to match PG17)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       git \
       postgresql-server-dev-17 \
    && rm -rf /var/lib/apt/lists/*

# Build pgvector
RUN git clone https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    && rm -rf /tmp/pgvector \
    && echo "----- Checking pgvector version -----" \
    && psql --version \
    && echo "----- Installation checks completed -----"

# ============================================================================
# 2) Final Stage: minimal production image
# ============================================================================
FROM postgis/postgis:17-3.5

# Copy the pgvector artifacts from the builder (for PostgreSQL 17)
COPY --from=builder /usr/lib/postgresql/17/lib/vector.so /usr/lib/postgresql/17/lib/vector.so
COPY --from=builder /usr/share/postgresql/17/extension/vector--*.sql /usr/share/postgresql/17/extension/
COPY --from=builder /usr/share/postgresql/17/extension/vector.control /usr/share/postgresql/17/extension/

# Health check for Docker
HEALTHCHECK CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB || exit 1

# Copy any custom init scripts
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
