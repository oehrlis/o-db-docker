# Workshop Exercises

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
