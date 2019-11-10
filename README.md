# Introduction 




Create PDF

```bash
docker run --rm -v "$PWD":/workdir:z trivadis/pandoc \
--template trivadis --listings --pdf-engine=xelatex \
--metadata-file=doc/metadata.yml \
-o doc/Administrationshandbuch_OUD.pdf doc/0x*.md
```

Create DOCX

```bash
docker run --rm -v "$PWD":/workdir:z trivadis/pandoc \
--reference-doc doc/templates/trivadis.docx --listings \
--metadata-file=doc/metadata.yml \
-o doc/Administrationshandbuch_OUD.docx doc/0x*.md
```


Create md

```bash
docker run --rm -v "$PWD":/workdir:z trivadis/pandoc --listings \
--metadata-file=doc/metadata.yml \
-o doc/Administrationshandbuch_OUD.md doc/0x*.md
```

Create O-DB-DOCKER_Anforderungen.pdf

```bash
pandoc \
--template trivadis --listings --pdf-engine=xelatex \
-o doc/O-DB-DOCKER_Anforderungen.pdf doc/de/0x05-lab_requirements.md
```

Create O-DB-DOCKER_Requirements.pdf

```bash
pandoc \
--template trivadis --listings --pdf-engine=xelatex \
-o doc/O-DB-DOCKER_Requirements.pdf doc/en/0x05-lab_requirements.md
```

Create PDF

```bash
pandoc --template trivadis --listings --pdf-engine=xelatex \
--metadata-file=doc/metadata.yml \
-o doc/O-DB-DOCKER_Workshop.pdf doc/en/0x??-* lab/ex??/1x??en-* doc/en/9x??-*
```