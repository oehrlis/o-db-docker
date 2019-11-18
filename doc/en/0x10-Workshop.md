# Workshop Exercises

## Overview of Exercises

The exercises are grouped in individual directories and can generally be performed independently of each other.  Each exercise contains at least a short description of the tasks (`1x??en-Exercise.md`) as well as a solution (`1x??en-Solution.md`). In addition, scripts, docker files, etc. are part of every exercise. For exercises where software (Oracle Binaries, Patch) or code from other Git repositories is required, we refer to it accordingly.

| ID | Topic                               | Description                                                        | Duration |
|----|-------------------------------------|--------------------------------------------------------------------|----------|
| 01 | Get known the Environment           | Log in and get to know the workshop environment.                   | 10       |
| 02 | Simple docker image                 | Build simple Docker images.                                        | 10       |
| 03 | Docker Image Size                   | Build different version of an Oracle Instant Client Docker images. | 15       |
| 04 | Local Software Repository           | Setup a local Software Repository                                  | 15       |
| 05 | Simples DB Docker Image             | Build simple DB images. Identify challenges.                       | 20       |
| 06 | Oracle Docker Image                 | Build a Docker DB images using the Oracle build scripts.           | 20       |
| 07 | OraDBA Docker Image                 | Build a Docker DB images using the OraDBA build scripts.           | 20       |
| 08 | Simple DB Docker Container          | Run a simple DB container.                                         | 30       |
| 09 | Accessing database container        | Access and work with the DB container.                             | 10       |
| 10 | Oracle Unified Audit Setup          | Setup a DB Container with Unified Audit and do some tests.         | 15       |
| 11 | Oracle RU with datapatch            | Patch a Docker DB Container using datapatch.                       | 30       |
| 12 | Oracle Enterprise User Security     | Setup Oracle Enterprise User Security with OUD.                    | 30       |
| 13 | Oracle PDB                          | Plugin an Oracle PDB.                                              | 20       |
| 14 | Oracle RAC with Docker              | Setup and Build a RAC Docker environment.                          | 30       |
| 15 | Container Monitoring                | Setup and Configure container monitoring.                          | 30       |
| 16 | Additional Exercises                | Ideas for additional exercises.                                    | n/a      |

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
