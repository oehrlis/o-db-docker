## Clone Trainee Instances

### Create Compute Instance

To create a compute instance we first have to get a few OCID's for different components.

```bash
export HOST_NAME="ol7docker01"
export COMPARTMENT_NAME="O-DB-DOCKER"
```

- Get the compartment id as variable *COMPARTMENT_OCID*.

```bash
COMPARTMENT_OCID=$(oci iam compartment list \
--compartment-id-in-subtree true --all \
--raw-output --query "data [?name == '${COMPARTMENT_NAME}'].id|[0]")
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

- Get the *ocid* of the Oracle Linux image as variable *IMAGE_OCID*.

```bash
IMAGE_OCID=$(oci compute image list --compartment-id $COMPARTMENT_OCID \
--display-name "O-DB-DOCKER_master_v00" \
--raw-output --query "data [*].id|[0]")
```

- Create a SSH key pair for the compute instance

```bash
cd o-db-docker/lab/oci/
ssh-keygen -b 4096 -C "DOAG 2019 Training ${HOST_NAME}" -f id_rsa_${HOST_NAME} -N ""
```

- check the variables

```bash
echo "COMPARTMENT_OCID  = $COMPARTMENT_OCID" && \
echo "HOST_NAME         = $HOST_NAME" && \
echo "AV_DOAMIN         = $AV_DOAMIN" && \
echo "IMAGE_OCID        = $IMAGE_OCID" && \
echo "SUBNET_OCID       = $SUBNET_OCID" && \
echo "SSH Key           = $(cat id_rsa_${HOST_NAME})"
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
--ssh-authorized-keys-file id_rsa_${HOST_NAME}.pub
```

- check the provisioning status

```bash
oci compute instance list --compartment-id $COMPARTMENT_OCID \
--output table \
--query "data [?contains(\"display-name\",'$HOST_NAME')].{\"display-name\":\"display-name\",\"lifecycle-state\":\"lifecycle-state\"}"
```

```bash
oci compute instance list --compartment-id $COMPARTMENT_OCID \
--query "data [?contains(\"display-name\",'$HOST_NAME')].\"lifecycle-state\"|[0]" --raw-output
```

- get the compute instance ID as variable *INSTANCE_OCID*.

```bash
INSTANCE_OCID=$(oci compute instance list \
--compartment-id $COMPARTMENT_OCID  \
--lifecycle-state 'RUNNING' \
--raw-output --query "data [?contains(\"display-name\",'$HOST_NAME')].id|[0]")
```

- Get the block volume OCID from the master block volume as variable *VOLUME_OCID*.

```bash
VOLUME_OCID=$(oci bv volume list \
--compartment-id $COMPARTMENT_OCID \
--raw-output --query "data [?contains(\"display-name\",'o-db-docker_bv00_master_v00')].id|[0]")
```

- clone block volume

```bash
oci bv volume create --compartment-id $COMPARTMENT_OCID \
--availability-domain $AV_DOAMIN \
--display-name "o-db-docker_bv00_$HOST_NAME" \
--source-volume-id $VOLUME_OCID
```

- clone block volume

```bash
oci bv volume create --compartment-id $COMPARTMENT_OCID \
--availability-domain $AV_DOAMIN \
--display-name "o-db-docker_bv00_$HOST_NAME" \
--source-volume-id $VOLUME_OCID
```

- check the provisioning status

```bash
oci bv volume list --compartment-id $COMPARTMENT_OCID \
--output table \
--query "data [?contains(\"display-name\",'o-db-docker_bv00_$HOST_NAME')].{\"display-name\":\"display-name\",\"lifecycle-state\":\"lifecycle-state\"}"

oci bv volume list --compartment-id $COMPARTMENT_OCID \
--output table \
--query "data [?contains(\"display-name\",'o-db-docker_bv00_$HOST_NAME')].\"lifecycle-state\"|[0]" --raw-output
```

- Get the block volume OCID from the master block volume as variable *VOLUME_OCID*.

```bash
VOLUME_OCID=$(oci bv volume list \
--compartment-id $COMPARTMENT_OCID \
--raw-output --query "data [?contains(\"display-name\",'o-db-docker_bv00_$HOST_NAME')].id|[0]")
```

- check the variables

```bash
echo "INSTANCE_OCID  = $INSTANCE_OCID" && \
echo "VOLUME_OCID    = $VOLUME_OCID"
```

- Assign block volume to compute instance *ol7docker00*.

```bash
oci compute volume-attachment attach \
--instance-id $INSTANCE_OCID \
--type iscsi \
--volume-id $VOLUME_OCID \
--device "/dev/oracleoci/oraclevdb"
```

- Get the volume IP and volume IQN for the iscsiadm utility later on.

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

```bash
[{domain: \"$HOST_NAME.trivadislabs.com\",isProtected: true,rdata: \"$IP_ADDRESS\",recordHash: null,rrsetVersion: 4,rtype: \"A\",ttl: 30},
  {
    "domain": "string",
    "isProtected": true,
    "rdata": "string",
    "recordHash": "string",
    "rrsetVersion": "string",
    "rtype": "string",
    "ttl": 0
  }
]
echo oci dns record domain update \
--domain "$HOST_NAME.trivadislabs.com" \
--zone-name-or-id "trivadislabs.com" \
--force \
--items "[{domain: \"$HOST_NAME.trivadislabs.com\",isProtected: true,rdata: \"$IP_ADDRESS\",recordHash: null,rrsetVersion: 4,rtype: \"A\",ttl: 30},{domain: \"$HOST_NAME.trivadislabs.com\",isProtected: true,rdata: \"$IP_ADDRESS\",recordHash: null,rrsetVersion: 4,rtype: \"A\",ttl: 30}]"
```

ssh opc@$HOST_NAME.trivadislabs.com

Log into the compute instance ol7docker00 and attache the iscsi device

```bash
ssh opc@$IP_ADDRESS -C "sudo iscsiadm -m node -o new -T $VOLUME_IQN -p $VOLUME_IP:3260"
ssh opc@$IP_ADDRESS -C "sudo iscsiadm -m node -o update -T $VOLUME_IQN -n node.startup -v automatic"
ssh opc@$IP_ADDRESS -C "sudo iscsiadm -m node -T $VOLUME_IQN -p $VOLUME_IP:3260 -l"
```