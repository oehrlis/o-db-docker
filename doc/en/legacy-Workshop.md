# Workshop Exercises

## Overview of Exercises

The exercises are grouped in individual directories and can generally be performed independently of each other.  Each exercise contains at least a short description of the tasks (`1x??en-Exercise.md`) as well as a solution (`1x??en-Solution.md`). In addition, scripts, docker files, etc. are part of every exercise. For exercises where software (Oracle Binaries, Patch) or code from other Git repositories is required, we refer to it accordingly.

| ID                                                     | Topic                               | Description                                                                                               | Duration |
|--------------------------------------------------------|-------------------------------------|-----------------------------------------------------------------------------------------------------------|----------|
| [01](#exercise-1-get-known-the-environment)            | Get known the Environment           | Log in and get to know the workshop environment.                                                          | 10 min   |
| [02](#exercise-2-simple-docker-image-to-get-warm)      | Simple docker image to get warm     | Build simple Docker images.                                                                               | 10 min   |
| [03](#exercise-3-docker-image-size)                    | Docker Image Size                   | Build different version of an Oracle Instant Client Docker images. Identify Docker image size challanges. | 15 min   |
| [04](#exercise-4-local-software-repository)            | Local Software Repository           | Setup a local Software Repository                                                                         | 15 min   |
| [05](#exercise-5-simples-db-docker-image)              | Simples DB Docker Image             | Build simple DB images. Identify challenges                                                               | 20 min   |
| [06](#exercise-6-oracle-docker-image)                  | Oracle Docker Image                 | Build a Docker DB images using the Oracle build scripts.                                                  | 20 min   |
| [07](#exercise-7-oradba-docker-image)                  | OraDBA Docker Image                 | Build a Docker DB images using the OraDBA build scripts.                                                  | 20 min   |
| [08](#exercise-8-simple-db-docker-container)           | Simple DB Docker Container          | Run a simple DB container.                                                                                | 30 min   |
| [09](#exercise-9-accessing-database-docker-container)  | accessing database docker container | access and work with the db container.                                                                    | 10 min   |
| [10](#exercise-10-oracle-unified-audit-setup-and-test) | Oracle Unified Audit Setup and Test | Setup a DB Container with Unified Audit and do some tests.                                                | 15 min   |
| [11](#exercise-11-oracle-ru-with-datapatch)            | Oracle RU with datapatch            | Patch a Docker DB Container using datapatch.                                                              | 30 min   |
| [12](#exercise-12-oracle-enterprise-user-security)     | oracle enterprise user security     | setup oracle enterprise user security with oracle unified directory.                                      | 30 min   |
| [13](#exercise-13-oracle-pdb)                          | Oracle PDB                          | Plugin an Oracle PDB.                                                                                     | 20 min   |
| [14](#exercise-14-oracle-rac-with-docker)              | Oracle RAC with Docker              | Setup and Build a RAC Docker environment.                                                                 | 30 min   |
| [15](#additional-exercises)                            | Additional Exercises                | Ideas for additional exercises.                                                                           | n/a      |

## Access Workshop Hosts

The workshop hosts are running as a compute instance in the Oracle Cloud. Each system is accessible via public IP address or its hostname. you have to use a SSH client of your choice for access (e.g. Putty, MochaXterm, SSH etc.)

- Start a *Putty* session from command line. Replace **NN** with the number of you host.

```cmd
putty -ssh opc@ol7dockerNN.trivadislabs.com -i keys/id_rsa_ol7dockerNN.ppk
```

- Start a *SSH* session from command line

```bash
ssh opc@ol7dockerNN.trivadislabs.com -i keys/id_rsa_ol7dockerNN
```

The instructor supplements the following table with the relevant information for the O-DB-DOCKER course. A compute instance will be assigned to each participant.

| ID | Hostname                     | IP Address     | User | Key's                                                                                            | Comment |
|----|------------------------------|----------------|------|--------------------------------------------------------------------------------------------------|---------|
| 00 | ol7docker00.trivadislabs.com | n/a | opc  | [public](keys/id_rsa_ol7docker00.pub), [OpenSSH](keys/id_rsa_ol7docker00), [Putty](keys/id_rsa_ol7docker00.ppk) | Trainer |
| 01 | ol7docker01.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker01.pub), [OpenSSH](keys/id_rsa_ol7docker01), [Putty](keys/id_rsa_ol7docker01.ppk) |         |
| 02 | ol7docker02.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker02.pub), [OpenSSH](keys/id_rsa_ol7docker02), [Putty](keys/id_rsa_ol7docker02.ppk) |         |
| 03 | ol7docker03.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker03.pub), [OpenSSH](keys/id_rsa_ol7docker03), [Putty](keys/id_rsa_ol7docker03.ppk) |         |
| 04 | ol7docker04.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker04.pub), [OpenSSH](keys/id_rsa_ol7docker04), [Putty](keys/id_rsa_ol7docker04.ppk) |         |
| 05 | ol7docker05.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker05.pub), [OpenSSH](keys/id_rsa_ol7docker05), [Putty](keys/id_rsa_ol7docker05.ppk) |         |
| 06 | ol7docker06.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker06.pub), [OpenSSH](keys/id_rsa_ol7docker06), [Putty](keys/id_rsa_ol7docker06.ppk) |         |
| 07 | ol7docker07.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker07.pub), [OpenSSH](keys/id_rsa_ol7docker07), [Putty](keys/id_rsa_ol7docker07.ppk) |         |
| 08 | ol7docker08.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker08.pub), [OpenSSH](keys/id_rsa_ol7docker08), [Putty](keys/id_rsa_ol7docker08.ppk) |         |
| 09 | ol7docker09.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker09.pub), [OpenSSH](keys/id_rsa_ol7docker09), [Putty](keys/id_rsa_ol7docker09.ppk) |         |
| 10 | ol7docker10.trivadislabs.com | n/a            | opc  | [public](keys/id_rsa_ol7docker10.pub), [OpenSSH](keys/id_rsa_ol7docker10), [Putty](keys/id_rsa_ol7docker10.ppk) |         |



| 06 | Oracle Docker Image                 | Build a Docker DB images using the Oracle build scripts.                                                  | 20 min   |
| 07 | OraDBA Docker Image                 | Build a Docker DB images using the OraDBA build scripts.                                                  | 20 min   |
| 08 | Simple DB Docker Container          | Run a simple DB container.                                                                                | 30 min   |
| 09 | Accessing database Docker container | Access and work with the DB container.                                                                    | 10 min   |
| 10 | Oracle Unified Audit Setup and Test | Setup a DB Container with Unified Audit and do some tests.                                                | 15 min   |
| 11 | Oracle RU with datapatch            | Patch a Docker DB Container using datapatch.                                                              | 30 min   |
| 12 | Oracle Enterprise User Security     | Setup Oracle Enterprise User Security with Oracle Unified Directory.                                      | 30 min   |
| 13 | Oracle PDB                          | Plugin an Oracle PDB.                                                                                     | 20 min   |
| 14 | Oracle RAC with Docker              | Setup and Build a RAC Docker environment.                                                                 | 30 min   |
| 15 | Additional Exercises                | Ideas for additional exercises.                                                                           | n/a      |
