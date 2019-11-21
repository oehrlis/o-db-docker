## Solution 1: Get known the Environment

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

### Detailed Solution

The following steps have been performed on the *ol7docker00* host. If necessary, adjust the commands, filenames or the host name according to your environment.

- Start a Putty session from command line.

```bash
putty -ssh opc@ol7docker00.trivadislabs.com -i keys/id_rsa_ol7docker00.ppk
```

- Alternatively start a SSH session from command line

```bash
ssh opc@ol7docker00.trivadislabs.com -i id_rsa_ol7docker00
```

- Switch to user *oracle*

```bash
sudo su - oracle
```

- Run *docker images* to see which images are available

```bash
docker images
```

- Run *docker volumes* to see which volumes are available

```bash
docker volumes ls
```

- Check the different directories and aliases.

```bash
cd /u01/volumes
cdl
ex01
o-db-docker
```
</div>
