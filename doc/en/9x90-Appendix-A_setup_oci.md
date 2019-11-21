# Appendix A Setup OCI Environment

## Requirements and Preparations

The following appendix contains a step-by-step guide on how to set up the Workshop VM in the Oracle Cloud. The different steps are performed via command line and scripts. Alternatively the OCI configurations can be done via OCI Web Console. For the sake of simplicity, we will limit this guide to the OCI command line utility. 

The following prerequisites must be fulfilled:

- Oracle Cloud Infrastructure subscription and access to the OCI console see [Oracle Cloud Infrastructure Documentation](https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/signingin.htm) 
- Corresponding subscription level to create different resources in OCI (Cloud Credits, up todate billing, etc.) The [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/) does work for basic configuration. But the free OCI compute does not have enough resources to run Oracle Database Docker containers.
- Appropriate Compartment to create the different OCI resources.
- Local installation of the OCI command line tool see [OCI Command Line Interface (CLI)](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm)

For the workshop *O-DB-DOCKER* we use a separate compartment, which is also named *O-DB-DOCKER*. If you follow this guide, you either have to create a compartment with an identical name or adapt the commands accordingly. The creation of a compartment is not discussed here in detail. The workshop itself is setup in Oracle Cloud region *Germany Central (Frankfurt)* identified as *eu-frankfurt-1*. 

**Disclaim**: This guide has been created with utmost care, but does not claim to be complete. It was compiled as part of the preparation for the *O-DB-DOCKER* workshop. The author assumes no responsibility for the accuracy, completeness and timeliness of the content. The use of the available content is at your own risk.

### Install OCI CLI

The installation of the OCI CLI has to be done according to the [OCI documentation](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm). Under MacOS and Linux this is fairly straightforward.

- Download and install OCI. You will have to specify an installation location, update *PATH* etc.

```bash
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
```

- Configure oci using the following command. You will be asked for your tenancy OCID, user OCID as well region and configure a SSH key.

```bash
oci setup config
```

## Create a Compartment

Create a compartment for *O-DB-DOCKER* withing the compartment *Compartment_trivadislabs*.

- Get the parent compartment id. For O-DB-DOCKER we search for a parent compartment containing *trivadislabs*.

```bash
PARENT_COMP_ID=$(oci search resource free-text-search \
--text "trivadislabs" \
--raw-output \
--query "data.items[*].identifier|[0]")
```

- Create the new compartment for *O-DB-DOCKER*.

```bash
oci iam compartment create \
--compartment-id $PARENT_COMP_ID \
--description "DOAG 2019 Training Day Oracle DB in Docker containers" \
--name "O-DB-DOCKER"
```

Create a Virtual Cloud Network (VCN) within the new compartment *O-DB-DOCKER*.

- Get the compartment id as variable *COMPARTMENT_OCID*.

```bash
COMPARTMENT_OCID=$(oci iam compartment list \
--compartment-id-in-subtree true --all \
--raw-output --query "data [?name == 'O-DB-DOCKER'].id|[0]")
```

- create a VCN *vcn-o-db-docker*

```bash
oci network vcn create \
--compartment-id $COMPARTMENT_OCID \
--cidr-block "10.0.0.0/16" \
--display-name "vcn-o-db-docker" \
--dns-label "vcnodbdocker"
```

## Compute Instance

In the following section we will reference to some names eg. host name, compartment name etc. To simplify the upcoming commands we define a couple of environment variables.

```bash
export HOST_NAME="ol7docker00"
export COMPARTMENT_NAME="O-DB-DOCKER"
```

### Create Compute Instance

To create a compute instance we first have to get a few OCID's for different components.

- Get the compartment id as variable *COMPARTMENT_OCID*.

```bash
COMPARTMENT_OCID=$(oci iam compartment list \
--compartment-id-in-subtree true --all \
--raw-output --query "data [?name == '${COMPARTMENT_NAME}'].id|[0]")
```

- Get the *ocid* of the Oracle Linux image as variable *IMAGE_OCID*.

```bash
IMAGE_OCID=$(oci compute image list --compartment-id $COMPARTMENT_OCID \
--operating-system-version "7.7" \
--operating-system "Oracle Linux" \
--sort-by TIMECREATED \
--raw-output --query "data [*].id|[0]")
```

- Get the *ocid* of the virtual cloud network (VCN) *vcn-o-db-docker* as variable *VCN_OCID*.

