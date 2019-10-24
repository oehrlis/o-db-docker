export cid=ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq


oci compute image list --compartment-id $cid --query 'data[?contains("display-name",Oracle-Linux-7.6-20)]|[0:1].["display-name",id]'

oci compute image list --compartment-id $cid --query 'data[?contains("display-name",Oracle)]|[0:1].["display-name",id]'

oci compute image list -c ocid1.compartment.oc1..aaaaaaaapxgklgmujxjzx2ypptfjrcieq7rrob2u2zbesh3wlafsgthhqtea --output table

oci compute image list --compartment-id $cid --output table --query "data [*].{ImageName:\"display-name\", OCID:id}"

oci compute image list --compartment-id $cid --output table --query "data [*].{ImageName:\"display-name\", OCID:id}"

oci iam compartment list --query "data [?name == 'O-DB-DOCKER'].{OCID:id}"

oci iam compartment list --query "data [?name == 'O-DB-DOCKER'].{OCID:id}"

oci compute image list --compartment-id $cid --query "data[?contains(\"display-name\",Oracle)]"
oci compute image list --compartment-id $cid --query "data[? contains(\"display-name\",'Oracle-Linux-7.7-2019')]"

oci iam compartment list --compartment-id-in-subtree true --all --query "data [?name == 'O-DB-DOCKER'].{OCID:id}"
Usage: oci iam compartment list [OPTIONS]

 oci iam compartment list --compartment-id-in-subtree true --all --raw-output --query "data [?name == 'O-DB-DOCKER'].id|[0]"
ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq



soe@gaia:~/Development/o-db-docker/ [ic12201] oci network vcn list --compartment-id $COMP_OCID
{
  "data": [
    {
      "cidr-block": "10.0.0.0/16",
      "compartment-id": "ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq",
      "default-dhcp-options-id": "ocid1.dhcpoptions.oc1.eu-frankfurt-1.aaaaaaaatfpv7gddntdpadbqix7n2ok6znmtl575pzqxx7js4a7w3xs5wqyq",
      "default-route-table-id": "ocid1.routetable.oc1.eu-frankfurt-1.aaaaaaaanv2422jzavhmghlpte4cuoezort6rgmofs6w4sslt5ybxme2ucsq",
      "default-security-list-id": "ocid1.securitylist.oc1.eu-frankfurt-1.aaaaaaaas3ip26duhz24idwjszwpb2fgvbygjx3octisxn5vhnkuix2amsvq",
      "defined-tags": {},
      "display-name": "vcn-o-db-docker",
      "dns-label": "vcnodbdocker",
      "freeform-tags": {},
      "id": "ocid1.vcn.oc1.eu-frankfurt-1.aaaaaaaaq2f2n6wq5wvvnfd55kpj7dfnzqlsuacyb4lhjjiswbhdizb3kt5a",
      "ipv6-cidr-block": null,
      "ipv6-public-cidr-block": null,
      "lifecycle-state": "AVAILABLE",
      "time-created": "2019-10-08T10:45:56.425000+00:00",
      "vcn-domain-name": "vcnodbdocker.oraclevcn.com"
    }
  ]
}

oci network vcn create \
--compartment-id $COMP_OCID \
--cidr-block "10.0.0.0/16" \
--display-name "vcn-o-db-docker" \
--dns-label "vcnodbdocker"

soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci iam compartment list --compartment-id-in-subtree true --all --query "data [?name == 'O-DB-DOCKER'].id"
[
  "ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq"
]
soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci iam compartment list --compartment-id-in-subtree true --all --query "data [?name == 'O-DB-DOCKER'].id|[0]"



# query compartment ocid
oci iam compartment list --compartment-id-in-subtree true --all --query "data [?name == 'O-DB-DOCKER'].{OCID:id}"
oci iam compartment list --compartment-id-in-subtree true --all --query "data [?name == 'O-DB-DOCKER'].{OCID:id}[]"
oci iam compartment list --compartment-id-in-subtree true --all --query "data [?name == 'O-DB-DOCKER'].id|[0]"
"ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq"

oci network vcn list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq --query "data [?\"display-name\" == 'vcn-o-db-docker'].id|[0]"
"ocid1.vcn.oc1.eu-frankfurt-1.aaaaaaaaq2f2n6wq5wvvnfd55kpj7dfnzqlsuacyb4lhjjiswbhdizb3kt5a"


