## Solution 5: Simples DB Docker Image

The following steps are performed in this exercise:

- Customize the Dockerfile for build a simple database image using Oracle RPM package.
- Build the database Docker image. Either by using orarepo or the local software.
- Think about what this image lacks.
- Optional: Create a simple database image using regular Oracle packages.

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

Build a Docker images using the local software package.

```bash
docker build --add-host=orarepo:${orarepo_ip} -t oracle/java:local .
```

- Alternatively start a SSH session from command line

```bash
ssh opc@ol7docker00.trivadislabs.com -i id_rsa_ol7docker00
```


- Switch to user *oracle*
- Run *docker images* to see which images are available
- Check the different directories.


</div>