```bash
VCN_OCID=$(oci network vcn list --compartment-id $COMPARTMENT_OCID \
--raw-output \
--query "data [?contains(\"display-name\",'o-db-docker')].id|[0]")
```

- Get the *ocid* of the subnet as variable *SUBNET_OCID*.

```bash
SUBNET_OCID=$(oci network subnet list \
--compartment-id $COMPARTMENT_OCID \
--vcn-id $VCN_OCID \
--sort-by DISPLAYNAME --raw-output \
--query "data [*].id|[0]")
```

- Get the *availability domain* of the subnet as variable *AV_DOAMIN*.

```bash
AV_DOAMIN=$(oci network subnet list \
--compartment-id $COMPARTMENT_OCID \
--vcn-id $VCN_OCID \
--sort-by DISPLAYNAME --raw-output \
--query "data [*].\"availability-domain\"|[0]")
```

- Create a SSH key pair for the compute instance

```bash
cd o-db-docker/lab/oci/
ssh-keygen -b 4096 -C "DOAG 2019 Training" -f id_rsa_doag2019
```

Finally lets create the OCI compute instance using the following specification:

- ol7docker01
- VM.Standard2.2
- *COMPARTMENT_OCID* 
- *AV_DOAMIN*
- *IMAGE_OCID*
- *SUBNET_OCID*
- SSH public key from file 

- check the variables

```bash
echo "COMPARTMENT_OCID  = $COMPARTMENT_OCID" && \
echo "HOST_NAME         = $HOST_NAME" && \
echo "AV_DOAMIN         = $AV_DOAMIN" && \
echo "IMAGE_OCID        = $IMAGE_OCID" && \
echo "SUBNET_OCID       = $SUBNET_OCID" && \
echo "SSH Key           = $(cat id_rsa_doag2019.pub)"
```

- create the compute instance

```bash
oci compute instance launch --compartment-id $COMPARTMENT_OCID \
--availability-domain $AV_DOAMIN \
--display-name $HOST_NAME \
--image-id $IMAGE_OCID \
--subnet-id $SUBNET_OCID \
--shape VM.Standard2.2 \
--assign-public-ip true \
--metadata "{\"ssh_authorized_keys\": \"$(cat id_rsa_doag2019.pub)\"}"
```

- check the provisioning status

```bash
oci compute instance list --compartment-id $COMPARTMENT_OCID \
--output table \
--query "data [?contains(\"display-name\",$HOST_NAME)].{\"display-name\":\"display-name\", id:id,\"lifecycle-state\":\"lifecycle-state\"}"


oci compute instance list --compartment-id $COMPARTMENT_OCID \
--output table \
--query "data [?contains(\"display-name\",'$HOST_NAME')].{\"display-name\":\"display-name\",\"lifecycle-state\":\"lifecycle-state\"}"
+--------------+-----------------+
| display-name | lifecycle-state |
+--------------+-----------------+
| ol7docker00  | TERMINATED      |
| ol7docker00  | RUNNING         |
+--------------+-----------------+
```

- get the compute instance ID as variable *INSTANCE_OCID*.

```bash
INSTANCE_OCID=$(oci compute instance list \
--compartment-id $COMPARTMENT_OCID  \
--lifecycle-state 'RUNNING' \
--raw-output --query "data [?contains(\"display-name\",'$HOST_NAME')].id|[0]")
```

### Create Block Storage

Create a new block volume to use with the compute instance *o-db-docker*. We use the variable *COMPARTMENT_OCID* and *AV_DOAMIN* from the previous section. First lets check the variables.

```bash
echo "COMPARTMENT_OCID  = $COMPARTMENT_OCID" && \
echo "AV_DOAMIN         = $AV_DOAMIN"
```

Create the block volume in the compartment *O-DB-DOCKER*.

```bash
oci bv volume create --compartment-id $COMPARTMENT_OCID \
--availability-domain $AV_DOAMIN \
--display-name "o-db-docker_bv00" \
--size-in-gbs 512
```

Get the block volume OCID as variable *VOLUME_OCID*.

```bash
VOLUME_OCID=$(oci bv volume list \
--compartment-id $COMPARTMENT_OCID \
--raw-output --query "data [?contains(\"display-name\",'o-db-docker_bv00')].id|[0]")
```

Assign block volume to compute instance *ol7docker00*.

```bash
oci compute volume-attachment attach \
--instance-id $INSTANCE_OCID \
--type "iscsi" \
--volume-id $VOLUME_OCID \
--device "/dev/oracleoci/oraclevdb"
```

