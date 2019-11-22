# Introduction

## About O-DB-DOCKER

Oracle has long supported the use of Docker to install its products, including the latest versions of the Oracle database.

In theory, a simple "docker run" instantiates a corresponding container from a docker image. But why isn't the database container ready in a few seconds?? Where does Oracle Database Image come from and what happens if the container is stopped again? The functional scope as well as the size of the Oracle database container presuppose that one or the other thoughts about the use and operation are made in advance. This includes topics such as data persistence, licensing and other operational aspects.

With a focus on the current versions of Oracle Database and Oracle Unified Directory the following topics will be discussed:

- Docker overview with focus on images, containers and volumes.
- Structure of Oracle Docker Images
- Operating an Oracle Docker Database Container
- Various use cases for Oracle database docker containers such as Oracle Enterprise, User Security, Test and Engineering databases, Migration and more.
- Other topics such as high availability, backup & recovery and licensing.

Within the scope of this training, basics and extended know-how in the area of Oracle database and Docker will be elaborated. The theory will be accompanied by demos and practical exercises.

## Build Documentation

The workshop documentation is based on markdown. This allows to convert it to different formats e.g. PDF, DOCX and PPTX

- Create PDF using a local pandoc installation. This requires also latex.

```bash
pandoc --template trivadis --listings --pdf-engine=xelatex \
    --metadata-file=doc/metadata.yml \
    --resource-path ./doc/images \
    -o doc/O-DB-DOCKER_Workshop.pdf \
    doc/en/0x??-* lab/ex??/1x??en-* doc/en/9x??-*
```

- Create DOCX using a local pandoc installation.

```bash
pandoc --reference-doc doc/templates/trivadis.docx --listings \
    --metadata-file=doc/metadata.yml \
    --resource-path ./doc/images \
    -o doc/O-DB-DOCKER_Workshop.docx \
    doc/en/0x??-* lab/ex??/1x??en-* doc/en/9x??-*
```

- Create Markdown file using a local pandoc installation. 

```bash
pandoc --listings  \
    --metadata-file=doc/metadata.yml \
    --resource-path ./doc/images \
    -o doc/O-DB-DOCKER_Workshop.md \
    doc/en/0x??-* lab/ex??/1x??en-* doc/en/9x??-*
```

- Create PPTX for the workshop presentation using a local pandoc installation.

```bash
pandoc --reference-doc doc/templates/trivadis.pptx --listings \
    --metadata-file=doc/metadata.yml \
    --resource-path ./doc/images \
    -o doc/O-DB-DOCKER_Workshop_Exercise.pptx \
    lab/ex??/1x??en-E*.md
```
