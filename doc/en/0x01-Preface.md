# Preface

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

## Disclaimer

This guide has been created with utmost care, but does not claim to be complete. It was compiled as part of the preparation for the *O-DB-DOCKER* workshop. The author assumes no responsibility for the accuracy, completeness and timeliness of the content. The use of the available content is at your own risk.

## Document information

* **Document:**          O-DB-DOCKER Workshop
* **Classification:**    Restricted / Trivadis customer
* **Status:**            Published
* **Last changes:**      2019.11.21
* **Document name:**     O-DB-DOCKER_Workshop.pdf

| Lead Authors  | Contributors & Reviewers                                       |
|---------------|----------------------------------------------------------------|
| Stefan Oehrli | Martin Berger                                                  |

## Revision History

| Version   | Date       | Visa | Comment                                        |
|-----------|------------|------|------------------------------------------------|
| 0.1       | 2019.10.12 | soe  | Initial release O-DB-DOCKER workshop           |
| 0.2       | 2019.10.17 |      | Add Lab requirements                           |
| 0.3 - 0.8 | 2019.11.19 |      | Add initial version of Lab exercises           |
| 1.0       | 2019.11.20 | soe  | First official release of O-DB-DOCKER workshop |

If you have any questions, please do not hesitate to contact us via [stefan.oehrli@trivadis.com](stefan.oehrli@trivadis.com).