Get the volume IP and volume IQN for the iscsiadm utility later on.

```bash
VOLUME_ATTACH_ID=$(oci compute volume-attachment list \
--compartment-id $COMPARTMENT_OCID --raw-output \
--query "data [?\"volume-id\" == '$VOLUME_OCID'].id|[0]")
VOLUME_IP=$(oci compute volume-attachment get \
--volume-attachment-id $VOLUME_ATTACH_ID \
--raw-output --query "data.ipv4")
VOLUME_IQN=$(oci compute volume-attachment get \
--volume-attachment-id $VOLUME_ATTACH_ID \
--raw-output --query "data.iqn")
```

Log into the compute instance ol7docker00 and attache the iscsi device

```bash
ssh opc@ol7docker00.trivadislabs.com -C "sudo iscsiadm -m node -o new -T $VOLUME_IQN -p $VOLUME_IP:3260"
ssh opc@ol7docker00.trivadislabs.com -C "sudo iscsiadm -m node -o update -T $VOLUME_IQN -n node.startup -v automatic"
ssh opc@ol7docker00.trivadislabs.com -C "sudo iscsiadm -m node -T $VOLUME_IQN -p $VOLUME_IP:3260 -l"
```

### DNS Configuration

Optionally we add the IP of the compute instance to the DNS Zone *trivadislabs.com*.

- Get DNS OCID as variable *DNS_OCID*.

```bash
DNS_OCID=$(oci dns record zone get \
--zone-name-or-id "trivadislabs.com" \
--query "etag" --raw-output|sed 's/.*\(ocid.*\)#.*/\1/')
```

- Get IP address of compute instance as variable *IP_ADDRESS*.

```bash
IP_ADDRESS=$(oci compute instance list-vnics \
--instance-id $INSTANCE_OCID --raw-output \
--query "data[].\"public-ip\"|[0]")
```

- Add DNS record u

```bash
oci dns record domain update \
--domain "$HOST_NAME.trivadislabs.com" \
--zone-name-or-id "trivadislabs.com" \
--force \
--items "[{\"domain\": '$HOST_NAME.trivadislabs.com',\"isProtected\": true,\"rdata\": \"$IP_ADDRESS\",\"recordHash\": null,\"rrsetVersion\": \"4\",\"rtype\": \"A\",\"ttl\": 30}]"
```

- remove DNS record

```bash
oci dns record domain delete \
--zone-name-or-id "trivadislabs.com" \
--domain "$HOST_NAME.trivadislabs.com" --force
```

## Setup OS

This section is not released for production use. Use this just as reference. **Do not run the commands 1:1 on your environment**.

### Configure the Disk and Volume

- Partition disk using `sfdisk`.

```bash
sfdisk /dev/sdb <<EOF
0,25000
,,8e
EOF
```

- List block devices.

```bash
[root@ol7docker00 ~]# lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb      8:16   0   512G  0 disk 
├─sdb2   8:18   0 320.5G  0 part 
└─sdb1   8:17   0 191.5G  0 part 
sda      8:0    0  46.6G  0 disk 
├─sda2   8:2    0     8G  0 part [SWAP]
├─sda3   8:3    0  38.4G  0 part /
└─sda1   8:1    0   200M  0 part /boot/efi
[root@ol7docker00 ~]# fdisk -l /dev/sdb

Disk /dev/sdb: 549.8 GB, 549755813888 bytes, 1073741824 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 1048576 bytes
Disk label type: dos
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1   401624999   200812499+  83  Linux
Partition 1 does not start on physical sector boundary.
/dev/sdb2       401625000  1073736404   336055702+  8e  Linux LVM
```

- Create a physical volume on `/dev/sdb2` using `pvcreate`.

```bash
[root@ol7docker00 ~]$ pvcreate /dev/sdb2
  Physical volume "/dev/sdb2" successfully created.

[root@ol7docker00 ~]$ pvs
  PV         VG Fmt  Attr PSize    PFree   
  /dev/sdb2     lvm2 ---  <320.49g <320.49g

[root@ol7docker00 ~]$ pvdisplay /dev/sdb2
  "/dev/sdb2" is a new physical volume of "<320.49 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb2
  VG Name               
  PV Size               <320.49 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               ONMpyt-j3RW-D4EQ-xpum-l3tR-fL7H-jgAseL
```

- Create volume group *vgora* using `vgcreate`

