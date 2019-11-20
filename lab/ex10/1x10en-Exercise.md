## Exercise 10: Oracle Unified Audit Setup

### Exercise Goals

Use the startup / setup script folder to customize the database Docker container. In this exercise using Oracle Unified Directory as an example.

### Tasks

- Review the setup scripts
- Refine a `docker-compose.yml` file
- Create a Docker container using `docker-compose` and review the database configuration. In particular the Unified Audit configuration.
- Re-create the Docker container using `docker-compose` to see that Oracle Unified Audit gets linked again

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">

### Additions to the Solution

- The `docker-compose` file does include the services for Oracle 12.2, 18c and 19c. But the services **tua122** and **tua180** are commented out.
- The database is pre-configured in volume *db-tua190* if used a different Oracle version the DB may have to be created.

</div>
