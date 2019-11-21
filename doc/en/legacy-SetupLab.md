# Setup LAB environment

## Configure Block Volume

Add new block volume as LVM. 

Add iSCSI device. See OCI console xyz for the commands

```bash
sudo iscsiadm -m node -o new -T iqn.2015-12.com.oracleiaas:24020b38-bb01-4e9c-8430-961ad50d6519 -p 169.254.2.2:3260
sudo iscsiadm -m node -o update -T iqn.2015-12.com.oracleiaas:24020b38-bb01-4e9c-8430-961ad50d6519 -n node.startup -v automatic
sudo iscsiadm -m node -T iqn.2015-12.com.oracleiaas:24020b38-bb01-4e9c-8430-961ad50d6519 -p 169.254.2.2:3260 -l
```

Partition the new block device using `fdisk`. Create a partition for Docker as well one for a logical volume.

```
[root@ol7docker00 /]# fdisk /dev/sdb 

The device presents a logical sector size that is smaller than
the physical sector size. Aligning to a physical sector (or optimal
I/O) size boundary is recommended, or performance may be impacted.
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-536870911, default 2048): 2048
Last sector, +sectors or +size{K,M,G} (2048-536870911, default 536870911): +128G
Partition 1 of type Linux and of size 128 GiB is set

Command (m for help): n
Partition type:
   p   primary (1 primary, 0 extended, 3 free)
   e   extended
Select (default p): p
Partition number (2-4, default 2): 2
First sector (268437504-536870911, default 268437504): 268437504
Last sector, +sectors or +size{K,M,G} (268437504-536870911, default 536870911): 536870911
Partition 2 of type Linux and of size 128 GiB is set

Command (m for help): t
Partition number (1,2, default 2): 2
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@ol7docker00 /]# fdisk -l
WARNING: fdisk GPT support is currently new, and therefore in an experimental phase. Use at your own discretion.

Disk /dev/sda: 50.0 GB, 50010783744 bytes, 97677312 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 1048576 bytes
Disk label type: gpt
Disk identifier: 55333A97-0254-4C27-AE53-78CF37C38A1E


#         Start          End    Size  Type            Name
 1         2048       411647    200M  EFI System      EFI System Partition
 2       411648     17188863      8G  Linux swap      
 3     17188864     97675263   38.4G  Microsoft basic 

Disk /dev/sdb: 274.9 GB, 274877906944 bytes, 536870912 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 1048576 bytes
Disk label type: dos
Disk identifier: 0x84478f5b

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048   268437503   134217728   83  Linux
/dev/sdb2       268437504   536870911   134216704   8e  Linux LVM
```

Create physical volume using `pvcreate`.

```
[root@ol7docker00 /]# pvcreate /dev/sdb2
  Physical volume "/dev/sdb2" successfully created.
```

Create volume group using `vgcreate`.

```
[root@ol7docker00 /]# vgcreate vgora /dev/sdb2
  Volume group "vgora" successfully created
[root@ol7docker00 /]# vgs
  VG    #PV #LV #SN Attr   VSize    VFree   
  vgora   1   0   0 wz--n- <128.00g <128.00g
```

Create logical volume using `lvcreate`.

```
[root@ol7docker00 /]# lvcreate -n u00 -l 100%FREE vgora
  Logical volume "u00" created.
[root@ol7docker00 /]# lvs
  LV   VG    Attr       LSize    Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  u00  vgora -wi-a----- <128.00g  
```

Create an xfs file system using `mkfs.xfs`.

```
[root@ol7docker00 ~]# mkfs.xfs /dev/mapper/vgora-u00
[root@ol7docker00 /]# mkfs.xfs /dev/mapper/vgora-u00
meta-data=/dev/mapper/vgora-u00  isize=256    agcount=4, agsize=8388352 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=33553408, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=16383, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

Update `/etc/fstab` and mount the file system.

```
[root@ol7docker00 ~]# echo "/dev/mapper/vgora-u00                     /u00                    xfs     defaults,_netdev,_netdev 0 0" >>/etc/fstab
[root@ol7docker00 ~]# mkdir -p /u00
[root@ol7docker00 ~]# mount /u00
```

## Prepare Block Volume

Create directories for Oracle binaries, Software and Docker stuff.

```
[root@ol7docker00 ~]# mkdir -p /u00/app/oracle
[root@ol7docker00 ~]# mkdir -p /u00/data
[root@ol7docker00 ~]# mkdir -p /u00/software
```

## Update System 

install oradba_init

```bash
export DOWNLOAD="/tmp/download" 
export SETUP_INIT="00_setup_oradba_init.sh"
export SETUP_OS="01_setup_os_db.sh"
export ORADBA_INIT="/opt/oradba/bin" 
mkdir -p ${DOWNLOAD}
GITHUB_URL="https://github.com/oehrlis/oradba_init/raw/master/bin"
curl -Lsf ${GITHUB_URL}/${SETUP_INIT} -o ${DOWNLOAD}/${SETUP_INIT}
chmod 755 ${DOWNLOAD}/${SETUP_INIT}
${DOWNLOAD}/${SETUP_INIT}

${ORADBA_INIT}/${SETUP_OS}
```

Install additional stuff

yum install -y git
yum install -y htop
yum install -y docker-engine
yum install -y podman podman-docker skopeo 

podman

docker-storage-config -s btrfs -d /dev/sdb1 -f 

systemctl start docker
systemctl enable docker


usermod -a -G docker oracle