```bash
[root@ol7docker00 ~]$ vgcreate vgora /dev/sdb2
  Volume group "vgora" successfully created

[root@ol7docker00 ~]$ vgdisplay vgora
  --- Volume group ---
  VG Name               vgora
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               320.48 GiB
  PE Size               4.00 MiB
  Total PE              82044
  Alloc PE / Size       0 / 0   
  Free  PE / Size       82044 / 320.48 GiB
  VG UUID               qDKwXo-M8ad-L0eL-SLld-Mbd9-v83g-bOA6e3
```

- Create a logical volume.

```bash
[root@ol7docker00 ~]$ lvcreate -n vol_u00 -L 100G vgora
  Logical volume "vol_u00" created.
[root@ol7docker00 ~]$ lvcreate -n vol_u01 -L 100G vgora
  Logical volume "vol_u01" created.

[root@ol7docker00 ~]$ lvdisplay
  --- Logical volume ---
  LV Path                /dev/vgora/vol_u00
  LV Name                vol_u00
  VG Name                vgora
  LV UUID                BJ3T5W-xzgy-jpwr-u1vS-Jl3y-tHKJ-bAnXED
  LV Write Access        read/write
  LV Creation host, time ol7docker00, 2019-10-23 15:14:52 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 GiB
  Current LE             25600
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0
   
  --- Logical volume ---
  LV Path                /dev/vgora/vol_u01
  LV Name                vol_u01
  VG Name                vgora
  LV UUID                c2zepi-PnVA-6Cs1-EQgB-yJmz-Wtm5-Q6eL4b
  LV Write Access        read/write
  LV Creation host, time ol7docker00, 2019-10-23 15:15:06 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 GiB
  Current LE             25600
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:1
```

- Create the filesystem on the new volume.

```bash
[root@ol7docker00 ~]# mkfs.ext4 /dev/vgora/vol_u00
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=256 blocks
6553600 inodes, 26214400 blocks
1310720 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2174746624
800 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done   

[root@ol7docker00 ~]# mkfs.ext4 /dev/vgora/vol_u01
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=256 blocks
6553600 inodes, 26214400 blocks
1310720 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2174746624
800 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done  
```

- Get the block device information.

```bash
[root@ol7docker00 ~]# blkid /dev/vgora/vol_u00 /dev/vgora/vol_u01
/dev/vgora/vol_u00: UUID="2d8a938f-5960-4664-9091-eb9bd6132f91" TYPE="ext4" 
/dev/vgora/vol_u01: UUID="2c74d466-221e-49d0-a644-8e1e299cabf4" TYPE="ext4" 
```

- Create mount points

```bash
mkdir -p /u00 /u01
```

- update `fstab` and mount the filesystem.

```bash
echo "$(blkid /dev/vgora/vol_u00|cut -d' ' -f2|tr -d '"')   /u00    ext4   defaults,noatime,_netdev     0   0" >>/etc/fstab
echo "$(blkid /dev/vgora/vol_u01|cut -d' ' -f2|tr -d '"')   /u01    ext4   defaults,noatime,_netdev     0   0" >>/etc/fstab

mount /u00
mount /u01
```

### Setup ORAbase_init Scripts

Define the variable to download the **oradba_init** scripts.

```bash
DOWNLOAD="/tmp/download"
SETUP_INIT="00_setup_oradba_init.sh"
GITHUB_URL="https://github.com/oehrlis/oradba_init/raw/master/bin"
```

Download the **oradba_init** script

```bash
mkdir -p ${DOWNLOAD}
curl -Lsf ${GITHUB_URL}/${SETUP_INIT} -o ${DOWNLOAD}/${SETUP_INIT}
```

Setup the OraDBA init environment.

```bash
chmod 755 ${DOWNLOAD}/${SETUP_INIT}
${DOWNLOAD}/${SETUP_INIT}
```

Setup the OUDBase environment

```bash
sudo -u oracle /opt/oradba/bin/20_setup_oudbase.sh

echo "oud_eng:1389:1636:4444:8989:OUD:Y" >>${ETC_BASE}/oudtab
. oudenv.sh

sed -i 's|\. ${OUD_BASE}/bin/oudenv.sh|\. ${OUD_BASE}/bin/oudenv.sh SILENT|' $HOME/.bash_profile
```

### Update User / Group information

Configure the opc user

```bash
sudo usermod -a -G oinstall opc
```

Adjust a few directory settings:

```bash
chmod 775 /u00/app/
chmod 775 /u00/app/oracle/
chmod 775 /u00/app/oracle/software/
```

