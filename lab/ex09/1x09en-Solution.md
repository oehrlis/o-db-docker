## Solution 9: Accessing database container

The following steps are performed in this exercise:

- Access Docker container via shell
- Access Docker container via SQLPlus / SQL Developer

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">
</div>

<!-- Stuff between the <div class="no notes"> will not be rendered as pptx slide notes -->
<div class="no notes">

### Detailed Solution

Access the container via Shell (user oracle is default)

```bash
docker exec -it -u oracle tdb190c bash --login
```

Sometimes there could be issues with the terminal columns

```bash
docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -it -u oracle tdb190c bash --login
```

You can also access the container as root

```bash
docker exec -it -u root tdb190c bash --login
```

Or start SQL*Plus instead

```bash
docker exec -it tdb190c sqlplus "/ as sysdba"
```

You can also access the container from outside via port forwarding.

```bash
docker logs tdb190c|grep -i password
sqlplus sys/BoWfrrxGO7@localhost:9000/TDB190C
```

You can also access the container from outside via port forwarding.

```bash
docker inspect tdb190c
sqlplus sys/BoWfrrxGO7@172.17.0.4:1521/TDB190C
```

If you prepared port forwarding in ssh you can also access from the local PC.

</div>
