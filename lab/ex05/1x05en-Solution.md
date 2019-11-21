## Solution 5: Simples DB Docker Image

The following steps are performed in this exercise:

- Customize the Dockerfile for build a simple database image using Oracle RPM package.
- Build the database Docker image. Either by using orarepo or the local software.
- Think about what this image lacks.
- Optional: Create a simple database image using regular Oracle packages.

Each build takes about 10-15minutes. It does not make sense to build all of them.

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">
</div>

<!-- Stuff between the <div class="no notes"> will not be rendered as pptx slide notes -->
<div class="no notes">

### Background Information

In this exercise you can either use the local software from the Docker build context or download the packages during build from the OraREPO. Beside this the build can be done by using the regular Oracle software packages or the new RPM packages.

### Build Image using local RPM

Create a hard link for the java package (you can also copy the file)

```bash
ln /u00/app/oracle/software/oracle-database-ee-19c-1.0-1.x86_64.rpm .
```

Build the Docker images using the local software package.

```bash
docker build -f rpm.Dockerfile -t oracle/database:19.3_local_rpm .
```

### Build Image using OraREPO RPM

Get the IP of the web server.

```bash
orarepo_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orarepo)
echo $orarepo_ip
```

Build the Docker images using the software package from orarepo.

```bash
docker build --add-host=orarepo:${orarepo_ip} -f rpm.Dockerfile -t oracle/database:19.3_orarepo_rpm .
```

### Optional: Build Image using local Software Package

Create a hard link for the java package (you can also copy the file)

```bash
ln /u00/app/oracle/software/LINUX.X64_193000_db_home.zip .
```

Build the Docker images using the local software package.

```bash
docker build -f regular.Dockerfile -t oracle/database:19.3_local_reg .
```

### Optional: Build Image using OraREPO Software Package

Get the IP of the web server.

```bash
orarepo_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orarepo)
echo $orarepo_ip
```

Build the Docker images using the software package from orarepo.

```bash
docker build --add-host=orarepo:${orarepo_ip} -f regular.Dockerfile -t oracle/database:19.3_orarepo_reg .
```

### Compare the Docker Images

Lets compare the Docker images using `docker images`.

```bash
docker images
```

And check what's in the images

```bash
docker history oracle/database:19.3_local_rpm
docker history oracle/database:19.3_orarepo_rpm
docker history oracle/database:19.3_local_reg
docker history oracle/database:19.3_orarepo_reg
```

What else is missing?

- No Oracle environment variables defined.
- All configuration files are still in the container. e.g. no script to move TNS_ADMIN etc to a volume
- Database would be created within the container. No volume defined.
- Overall size is rather large.
- Database can not be accessed from outside the container since the Oracle ports are not exported.
- No *entrypoint* nor *command* defined. There will be no database created / started when the container is created
- When using the Oracle RPM in Docker it is mandatory to set the environment variable *ORACLE_DOCKER_INSTALL*. Otherwise Oracle will look for sudo.
- What about release updates (RU) patches etc?
- Oracle 18c/19c installation is rather simple, but what about other releases?
- Quite a lot is hardcoded and not easy to maintain.
- And a couple of other stuff...

</div>
