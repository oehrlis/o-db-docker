## Solution 6: Oracle Docker Image

The following steps are performed in this exercise:

- Create database Docker image using the Oracle build scripts.
- Update local git working copy of *oracle/docker-images*
- Check whether all the prerequisites have been fulfilled.
- Build Docker image using `buildDockerImage.sh` or manually using `docker build`

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">
</div>

<!-- Stuff between the <div class="no notes"> will not be rendered as pptx slide notes -->
<div class="no notes">

### Preparations

Change to the Oracle Docker image folder `/u00/app/oracle/local/docker-images` and pull the latest updates.

```bash
cd /u00/app/oracle/local/docker-images
git pull
```

Change to the `OracleDatabase` folder. In this example we do use 19.3.0 but you can take as well an other release.

```bash
cd OracleDatabase/SingleInstance/dockerfiles/19.3.0
```

Check the Software requirements

```bash
cat Checksum.ee
```

Create a hard link for the software

```bash
ln /u00/app/oracle/software/LINUX.X64_193000_db_home.zip .
```

For more information regarding Oracle Docker images see [README.md](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance) of *oracle/docker-images*.

### Build the Image using buildDockerImage.sh

Oracle does provide a shell wrapper script to build the Oracle Docker images `buildDockerImage.sh`. The script does have a couple of parameter.

```bash
buildDockerImage.sh -h

Usage: buildDockerImage.sh -v [version] [-e | -s | -x] [-i] [-o] [Docker build option]
Builds a Docker Image for Oracle Database.
  
Parameters:
   -v: version to build
       Choose one of: 11.2.0.2  12.1.0.2  12.2.0.1  18.3.0  18.4.0  19.3.0  
   -e: creates image based on 'Enterprise Edition'
   -s: creates image based on 'Standard Edition 2'
   -x: creates image based on 'Express Edition'
   -i: ignores the MD5 checksums
   -o: passes on Docker build option

* select one edition only: -e, -s, or -x
```

Build an Oracle Docker image for Enterprise Edition and 19.3.0

```bash
buildDockerImage.sh -v 19.3.0 -e 
```

### Build the Image using Docker

Alternatively you can build the Docker images regularly using `docker build`.

```bash
cd 19.3.0
time docker build -t oracle/database:19.3.0-ee .
```

</div>
