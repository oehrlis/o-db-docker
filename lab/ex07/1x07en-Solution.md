## Solution 7: OraDBA Docker Image

The following steps are performed in this exercise:

- Update local git working copy of *oehrlis/docker*
- Review the Dockerfile and define Oracle version to build
- Check whether all the prerequisites have been fulfilled.
- Build Docker image using `docker build`

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">
</div>

<!-- Stuff between the <div class="no notes"> will not be rendered as pptx slide notes -->
<div class="no notes">

### Preparations

Change to the OraDBA Docker image folder `/u00/app/oracle/local/docker` and pull the latest updates.

```bash
cd /u00/app/oracle/local/docker
git pull
```

Change to the `OracleDatabase` folder. In this example we do use 19.3.0 but you can take as well an other release.

```bash
cd OracleDatabase/19.0.0.0
```

Check the Software requirements

```bash
cd software
cat LINUX.X64_193000_db_home.zip.download
```

Create a hard link for the software. This is only required if you want to not use OraREPO.

```bash
cd software
ln /u00/app/oracle/software/LINUX.X64_193000_db_home.zip .
```

Optional you can also add the hard links for release updates.

For more information regarding Oracle Docker images see [README.md](https://github.com/oehrlis/docker/tree/master/OracleDatabase/19.0.0.0) of *oehrlis/docker*.

### Build the Image using OraREPO

Get the IP of the OraREPO web server.

```bash
orarepo_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orarepo)
echo $orarepo_ip
```

Build the Docker image for Oracle 19c (19.3.0)

```bash
docker build --add-host=orarepo:${orarepo_ip} -f 19.3.0.0.Dockerfile -t oracle/database:19.3.0.0 .
```

Build the Docker image for Oracle 19c (19.3.0) with RU July 2019

```bash
docker build --add-host=orarepo:${orarepo_ip} -f 19.4.0.0.Dockerfile -t oracle/database:19.4.0.0 .
```

Build the Docker image for Oracle 19c (19.3.0) with RU October 2019

```bash
docker build --add-host=orarepo:${orarepo_ip} -f 19.5.0.0.Dockerfile -t oracle/database:19.5.0.0 .
```

### Build the Image using local Software

Create a hard link for the software. This is only required if you want to not use OraREPO.

```bash
cd software
ln /u00/app/oracle/software/LINUX.X64_193000_db_home.zip .
ln /u00/app/oracle/software/basenv-18.11.final.a.zip .
ln /u00/app/oracle/software/p6880880_190000_Linux-x86-64.zip .
```

Optional you can also add the hard links for release updates.

```bash
ln /u00/app/oracle/software/p30125133_190000_Linux-x86-64.zip .
ln /u00/app/oracle/software/p30128191_190000_Linux-x86-64.zip .
ln /u00/app/oracle/software/p6880880_190000_Linux-x86-64.zip .
```

Build the Docker image for Oracle 19c (19.3.0)

```bash
docker build -f 19.3.0.0.Dockerfile -t oracle/database:19.3.0.0 .
```

Build the Docker image for Oracle 19c (19.3.0) with RU October 2019

```bash
docker build -f 19.5.0.0.Dockerfile -t oracle/database:19.5.0.0 .
```

</div>
