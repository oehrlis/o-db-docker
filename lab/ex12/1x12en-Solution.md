## Solution 12: Oracle Enterprise User Security

The following steps are performed in this exercise:

- Review the `docker-compose.yml`
- Start the container using `docker-compose`
- Test Oracle Names Resolution within the database container.
- Test EUS Login within the database container.

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
- Run *docker images* to see which images are available
- Check the different directories.


</div>
