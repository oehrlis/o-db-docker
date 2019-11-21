## Solution 8: Simple DB Docker Container

The following steps are performed in this exercise:

- Create a Docker container by using `docker run` without a volume.
- Create a Docker container by using `docker run` with a volume.
- Create a Docker container using `docker-compose` with a predefined volume.

Task where a Docker container does create a new database do take a while (15-20min). Due to this it does not make sense to create all tasks. 

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">
</div>

<!-- Stuff between the <div class="no notes"> will not be rendered as pptx slide notes -->
<div class="no notes">

### Database Container without a volume

This container will be build based on an [oracle/docker-images](https://github.com/oracle/docker-images). See the [README.md](https://github.com/oracle/docker-images/blob/master/OracleDatabase/SingleInstance/README.md) for more run options.

```bash
docker run --name doag193 \
-p 1521:1521 -p 5500:5500 \
-e ORACLE_SID=TDOAG \
-e ORACLE_PDB=PDB1 \
oracle/database:19.3.0-ee
```

The problem with this container is, that the DB is now create in the read/write layer of the container. Beside this `docker run` has been executed without detach. If you cancel the command, the container will be stopped.

To create a container and run it in deamon mode use the `-d` option.

```bash
docker run --name doag193 \
-p 1521:1521 -p 5500:5500 \
-e ORACLE_SID=TDOAG \
-e ORACLE_PDB=PDB1 \
oracle/database:19.3.0-ee
```

Check the logs

```bash
docker logs -f doag193
```

The database is ready to use when you see the following strings in the log files.

```
#########################
DATABASE IS READY TO USE!
#########################
```

If not specified by *ORACLE_PWD* the password for SYS, SYSTEM and PDBADMIN will be generated. It can be reset by the following command.

```bash
docker exec <container name> ./setPassword.sh <your password>
```

### Database Container with a volume

This container will be build based on an [oehrlis/docker](https://github.com/oehrlis/docker). See the [README.md](https://github.com/oehrlis/docker/blob/master/OracleDatabase/19.0.0.0/README.md) for more run options.

```bash
docker volume create ex08_db_doag194
```

Create the Docker container for 19.4.0.0. We just use a default values and do not configure additional stuff like PDB, custom template etc.

```bash
docker run --name doag194 \
--hostname doag194 -p 2521:1521 \
-e ORACLE_SID=TDB194S \
--volume vol_doag194:/u01 \
--detach \
oracle/database:19.4.0.0
```

Check the logs

```bash
docker logs -f doag194
```

The database is ready to use when you see the following strings in the log files.

```
---------------------------------------------------------------
 - DATABASE TDB194S IS READY TO USE!
---------------------------------------------------------------
```

Password for the Oracle users e.g. SYS and SYSTEM is create when not specified via *ORACLE_PWD*. It is visible in the Docker log as well in the DB admin directory

```bash
docker logs doag194|grep -i password

    Oracle Database Server auto generated password:
    ----> Password    : U3SQ8XFwIl
ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: U3SQ8XFwIl
```

### Database Container with a bind mount

This container will be build based on an [oehrlis/docker](https://github.com/oehrlis/docker). See the [README.md](https://github.com/oehrlis/docker/blob/master/OracleDatabase/19.0.0.0/README.md) for more run options.

```bash
mkdir /u01/volumes/doag195
```

Create the Docker container for 19.5.0.0. We just use a default values and do not configure additional stuff like PDB, custom template etc.

```bash
docker run --name doag195 \
--hostname doag195 -p 3521:1521 \
-e ORACLE_SID=TDB195S \
--volume /u01/volumes/doag195:/u01 \
--detach \
oracle/database:19.5.0.0
```

Check the logs

```bash
docker logs -f doag195
```

The database is ready to use when you see the following strings in the log files.

```
---------------------------------------------------------------
 - DATABASE TDB195S IS READY TO USE!
---------------------------------------------------------------
```

Password for the Oracle users e.g. SYS and SYSTEM is create when not specified via *ORACLE_PWD*. It is visible in the Docker log as well in the DB admin directory

```bash
docker logs doag195|grep -i password

    Oracle Database Server auto generated password:
    ----> Password    : U3SQ8XFwIl
ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: U3SQ8XFwIl
```

### Database Container with predefined volume

This container will be build based on an [oehrlis/docker](https://github.com/oehrlis/docker). See the [README.md](https://github.com/oehrlis/docker/blob/master/OracleDatabase/19.0.0.0/README.md) for more run options.

Create the Docker container for 19.4.0.0. The `docker-compose.yml` file does include the parameters to configure a CONTAINER DB as well other stuff.

```bash
docker-compose up -d
```

Check the logs

```bash
docker-compose logs -f 
```

The database is ready to use when you see the following strings in the log files.

```
---------------------------------------------------------------
 - DATABASE TDB190C IS READY TO USE!
---------------------------------------------------------------
```

Password for the Oracle users e.g. SYS and SYSTEM is create when not specified via *ORACLE_PWD*. It is visible in the Docker log as well in the DB admin directory

```bash
docker logs tdb190c|grep -i password
```

</div>