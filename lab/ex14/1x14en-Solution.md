## Solution 14: Oracle RAC with Docker

The following steps are performed in this exercise:

- Create the Docker network.
- Create a RAC storage server Docker container.
- Create a NFS volume
- Creating the Docker GI and RAC Container
- Assign networks to RAC containers
- Adding a RAC Node using a Docker container
- Connecting to RAC Database

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">
</div>

<!-- Stuff between the <div class="no notes"> will not be rendered as pptx slide notes -->
<div class="no notes">

### Detailed Solution

Setup Oracle RAC on docker is well documented in the Oracle Git repository [oracle/docker-images](https://github.com/oracle/docker-images) respectively in [README.md](https://github.com/oracle/docker-images/blob/master/OracleDatabase/RAC/README.md).

-[OracleConnectionManager/README.md]([OracleConnectionManager/README.md](https://github.com/oracle/docker-images/blob/master/OracleDatabase/RAC/OracleConnectionManager/README.md)) 
-[OracleRACStorageServer/README.md]([OracleConnectionManager/README.md](https://github.com/oracle/docker-images/blob/master/OracleDatabase/RAC/OracleRACStorageServer/README.md)) 
-[OracleRealApplicationClusters/README.md]([OracleConnectionManager/README.md](https://github.com/oracle/docker-images/blob/master/OracleDatabase/RAC/OracleRealApplicationClusters/README.md)) 

</div>
