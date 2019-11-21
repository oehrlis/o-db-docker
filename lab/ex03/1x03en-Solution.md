## Solution 3: Docker Image Size

- Dockerfile with several `RUN` commands.
- Dockerfile with a combined `RUN` command.
- Using a build stage build.
- Verify if Docker *expertimental* is enabled 
- Build an image using squash
- Analyse the different images using `docker history`

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->

<div class="no notes">

### Background Information

To simplify and speed up the build we do build a Docker image for SQL*Plus using the instant client. The same procedure could also be done for an Oracle binary installation. It just takes a bit longer. The base image is `oraclelinux:7-slim`. The exercise does use the following `Dockerfiles`:

- `ic19_separate.Dockerfile` with multiple respectively separate *RUN* statements.
- `ic19.Dockerfile` with one *RUN* statement.
- `ic19_multistage.Dockerfile` for multi stage build.

### Build Image with multiple RUN Statements

Build the Docker image for Oracle instant client with multiple *RUN* statements. Since we do not use a default `Dockerfile` we do have to provide the file name.

```bash
docker build -t oracle/sqlplus:separate -f ic19_separate.Dockerfile .
```

### Build Image with one RUN Statements

Build the Docker image for Oracle instant client with one *RUN* statements. Since we do not use a default `Dockerfile` we do have to provide the file name.

```bash
docker build -t oracle/sqlplus:one -f ic19.Dockerfile .
```

### Use Experimental Feature squash

First check if experimental feature is enabled.

```bash
docker info
docker version -f '{{.Server.Experimental}}'
```

Enable experimental features using `daemon.json`. Add `"experimental": true` but don't forget the comma.

```bash
sudo vi /etc/docker/daemon.json
```

Restart the Docker deamon.

```bash
sudo systemctl stop docker
sudo systemctl start docker
```

Check again if experimental is enabled.

```bash
docker version -f '{{.Server.Experimental}}'
```

Build again the Docker image with multiple *RUN* commands but use `--squash`.

```bash
docker build -t oracle/sqlplus:squash --squash -f ic19_separate.Dockerfile .
```

### Use Multi Stage Build

Build the Docker image for Oracle instant client with one *RUN* statements. Since we do not use a default `Dockerfile` we do have to provide the file name.

```bash
docker build -t oracle/sqlplus:multistage -f ic19_multistage.Dockerfile .
```

### Compare the different Docker images

Here we go, let's compare the different Docker images.

```bash
docker images
```

With `docker history` you can see the different layers and there size.

```bash
docker history oracle/sqlplus:separate
docker history oracle/sqlplus:one
docker history oracle/sqlplus:squash
docker history oracle/sqlplus:multistage
```

The squash images is small but does missing all layer information. This does also have impact when a container is started / loaded e.g. existing layers can not be *reused*.
</div>
