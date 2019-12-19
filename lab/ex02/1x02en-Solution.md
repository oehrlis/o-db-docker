## Solution 2: Simple docker image

The following steps are performed in this exercise:

- Create an Dockerfile with a simple *hello world*
- Build Docker image
- Run the Docker *hello world* example.
- Run a few basic docker commands.

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">
</div>

<!-- Stuff between the <div class="no notes"> will not be rendered as pptx slide notes -->
<div class="no notes">

Create / review the `Dockerfile`.

```bash
vi Dockerfile
```

Build a image **doag** using `docker`. This way the image will automatially be tagged as *doag:latest*.

```bash
docker build -t doag .
```

Build a image **doag** using `docker`. 

```bash
docker build -t doag:2019 .
```

Run the docker image as container.

```bash
docker run doag2020
```

Check the containers using `docker ps -a`. You will see that the container still exists

```bash
docker ps -a
```

Remove the container. Copy the container ID from above.

```bash
docker rm <CONTAINER ID>
```

Build the Docker image using a build argument.

```bash
docker build -t doag --build-arg DOAG_USER="Mr. Docker" .
```

Run the docker image as container but use `--rm` to remove the container when it is stopped.

```bash
docker run --rm doag
```

Run the docker image as container interactive (`-i`) with a pseudo-TTY (`-t`) and overwrite the default command with `sh`. Within the container you can check the environment variables using `env` and the text file copied to the root folder `cat /beispiel.txt`

```bash
docker run --rm -it doag sh
env
cat /beispiel.txt
```

Cleanup old *doag* images either using `docker system prune`, `docker image prune` or `docker rmi <IMAGE ID>`.

```bash
docker images
docker image prune
docker system prune
docker rmi doag
docker rmi doag:2019
docker images
```

Your dangeling images should be gone as well as the *doag* image.
</div>
