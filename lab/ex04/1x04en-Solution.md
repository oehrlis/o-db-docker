## Solution 4: Local Software Repository

The following steps are performed in this exercise:

- login via SSH client as user *opc* to the individual OCI compute instance eg. *ol7dockerXX*. 
- Switch to user *oracle*
- Run *docker images* to see which images are available
- Check the different directories.

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">
</div>

<!-- Stuff between the <div class="no notes"> will not be rendered as pptx slide notes -->
<div class="no notes">

### Background Information

Oracle Software usually can not be downloaded during build without providing some credentials. If the binaries are downloaded using curl or wget the credentials will remain in the docker image. One solution would be to keep the binaries in the docker build context and use squash or multi stage builds. Alternatively it is also possible to use a local web server (docker container) to download the files locally.

### Start ORAREPO Container

Start a simple web server to locally share the software during docker build using simple `docker` command.

```bash
docker run -dit \
  --hostname orarepo \
  --name orarepo \
  -p 80:80 \
  -v /u00/app/oracle/software:/www \
  busybox httpd -fvvv -h /www
```

Stop and remove the container.

```bash
docker stop orarepo
docker rm orarepo
```

A little more comfortable is the use of `docker-compose`.

```bash
docker-compose up -d
```

Get the IP of the web server.

```bash
orarepo_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orarepo)
echo $orarepo_ip
```

### Build a Image using ORAREPO

Build a Docker images using the orarepo.

```bash
docker build --add-host=orarepo:${orarepo_ip} -t oracle/java:orarepo .
```

### Build a Image using local Software

Create a hardlink for the java package (you can also copy the file)

```bash
ln /u00/app/oracle/software/p29657335_170231_Linux-x86-64.zip .
```

Build a Docker images using the local software package.

```bash
docker build --add-host=orarepo:${orarepo_ip} -t oracle/java:local .
```

### Compare the Docker Images

Lets compare the Docker images using `docker images`.

```bash
docker image
```

And check what's in the images

```bash
docker history oracle/java:local
docker history oracle/java:orarepo
```
</div>
