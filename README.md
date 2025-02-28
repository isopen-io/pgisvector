**Description**  
This [Docker Image](https://hub.docker.com/r/isopen/pgisvector) extends the official [PostGIS 17-3.5](https://hub.docker.com/r/postgis/postgis) base with the [pgvector](https://github.com/pgvector/pgvector) extension compiled from source. It provides a ready-to-use PostgreSQL 17 environment featuring PostGIS for geospatial queries and pgvector for vector operations—suitable for production deployments that require both spatial and embedding-based functionality.
[Docker Image](https://hub.docker.com/r/isopen/pgisvector)
---

**Key Features**  
1. **PostgreSQL 17 + PostGIS 3.5**  
   - All standard PostGIS features (geography types, geometry functions, raster, etc.).
2. **pgvector**  
   - Enables similarity searches on vector embeddings (e.g., for AI/ML use cases).
3. **Multi-Stage Build**  
   - Keeps build tools and libraries out of the final image, reducing bloat.
4. **Environment Variables**  
   - Configurable at runtime: `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`.
5. **Init Scripts**  
   - Any `.sql` or shell scripts placed in `docker-entrypoint-initdb.d/` will run on first launch.
6. **Health Check**  
   - A basic `pg_isready` call to ensure the container is accepting connections.

---

**Usage**  

1. **Pull and Run [isopen/pgisvector:latest](https://hub.docker.com/r/isopen/pgisvector)**  
   ```bash
   docker pull <YOUR_REPO>/pgisvector:latest
   docker run -d \
     --name my_pgvector_db \
     -e POSTGRES_PASSWORD=secret \
     -p 5432:5432 \
     <YOUR_REPO>/pgisvector:latest
   ```
   Replace `<YOUR_REPO>` and `secret` with your preferred image location and password.

2. **Create Extensions**  
   Inside the running container (or via psql from elsewhere) to ensure everything is going well:
   ```sql
   CREATE EXTENSION IF NOT EXISTS postgis;
   CREATE EXTENSION IF NOT EXISTS vector;
   ```

3. **Check Health**  
   Docker automatically runs a health check (`pg_isready`) to verify the container is ready.

---

**Example Docker Compose**  
```yaml
version: '3.8'
services:
  pgvector_db:
    image: isopen/pgisvector:latest
    container_name: my_pgvector_db
    environment:
      - POSTGRES_PASSWORD=secret
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
      interval: 30s
      timeout: 5s
      retries: 3
```

---

**When to Use**  
- **Geospatial + Embeddings**: If you need both advanced spatial queries (PostGIS) and vector similarity search (pgvector).  
- **AI/ML pipelines**: Storing embeddings directly in PostgreSQL for similarity lookups.  
- **Analytics**: Combining geospatial analytics with AI-driven queries.

---

**Notes**  
- Default credentials (`postgres`/`postgres`) are for local development/testing only. Overwrite them in production.  
- The final image is still based on `postgis/postgis:17-3.5`; a “slim” alternative may not exist at the time of writing.  
- For advanced setups, you can extend this image with additional Postgres extensions or layer your own configuration files in `/docker-entrypoint-initdb.d/`.

---

**License & Sources**  
- [PostGIS/PostgreSQL License](https://www.postgresql.org/about/licence/)  
- [pgvector License (MIT)](https://github.com/pgvector/pgvector/blob/main/LICENSE)
- [Docker Image](https://hub.docker.com/r/isopen/pgisvector)
- [Github Repos](https://github.com/isopen-io/pgisvector)
- This is open