oci network vcn list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [?contains(\"display-name\",'o-db-docker')].id|[0]"


oci network vcn list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [?contains(\"display-name\",'o-db-docker')].id|[0]"

oci compute image list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [?contains(\"display-name\",'Oracle-Linux-7.7')]"
oci compute image list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [?contains(\"display-name\",'Oracle-Linux-7.7')].{\"display-name\":\"display-name\",id:id, Created:\"time-created\"}|sort"



oci compute image list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [?contains(\"display-name\",'Oracle-Linux-7')].id|[0]" --sort-by TIMECREATED
"ocid1.image.oc1.eu-frankfurt-1.aaaaaaaajqghpxnszpnghz3um66jywaw5q3pudfw5qwwkyu24ef7lcsyjhsq"


oci compute instance list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [*].{\"display-name\":\"display-name\", id:id,\"lifecycle-state\":\"lifecycle-state\"}"

[
  {
    "display-name": "ol7docker00",
    "id": "ocid1.instance.oc1.eu-frankfurt-1.antheljssijhdmqcjz64dmphurorq7zllog4wgktipchgz5mcqxhmxwy4eha",
    "lifecycle-state": "STOPPED"
  },
  {
    "display-name": "ol7docker01",
    "id": "ocid1.instance.oc1.eu-frankfurt-1.antheljssijhdmqc2ekacdxajwjec4rbdqr3ewlt4sky4qhyeyfygtwum4cq",
    "lifecycle-state": "TERMINATED"
  }
]

oci compute instance list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [?\"display-name\" == 'ol7docker01'].id|[0]" 

oci compute instance list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [?\"display-name\" == 'ol7docker00'].id|[0]" 


soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci compute instance list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
> --query "data [?\"display-name\" == 'ol7docker01'].id|[0]" 
"ocid1.instance.oc1.eu-frankfurt-1.antheljssijhdmqc2ekacdxajwjec4rbdqr3ewlt4sky4qhyeyfygtwum4cq"
soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci compute instance list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
> --query "data [?\"display-name\" == 'ol7docker00'].id|[0]" 
"ocid1.instance.oc1.eu-frankfurt-1.antheljssijhdmqcjz64dmphurorq7zllog4wgktipchgz5mcqxhmxwy4eha"


oci compute instance terminate --instance-id ocid1.instance.oc1.eu-frankfurt-1.antheljssijhdmqc2ekacdxajwjec4rbdqr3ewlt4sky4qhyeyfygtwum4cq --force

oci compute instance terminate --instance-id ocid1.instance.oc1.eu-frankfurt-1.antheljssijhdmqcjz64dmphurorq7zllog4wgktipchgz5mcqxhmxwy4eha --force
{Name:name,OCID:id, Created:\"time-created\"}
 
+--------------------+--------+-----------------------------+
| Created            | Name   | OCID                        |
+--------------------+--------+-----------------------------+
| 2018-07-27T16:20:36| Fun    | ocid1.compartment.oc1..xxxx |


oci search resource free-text-search --text "trivadislabs.com"

soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci search resource free-text-search --text "trivadislabs"
{
  "data": {
    "items": [
      {
        "availability-domain": null,
        "compartment-id": "ocid1.tenancy.oc1..aaaaaaaac3gjl7xgpxu3mmqh2hahws2loithifufgimnjkmmac2r33dr6tfq",
        "defined-tags": {},
        "display-name": "Compartment_trivadislabs",
        "freeform-tags": {},
        "identifier": "ocid1.compartment.oc1..aaaaaaaafol5eodbvwq3525cmjbmyhcovnm5iyg7glojqlwmmjlubcwqe5ka",
        "lifecycle-state": "ACTIVE",
        "resource-type": "Compartment",
        "search-context": null,
        "time-created": "2019-10-08T08:33:22.851000+00:00"
      }
    ]
  }
}


oci dns zone list --compartment-id ocid1.tenancy.oc1..aaaaaaaac3gjl7xgpxu3mmqh2hahws2loithifufgimnjkmmac2r33dr6tfq

oci dns zone list --compartment-id ocid1.compartment.oc1..aaaaaaaafol5eodbvwq3525cmjbmyhcovnm5iyg7glojqlwmmjlubcwqe5ka
{
  "data": [
    {
      "compartment-id": "ocid1.compartment.oc1..aaaaaaaafol5eodbvwq3525cmjbmyhcovnm5iyg7glojqlwmmjlubcwqe5ka",
      "defined-tags": null,
      "freeform-tags": null,
      "id": "ocid1.dns-zone.oc1..40b8141ccba041d695c76d385b33938c",
      "lifecycle-state": "ACTIVE",
      "name": "trivadislabs.com",
      "self-uri": "https://dns.eu-frankfurt-1.oraclecloud.com/20180115/zones/trivadislabs.com",
      "serial": 2,
      "time-created": "2019-10-08T13:38:18+00:00",
      "version": "2",
      "zone-type": "PRIMARY"
    }
  ],
  "opc-total-items": "1"
}
oci dns zone list 
oci dns record zone get --zone-name-or-id "trivadislabs.com"

oci dns record domain get --zone-name-or-id "trivadislabs.com" --domain "ol7docker00.trivadislabs.com"
soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci dns record domain get --zone-name-or-id "trivadislabs.com" --domain "ol7docker00.trivadislabs.com"
{
  "data": {
    "items": [
      {
        "domain": "ol7docker00.trivadislabs.com",
        "is-protected": false,
        "rdata": "130.61.41.13",
        "record-hash": "5f8b61f3375c791fac111c54403ae934",
        "rrset-version": "2",
        "rtype": "A",
        "ttl": 30
      }
    ]
  },
  "etag": "\"2ocid1.dns-zone.oc1..40b8141ccba041d695c76d385b33938c#application/json\"",
  "opc-total-items": "1"
}

soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci dns record domain delete --zone-name-or-id "trivadislabs.com" --domain "ol7docker00.trivadislabs.com"
Are you sure you want to delete this resource? [y/N]: n
Abort: 
soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci dns record domain delete --zone-name-or-id "trivadislabs.com" --domain "ol7docker00.trivadislabs.com" --force
soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci dns record domain get --zone-name-or-id "trivadislabs.com" --domain "ol7docker00.trivadislabs.com"
{
  "data": {
    "items": []
  },
  "etag": "\"3ocid1.dns-zone.oc1..40b8141ccba041d695c76d385b33938c#application/json\"",
  "opc-total-items": "0"
}
soe@gaia:~/Development/o-db-docker/work/ [ic12201] oci dns record zone get --zone-name-or-id "trivadislabs.com"
{
  "data": {
    "items": [
      {
        "domain": "trivadislabs.com",
        "is-protected": true,
        "rdata": "ns1.p68.dns.oraclecloud.net. hostmaster.trivadislabs.com. 3 3600 600 604800 1800",
        "record-hash": "0450aedd9e20ce567372db074c383dd6",
        "rrset-version": "3",
        "rtype": "SOA",
        "ttl": 300
      },
      {
        "domain": "trivadislabs.com",
        "is-protected": true,
        "rdata": "ns2.p68.dns.oraclecloud.net.",
        "record-hash": "1177f107892f1e53c37b030e58b0e9c4",
        "rrset-version": "1",
        "rtype": "NS",
        "ttl": 86400
      },
      {
        "domain": "trivadislabs.com",
        "is-protected": true,
        "rdata": "ns1.p68.dns.oraclecloud.net.",
        "record-hash": "1f78840571b4e5e6df577e5895c4e372",
        "rrset-version": "1",
        "rtype": "NS",
        "ttl": 86400
      },
      {
        "domain": "trivadislabs.com",
        "is-protected": true,
        "rdata": "ns4.p68.dns.oraclecloud.net.",
        "record-hash": "64c9bc7d4e36459f31120673e7f5d9bb",
        "rrset-version": "1",
        "rtype": "NS",
        "ttl": 86400
      },
      {
        "domain": "trivadislabs.com",
        "is-protected": true,
        "rdata": "ns3.p68.dns.oraclecloud.net.",
        "record-hash": "fffd72b04578f05cd7752b68986d5116",
        "rrset-version": "1",
        "rtype": "NS",
        "ttl": 86400
      }
    ]
  },
  "etag": "\"3ocid1.dns-zone.oc1..40b8141ccba041d695c76d385b33938c#application/json--gzip\"",
  "opc-total-items": "5"
}



"data[? contains(\"display-name\",'Oracle-Linux-7.7-2019')]"
"ocid1.vcn.oc1.eu-frankfurt-1.aaaaaaaaq2f2n6wq5wvvnfd55kpj7dfnzqlsuacyb4lhjjiswbhdizb3kt5a"

oci network vcn list --compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq --query "data [?display-name == 'vcn-o-db-docker'].id|[0]"

oci iam availability-domain list \
--compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [].id"

oci iam availability-domain list \
--compartment-id ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq \
--query "data [].id|[1]"

oci compute instance launch --compartment-id $cid \
--availability-domain EUZg:EU-FRANKFURT-1-AD-1 \
--display-name ol7docker01 \
--image-id ocid1.image.oc1.eu-frankfurt-1.aaaaaaaajqghpxnszpnghz3um66jywaw5q3pudfw5qwwkyu24ef7lcsyjhsq \
--subnet-id ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaanjgspqhysrbhges5pbno3jscqt73pwazvxvfcmri6qukaq2czwfa \
--shape VM.Standard2.2 \
--assign-public-ip true \
--metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9w9iIilHiV2pOx97sFDpJySKfswTRC40uwE3MExxjJvIMB8y+BlQ9jG5b0FYieR/kfkUMrORVjBm+LXeAqTDM9Eqzyrmozx4vpsuEcxBiLApYBQxn327kjpjMkhPt11xbQsKZg7faT08x16Gln9eHhbflK1QFi11sqpl/6vN36O1wJ8RCZ06K0uxyZglVRk9UJ426Zgt1KFAQAQ0ebTrrn4RtrvPZTlc63IQqgeBOGqtGW/0oXezU0Nf3pAg/PP0HOshqJaslX6brnM7yoSujH8Q0GXgyWiO1gSkrgtlwgMMKLBU5XztdWTwuvgqGVGA19ULCuktukeffNRqb0aulPnfPnl58Lah/oOT7GGl7RiRt73SsdUrYz6KHJnpKeiIpi2x+fQO2FccQfKGZppgyMkE9+J8xz2MSSlFC6MsJeRUuNgW9joorADmpROHQULsUKPqDiKJeLdJwQOIvOWKD3tXXvA8xuAt8HR0P7jvYlLVD9ovnBxDEqy/2Oj08TFqc5/bnG1EEXUQDYe9tPRR8RfpiJP9sVotPYy1eRyMusZSIJMvcQyohHF0jJ4Ge5L6jVQja8TR+/+unCmH5tgr3P22fzkdTX3S8ascMOI34X38JJg1lxTSOH2t4I04gowMBEsEKfb6H0m16zOdOa58Wrkg2aU1AoAKKJcjZyrndnw== DOAG 2019 Training"}'

soe@gaia:~/ [ic12201] oci compute instance launch --compartment-id $cid \
> --availability-domain EUZg:EU-FRANKFURT-1-AD-1 \
> --display-name ol7docker01 \
> --image-id ocid1.image.oc1.eu-frankfurt-1.aaaaaaaajqghpxnszpnghz3um66jywaw5q3pudfw5qwwkyu24ef7lcsyjhsq \
> --subnet-id ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaanjgspqhysrbhges5pbno3jscqt73pwazvxvfcmri6qukaq2czwfa \
> --shape VM.Standard2.2 \
> --assign-public-ip true \
> --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9w9iIilHiV2pOx97sFDpJySKfswTRC40uwE3MExxjJvIMB8y+BlQ9jG5b0FYieR/kfkUMrORVjBm+LXeAqTDM9Eqzyrmozx4vpsuEcxBiLApYBQxn327kjpjMkhPt11xbQsKZg7faT08x16Gln9eHhbflK1QFi11sqpl/6vN36O1wJ8RCZ06K0uxyZglVRk9UJ426Zgt1KFAQAQ0ebTrrn4RtrvPZTlc63IQqgeBOGqtGW/0oXezU0Nf3pAg/PP0HOshqJaslX6brnM7yoSujH8Q0GXgyWiO1gSkrgtlwgMMKLBU5XztdWTwuvgqGVGA19ULCuktukeffNRqb0aulPnfPnl58Lah/oOT7GGl7RiRt73SsdUrYz6KHJnpKeiIpi2x+fQO2FccQfKGZppgyMkE9+J8xz2MSSlFC6MsJeRUuNgW9joorADmpROHQULsUKPqDiKJeLdJwQOIvOWKD3tXXvA8xuAt8HR0P7jvYlLVD9ovnBxDEqy/2Oj08TFqc5/bnG1EEXUQDYe9tPRR8RfpiJP9sVotPYy1eRyMusZSIJMvcQyohHF0jJ4Ge5L6jVQja8TR+/+unCmH5tgr3P22fzkdTX3S8ascMOI34X38JJg1lxTSOH2t4I04gowMBEsEKfb6H0m16zOdOa58Wrkg2aU1AoAKKJcjZyrndnw== DOAG 2019 Training"}'
{
  "data": {
    "agent-config": {
      "is-monitoring-disabled": false
    },
    "availability-domain": "EUZg:EU-FRANKFURT-1-AD-1",
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq",
    "dedicated-vm-host-id": null,
    "defined-tags": {},
    "display-name": "ol7docker01",
    "extended-metadata": {},
    "fault-domain": "FAULT-DOMAIN-2",
    "freeform-tags": {},
    "id": "ocid1.instance.oc1.eu-frankfurt-1.antheljssijhdmqc2ekacdxajwjec4rbdqr3ewlt4sky4qhyeyfygtwum4cq",
    "image-id": "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaajqghpxnszpnghz3um66jywaw5q3pudfw5qwwkyu24ef7lcsyjhsq",
    "ipxe-script": null,
    "launch-mode": "NATIVE",
    "launch-options": {
      "boot-volume-type": "PARAVIRTUALIZED",
      "firmware": "UEFI_64",
      "is-consistent-volume-naming-enabled": true,
      "is-pv-encryption-in-transit-enabled": true,
      "network-type": "PARAVIRTUALIZED",
      "remote-data-volume-type": "PARAVIRTUALIZED"
    },
    "lifecycle-state": "PROVISIONING",
    "metadata": {
      "ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9w9iIilHiV2pOx97sFDpJySKfswTRC40uwE3MExxjJvIMB8y+BlQ9jG5b0FYieR/kfkUMrORVjBm+LXeAqTDM9Eqzyrmozx4vpsuEcxBiLApYBQxn327kjpjMkhPt11xbQsKZg7faT08x16Gln9eHhbflK1QFi11sqpl/6vN36O1wJ8RCZ06K0uxyZglVRk9UJ426Zgt1KFAQAQ0ebTrrn4RtrvPZTlc63IQqgeBOGqtGW/0oXezU0Nf3pAg/PP0HOshqJaslX6brnM7yoSujH8Q0GXgyWiO1gSkrgtlwgMMKLBU5XztdWTwuvgqGVGA19ULCuktukeffNRqb0aulPnfPnl58Lah/oOT7GGl7RiRt73SsdUrYz6KHJnpKeiIpi2x+fQO2FccQfKGZppgyMkE9+J8xz2MSSlFC6MsJeRUuNgW9joorADmpROHQULsUKPqDiKJeLdJwQOIvOWKD3tXXvA8xuAt8HR0P7jvYlLVD9ovnBxDEqy/2Oj08TFqc5/bnG1EEXUQDYe9tPRR8RfpiJP9sVotPYy1eRyMusZSIJMvcQyohHF0jJ4Ge5L6jVQja8TR+/+unCmH5tgr3P22fzkdTX3S8ascMOI34X38JJg1lxTSOH2t4I04gowMBEsEKfb6H0m16zOdOa58Wrkg2aU1AoAKKJcjZyrndnw== DOAG 2019 Training"
    },
    "region": "eu-frankfurt-1",
    "shape": "VM.Standard2.2",
    "source-details": {
      "boot-volume-size-in-gbs": null,
      "image-id": "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaajqghpxnszpnghz3um66jywaw5q3pudfw5qwwkyu24ef7lcsyjhsq",
      "kms-key-id": null,
      "source-type": "image"
    },
    "system-tags": {},
    "time-created": "2019-10-22T14:43:14.759000+00:00",
    "time-maintenance-reboot-due": null
  },
  "etag": "e586c7f3b7ad85c07d7a2b5561c881485fef24f6306df1822691b6132868daed",
  "opc-work-request-id": "ocid1.coreservicesworkrequest.oc1.eu-frankfurt-1.abtheljsvseytowvzolika5ylbecus47alqco3gr774kojsyhj2lzobqodka"
}


oci compute instance get --instance-id ocid1.instance.oc1.eu-frankfurt-1.antheljssijhdmqc2ekacdxajwjec4rbdqr3ewlt4sky4qhyeyfygtwum4cq --query 'data."lifecycle-state"'