### Setup OS Oracle DB

Setup the OS using the **oradba_init** script.

```bash
nohup /opt/oradba/bin/01_setup_os_db.sh > /tmp/01_setup_os_db.sh 2>&1 &
```

Install Docker

```bash
nohup /opt/oradba/bin/01_setup_os_docker.sh > /tmp/01_setup_os_docker.log 2>&1 &
```

Install git

```
yum install git
```

Configure docker volumen on `sdb1`.

```bash
systemctl stop docker
rm -rf /var/lib/docker
docker-storage-config -s btrfs -d /dev/sdb1
systemctl start docker
systemctl enable docker
```

Clone the git repositories.

```bash
cd /u00/app/oracle/local
git clone https://github.com/oehrlis/docker.git docker
git clone https://github.com/oehrlis/o-db-docker.git o-db-docker
git clone https://github.com/oracle/docker-images.git docker-images
```

### Build Software Depot

Generate download url file from the `*.download` files which are part of the [oradba/docker](https://github.com/oehrlis/docker) repository.

- change to the oci working directory and remove the old download url files.

```bash
cd $cdl/o-db-docker/lab/oci

rm download*.url
```

- build a new download url file

```bash
find $cdl/docker -name *.download \
-exec grep -i "Direct Download" {} \;| \
sed "s/# Direct Download   : //" |\
grep -iv '^#'|grep -iv 'n/a'|sort -u>> download.url
```

- Separate OTN from MOS downloads

```bash
grep -i "download.oracle.com" download.url >download_otn.url
grep -iv "download.oracle.com" download.url >download_mos.url
```

Start to download the patch from MOS using `curl`.

- Temporary create a `.netrc` file with MOS credentials. Replace *MOS_USER* and *MOS_PASSWORD* with corresponding values.

```bash
cd $cdl/o-db-docker/lab/oci
echo 'machine login.oracle.com login MOS_USER password MOS_PASSWORD' >.netrc
```

- Download the files from MOS using `download_mos.url`.

```bash
cd $cdl/o-db-docker/lab/oci
sw="/u00/app/oracle/software"
for url in $(cat download_mos.url); do
  file=$(echo $url| cut -d= -f3)
  log=$(basename $file .zip).log
  echo "Initiate download job for file : $file"
  nohup curl --netrc-file .netrc --cookie-jar cookie-jar.txt \
    --location-trusted "${url}" -o ${sw}/${file} > ${sw}/$log 2>&1 &
done
```

- Wait until all curl background jobs are done:

```bash
ps -ef|grep curl
ps -ef|grep curl|wc -l
```

### Other Task to Configure Environment

Tasks to configure the environment:

- Disk partition
- Docker Volume
- Docker images
- Clone the Git repositories
- Download Oracle Binaries

## Create Custom Image

Stop the compute instance

- define my variables

```bash
export HOST_NAME="ol7docker00"
export COMPARTMENT_NAME="O-DB-DOCKER"
```

- Get the compartment id as variable *COMPARTMENT_OCID*.

```bash
COMPARTMENT_OCID=$(oci iam compartment list \
--compartment-id-in-subtree true --all \
--raw-output --query "data [?name == '${COMPARTMENT_NAME}'].id|[0]")
```

- get the compute instance ID as variable *INSTANCE_OCID*.

```bash
INSTANCE_OCID=$(oci compute instance list \
--compartment-id $COMPARTMENT_OCID  \
--lifecycle-state 'RUNNING' \
--raw-output --query "data [?contains(\"display-name\",'${HOST_NAME}')].id|[0]")
```

- stopping compute instance

```bash
oci compute instance action \
--action SOFTSTOP \
--instance-id ${INSTANCE_OCID}
```

- check if stoppend

```bash
oci compute instance list --compartment-id $COMPARTMENT_OCID \
--output table \
--query "data [?contains(\"display-name\",'${HOST_NAME}')].{\"display-name\":\"display-name\",\"lifecycle-state\":\"lifecycle-state\"}"
```

- Create a custom image

```bash
oci compute image create \
--compartment-id $COMPARTMENT_OCID \
--display-name "${COMPARTMENT_NAME}_master" \
--instance-id ${INSTANCE_OCID}
```

**Disclaimer**: This guide has been created with utmost care, but does not claim to be complete. It was compiled as part of the preparation for the *O-DB-DOCKER* workshop. The author assumes no responsibility for the accuracy, completeness and timeliness of the content. The use of the available content is at your own risk.