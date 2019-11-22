#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: oci_o-db-docker.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2019.10.28
# Revision...: 
# Purpose....: Script to do simple stop on the OCI compartments 
# Notes......: 
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as 
#              shown at http://oss.oracle.com/licenses/upl.
# ---------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ---------------------------------------------------------------------------
# TODO: handle oci errors
# - Customization -----------------------------------------------------------
DEFAULT_COMPARTMENT_OCID="ocid1.compartment.oc1..aaaaaaaayv5new54j45jvrfmppkxomwjnrxgebf4r7x73gj4vemclrmcz7bq"
DEFAULT_VCN_OCID=""
DEFAULT_VOLUME_OCID=""
DEFAULT_SUBNET_OCID=""
DEFAULT_IMAGE_OCID=""
DEFAULT_AV_DOAMIN=""
DEFAULT_ACTIVITY="STATUS"
DEFAULT_HOSTSTRING="ol7docker"
DEFAULT_MIN=0
DEFAULT_MAX=0
DEFAULT_DATA_DIRECTORY=""
# - End of Customization ----------------------------------------------------

# - Environment Variables ---------------------------------------------------
# define default values 
VERSION=v1.7.0
DOAPPEND="TRUE"                                 # enable log file append
VERBOSE="FALSE"                                 # enable verbose mode
VERBOSE="TRUE"                                  # enable verbose mode
DEBUG="FALSE"                                   # enable debug mode
SCRIPT_BIN=$(dirname ${BASH_SOURCE[0]})         # script bin directory
SCRIPT_NAME=$(basename ${BASH_SOURCE[0]})   # script name
SCRIPT_BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_BASE=$(dirname ${SCRIPT_BIN_DIR})
CURRENT_PWD=$(pwd)
DEFAULT_COMPARTMENT_NAME=$(basename ${SCRIPT_NAME} .sh| tr '[:lower:]' '[:upper:]' | cut -d_ -f2)
START_HEADER="START: Start of ${SCRIPT_NAME} (Version ${VERSION}) with $*"
ACTIVITIES=("STATUS START STOP CREATE TERMINATE")
DEFAULT_DATA_DIRECTORY="${SCRIPT_BASE}/lab/oci"
# - Functions ---------------------------------------------------------------
function command_exists () {
# Purpose....: check if a command exists. 
# ---------------------------------------------------------------------------
    command -v $1 >/dev/null 2>&1||CleanAndQuit 3 $1;
}

function Usage() {
# Purpose....: Display Usage
# ---------------------------------------------------------------------------
    VERBOSE="TRUE"
    DoMsg "INFO : Usage, ${SCRIPT_NAME} [-hv -c <COMPARTMENT> -a <ACTIVITY> -i <INSTANCES>] [-H <HOSTSTRING>]"
    DoMsg "INFO :   -h                  Usage (this message)"
    DoMsg "INFO :   -v                  enable verbose mode"
    DoMsg "INFO :   -d                  enable debug mode"
    DoMsg "INFO :   -f                  force flag used to terminate instance"
    DoMsg "INFO :   -a <ACTIVITY>       Activity status, start, stop, create or terminate (default ${DEFAULT_ACTIVITY})"
    DoMsg "INFO :   -D <DIRECTORY>      Data directory used to generate ssh keys (default ${DEFAULT_DATA_DIRECTORY})"
    DoMsg "INFO :   -c <COMPARTMENT>    OCI compartment (default ${DEFAULT_COMPARTMENT_NAME})"
    DoMsg "INFO :   -H <HOSTSTRING>     Hostname used to create the compute instance (default ${DEFAULT_HOSTSTRING})"
    DoMsg "INFO :   -n <MIN>            Minimal host number used to create the compute instance (default ${DEFAULT_MIN})"
    DoMsg "INFO :   -m <MAX>            Maximal host number used to create the compute instance (default ${DEFAULT_MAX})"
    DoMsg "INFO :   -i <INSTANCES>      List of instances (default ALL)"
    DoMsg "INFO : Logfile : ${LOGFILE}"
    if [ ${1} -gt 0 ]; then
        CleanAndQuit ${1} ${2}
    else
        VERBOSE="FALSE"
        CleanAndQuit 0
    fi
}

# -----------------------------------------------------------------------
# Purpose....: Display Message with time stamp
# -----------------------------------------------------------------------
function DoMsg()
{
    INPUT=${1}
    PREFIX=${INPUT%: *}                 # Take everything before :
    case ${PREFIX} in                  # Define a nice time stamp for ERR, END
        "END  ")        TIME_STAMP=$(date "+%Y-%m-%d_%H:%M:%S  ");;
        "ERR  ")        TIME_STAMP=$(date "+%n%Y-%m-%d_%H:%M:%S  ");;
        "START")        TIME_STAMP=$(date "+%Y-%m-%d_%H:%M:%S  ");;
        "OK   ")        TIME_STAMP="";;
        "INFO ")        TIME_STAMP=$(date "+%Y-%m-%d_%H:%M:%S  ");;
        "DEBUG")        if [ "${DEBUG^^}" == "TRUE" ]; then TIME_STAMP=$(date "+%Y-%m-%d_%H:%M:%S  "); else return; fi ;;
        *)              TIME_STAMP="";;
    esac
    if [ "${VERBOSE^^}" == "TRUE" ]; then
        if [ "${DOAPPEND^^}" == "TRUE" ]; then
            echo "${TIME_STAMP}${1}" |tee -a ${LOGFILE}
        else
            echo "${TIME_STAMP}${1}"
        fi
        shift
        while [ "${1}" != "" ]; do
            if [ "${DOAPPEND^^}" == "TRUE" ]; then
                echo "               ${1}" |tee -a ${LOGFILE}
            else
                echo "               ${1}"
            fi
            shift
        done
    else
        if [ "${DOAPPEND^^}" == "TRUE" ]; then
            echo "${TIME_STAMP}  ${1}" >> ${LOGFILE}
        fi
        shift
        while [ "${1}" != "" ]; do
            if [ "${DOAPPEND^^}" == "TRUE" ]; then
                echo "               ${1}" >> ${LOGFILE}
            fi
            shift
        done
    fi
}

function CleanAndQuit() {
# Purpose....: Clean up before exit
# ---------------------------------------------------------------------------
    STATUS="INFO"
    if [ ${1} -gt 0 ]; then
      VERBOSE="TRUE"
      STATUS="ERROR"
    fi

    case ${1} in
        0)  DoMsg "END  : of ${SCRIPT_NAME}";;
        1)  DoMsg "ERR  : Exit Code ${1}. Wrong amount of arguments. See usage for correct one.";;
        2)  DoMsg "ERR  : Exit Code ${1}. Wrong arguments (${2}). See usage for correct one.";;
        3)  DoMsg "ERR  : Exit Code ${1}. Command not found (${2}).";;
        11) DoMsg "ERR  : Exit Code ${1}. Could not touch file ${2}";;
        44) DoMsg "ERR  : Exit Code ${1}. Directory ${2} does not exist";;
        45) DoMsg "ERR  : Exit Code ${1}. Directory ${2} is not writeable";;
        52) DoMsg "ERR  : Exit Code ${1}. Error unknown activity ${2}";;
        55) DoMsg "ERR  : Exit Code ${1}. Missing list of instances. Use -i <INSTANCES> to specify instances or -n <MIN> / -m  <MAX> to generate list";;
        99) DoMsg "INFO : Just wanna say hallo.";;
        ?)  DoMsg "ERR  : Exit Code ${1}. Unknown Error.";;
    esac
    exit ${1}
}
# - EOF Functions -----------------------------------------------------------
# - Initialization ----------------------------------------------------------
LOG_BASE=${LOG_BASE:-$SCRIPT_BIN}               # Use script directory as default logbase
# check if we can write into log directory
if [ ! -w "${LOG_BASE}" ]; then
    CleanAndQuit 45 ${LOG_BASE} # Define a clean exit if directory is not writable
fi
# Define Logfile
LOGFILE="${LOG_BASE}/$(basename ${SCRIPT_NAME} .sh).log"
touch ${LOGFILE} 2>/dev/null
# check if we can write logfile
if [ $? -eq 0 ] && [ -w "${LOGFILE}" ]; then
    DOAPPEND="TRUE"
else
    CleanAndQuit 11 ${LOGFILE} # Define a clean exit if logfile is not writable
fi
# - EOF Initialization ------------------------------------------------------
 
# - Main --------------------------------------------------------------------
DoMsg "${START_HEADER}"

# check if we do have an oci in the path
command_exists oci
# check if we do have an ssh-keygen in the path
command_exists ssh-keygen
# check if we do have an puttygen in the path
command_exists puttygen

# usage and getopts
DoMsg "INFO : processing commandline parameter"
while getopts hvdfa:c:i:H:n:m:D:E: arg; do
    case $arg in
        h) Usage 0;;
        v) VERBOSE="TRUE";;
        d) DEBUG="TRUE";;
        f) FORCE="TRUE";;
        a) ACTIVITY="${OPTARG}";;
        H) HOSTSTRING="${OPTARG}";;
        D) DATA_DIRECTORY="${OPTARG}";;
        n) MIN="${OPTARG}";;
        m) MAX="${OPTARG}";;
        c) COMPARTMENT_NAME="${OPTARG}";;
        i) INSTANCES=$(echo "${OPTARG}"| tr "," "\n");;
        E) CleanAndQuit "${OPTARG}";;
        ?) Usage 2 $*;;
    esac
done

# Define default value and normalize activity
ACTIVITY=${ACTIVITY:-${DEFAULT_ACTIVITY}}
ACTIVITY=${ACTIVITY^^}
# define default value for host name / prefix
HOSTSTRING=${HOSTSTRING:-${DEFAULT_HOSTSTRING}}
# define default values for min/max
MIN=${MIN:-${DEFAULT_MIN}}
MAX=${MAX:-${DEFAULT_MAX}}
# set default values for compartment name and ocid
COMPARTMENT_NAME=${COMPARTMENT_NAME:-$DEFAULT_COMPARTMENT_NAME}
COMPARTMENT_OCID=${COMPARTMENT_OCID:-$DEFAULT_COMPARTMENT_OCID}
# set default value for data directory
DATA_DIRECTORY=${DATA_DIRECTORY:-${DEFAULT_DATA_DIRECTORY}}

# create list of instances if INSTANCES is empty and MIN/MAX is not equal
if [ -z "$INSTANCES" ] && [ $MIN -ne $MAX ]; then
    for i in 0{0..9} {10..99} ; do
        if [ $i -lt $MIN ]; then continue; fi
        DoMsg "DEBUG: Add hostname ${HOSTSTRING}${i} to list of instances"
        INSTANCES+=( "${HOSTSTRING}${i}" )
        if [ $i -ge $MAX ]; then break; fi
    done
else
    DoMsg "DEBUG: process all available compute instances"
fi

# print debug message about the instance....
DoMsg "DEBUG: List of instances ${INSTANCES[*]}"  

# check if the activity is in the list of activities
if [[ ! " ${ACTIVITIES[@]} " =~ " ${ACTIVITY} " ]]; then
    CleanAndQuit 52 ${ACTIVITY}
fi

# check if OCID for compartment is defined as COMPARTMENT_OCID.
if [ -z "${COMPARTMENT_OCID}" ]; then
    DoMsg "INFO : get ocid for compartment ${COMPARTMENT_NAME}"
    COMPARTMENT_OCID=$(oci iam compartment list \
        --compartment-id-in-subtree true --all \
        --raw-output --query "data [?name == '${COMPARTMENT_NAME}'].id|[0]")
    DoMsg "DEBUG: ocid ${COMPARTMENT_OCID} for ${COMPARTMENT_NAME}"
fi

# Check activity STATUS and run action
if [ ${ACTIVITY} == "STATUS" ]; then
    DoMsg "INFO : run activity ${ACTIVITY}"
    DoMsg "INFO : get status for all compute instance in compartment ${COMPARTMENT_NAME}"
    oci compute instance list --compartment-id $COMPARTMENT_OCID --output table \
        --query "data[].{\"Name\":\"display-name\",\"State\":\"lifecycle-state\"}"
fi

# Check activity START / STOP and run action
if [ ${ACTIVITY} == "START" ] || [ ${ACTIVITY} == "STOP" ]; then
    DoMsg "INFO : run activity ${ACTIVITY}"
    # define lifecycle-state based on activity
    case $ACTIVITY in
        START)  STATE="STOPPED";;
        STOP)   STATE="RUNNING";;
        ?)      STATE="STOPPED";;
    esac
    # get list of compute instances
    COMPUTE_INSTANCE_LIST=$(oci compute instance list \
        --compartment-id $COMPARTMENT_OCID  \
        --lifecycle-state ${STATE} --output table \
        --raw-output --query "data[].{Name:\"display-name\",id:id}"|grep -iv '+-'| grep -iv '| Name'|sed 's/ //g')
    # loop over compute instances
    for i in ${COMPUTE_INSTANCE_LIST}; do
        INSTANCE_NAME=$(echo $i |cut -d'|' -f2)
        INSTANCE_OCID=$(echo $i |cut -d'|' -f3)
        # check if the instance is in the list of activities
        if [[ ! " ${INSTANCES[@]} " =~ " ${INSTANCE_NAME} " ]] && [ ! -z "$INSTANCES" ]; then
            DoMsg "INFO : skip instance ${INSTANCE_NAME}"
            continue
        else
            DoMsg "INFO : ${ACTIVITY,,} compute instance ${INSTANCE_NAME}"
            # start/stop compute instance
            oci compute instance action --action ${ACTIVITY} --instance-id ${INSTANCE_OCID} >>${LOGFILE} 2>&1
        fi
    done
    # display compute instance status
    oci compute instance list --compartment-id $COMPARTMENT_OCID --output table \
        --query "data[].{\"Name\":\"display-name\",\"State\":\"lifecycle-state\"}"
fi

# Check activity CREATE and run action
if [ ${ACTIVITY} == "CREATE" ]; then
    DoMsg "INFO : run activity ${ACTIVITY}"

    # check if we do have a list of instance. 
    if [ -z "$INSTANCES" ]; then
        CleanAndQuit 55
    fi
    # check key data directory
    DoMsg "DEBUG: data directory ${DATA_DIRECTORY}"
    [ ! -d ${DATA_DIRECTORY} ] && CleanAndQuit 44 ${DATA_DIRECTORY}
    [ ! -w ${DATA_DIRECTORY} ] && CleanAndQuit 45 ${DATA_DIRECTORY}

    # Handle default values for differen ocid's
    VCN_OCID=${VCN_OCID:-$DEFAULT_VCN_OCID}
    SUBNET_OCID=${SUBNET_OCID:-$DEFAULT_SUBNET_OCID}
    IMAGE_OCID=${IMAGE_OCID:-$DEFAULT_IMAGE_OCID}
    AV_DOAMIN=${AV_DOAMIN:-$DEFAULT_AV_DOAMIN}
    VOLUME_OCID=${VOLUME_OCID:-$DEFAULT_VOLUME_OCID}

    # check if VCN_OCID for compartment is defined.
    if [ -z "${VCN_OCID}" ]; then
        DoMsg "INFO : get vcn ocid for compartment" 
        VCN_OCID=$(oci network vcn list --compartment-id $COMPARTMENT_OCID --raw-output \
            --query "data [?contains(\"display-name\",'o-db-docker')].id|[0]")
        DoMsg "DEBUG: vcn ocid ${VCN_OCID} for ${COMPARTMENT_NAME}"
    fi

    # check if SUBNET_OCID for compartment is defined.
    if [ -z "${SUBNET_OCID}" ]; then
        DoMsg "INFO : get subnet ocid for compartment" 
        SUBNET_OCID=$(oci network subnet list --compartment-id $COMPARTMENT_OCID \
            --vcn-id $VCN_OCID --sort-by DISPLAYNAME --raw-output --query "data [*].id|[0]")
        DoMsg "DEBUG: subnet ocid ${SUBNET_OCID} for ${COMPARTMENT_NAME}"
    fi

    # check if AV_DOAMIN for compartment is defined.
    if [ -z "${AV_DOAMIN}" ]; then
        DoMsg "INFO : get availability domain ocid for compartment" 
        AV_DOAMIN=$(oci network subnet list --compartment-id $COMPARTMENT_OCID \
            --vcn-id $VCN_OCID --sort-by DISPLAYNAME --raw-output \
            --query "data [*].\"availability-domain\"|[0]")
        DoMsg "DEBUG: av domain ocid ${AV_DOAMIN} for ${COMPARTMENT_NAME}"
    fi

    # check if IMAGE_OCID for compartment is defined.
    if [ -z "${IMAGE_OCID}" ]; then
        DoMsg "INFO : get image ocid for O-DB-DOCKER_master_v01" 
        IMAGE_OCID=$(oci compute image list --compartment-id $COMPARTMENT_OCID \
            --display-name "O-DB-DOCKER_master_v01" \
            --raw-output --query "data [*].id|[0]")
        DoMsg "DEBUG: image ocid ${SUBNET_OCID} for ${COMPARTMENT_NAME}"
    fi

    # check if VOLUME_OCID for compartment is defined.
    if [ -z "${VOLUME_OCID}" ]; then
        DoMsg "INFO : get volume ocid for O-DB-DOCKER_master_v01" 
        VOLUME_OCID=$(oci bv volume list --compartment-id $COMPARTMENT_OCID \
            --raw-output --query "data [?contains(\"display-name\",'o-db-docker_bv00_master_v01')].id|[0]")
        DoMsg "DEBUG: image ocid ${SUBNET_OCID} for ${COMPARTMENT_NAME}"
    fi


    for instance in ${INSTANCES[@]}; do
        DoMsg "INFO : Start to process instance ${instance}"
        # generate ssh key
        DoMsg "INFO : ${instance} generate public/private rsa key pair"
        yes y |ssh-keygen -b 4096 -C "O-DB-DOCKER Training ${instance}" -f "${DATA_DIRECTORY}/id_rsa_${instance}" -N '' >>${LOGFILE} 2>&1
        # generate putty key file
        DoMsg "INFO : ${instance} generate putty private key file"
        puttygen ${DATA_DIRECTORY}/id_rsa_${instance} -o ${DATA_DIRECTORY}/id_rsa_${instance}.ppk >>${LOGFILE} 2>&1
        DoMsg "INFO : ${instance} create the compute instance"
        oci compute instance launch --compartment-id $COMPARTMENT_OCID \
                --availability-domain $AV_DOAMIN --subnet-id $SUBNET_OCID \
                --display-name ${instance} \
                --image-id $IMAGE_OCID \
                --shape VM.Standard2.2 --assign-public-ip true \
                --ssh-authorized-keys-file ${DATA_DIRECTORY}/id_rsa_${instance}.pub >>${LOGFILE} 2>&1
        # display compute instance status
        oci compute instance list --compartment-id $COMPARTMENT_OCID --output table \
            --query "data[].{\"Name\":\"display-name\",\"State\":\"lifecycle-state\"}"
        # get the instance ocid
        INSTANCE_OCID=$(oci compute instance list --compartment-id $COMPARTMENT_OCID  \
            --raw-output --query "data [?contains(\"display-name\",'$instance')].id|[0]")
        DoMsg "INFO : ${instance} clone block volume"

        oci bv volume create --availability-domain ${AV_DOAMIN} \
            --compartment-id ${COMPARTMENT_OCID} \
            --display-name "${instance}_bv00" --source-volume-id ${VOLUME_OCID}

        INST_VOLUME_OCID=$(oci bv volume list --compartment-id $COMPARTMENT_OCID \
            --raw-output --query "data [?contains(\"display-name\",'${instance}_bv00')].id|[0]")
        DoMsg "INFO : ${instance} assign block volume"
        # oci compute volume-attachment attach --instance-id $INSTANCE_OCID \
        #     --type iscsi --volume-id $INST_VOLUME_OCID --device "/dev/oracleoci/oraclevdb"
        DoMsg "INFO : ${instance} dd"
    done
fi

# Check activity TERMINATE and run action
if [ ${ACTIVITY} == "TERMINATE" ]; then
    DoMsg "INFO : run activity ${ACTIVITY}"
    # display the instance which will be deleted.
    # Which is either all or the ones defined with -i
    if [ -z "$INSTANCES" ]; then
        DoMsg "INFO : Instance(s) to terminate : ALL instances in compartment ${COMPARTMENT_NAME}"
    else
        DoMsg "INFO : Instance(s) to terminate : ${INSTANCES[*]}"
    fi
    # get list of compute instances
    COMPUTE_INSTANCE_LIST=$(oci compute instance list \
        --compartment-id $COMPARTMENT_OCID --output table \
        --raw-output --query "data[].{Name:\"display-name\",id:id}"|grep -iv '+-'| grep -iv '| Name'|sed 's/ //g')
    # loop over compute instances
    for i in ${COMPUTE_INSTANCE_LIST}; do
        INSTANCE_NAME=$(echo $i |cut -d'|' -f2)
        INSTANCE_OCID=$(echo $i |cut -d'|' -f3)
        # check if the instance is in the list of activities
        if [[ ! " ${INSTANCES[@]} " =~ " ${INSTANCE_NAME} " ]] && [ ! -z "$INSTANCES" ]; then
            DoMsg "INFO : skip instance ${INSTANCE_NAME}"
            continue
        else
            DoMsg "INFO : terminate compute instance ${INSTANCE_NAME}"
            # get ocid for block volume
            INST_VOLUME_OCID=$(oci compute volume-attachment list --compartment-id $COMPARTMENT_OCID \
                --instance-id ${INSTANCE_OCID} --raw-output --query "data [].\"volume-id\"|[0]")
            # Attachment OCID
            VOLUME_ATTACH_OCID=$(oci compute volume-attachment list --compartment-id $COMPARTMENT_OCID \
                --instance-id ${INSTANCE_OCID} --raw-output --query "data [].id|[0]")
            oci compute volume-attachment detach --volume-attachment-id ${VOLUME_ATTACH_OCID} --force
            # check if force is not true
            if [ "${FORCE^^}" == "TRUE" ]; then
                # force terminate compute instance
                oci compute instance terminate --instance-id ${INSTANCE_OCID} --force >>${LOGFILE} 2>&1
            else    
                # terminate compute instance and let oci ask
                oci compute instance terminate --instance-id ${INSTANCE_OCID}
            fi

            if [ ! -z ${INST_VOLUME_OCID} ]; then
                if [ "${FORCE^^}" == "TRUE" ]; then
                    # force bv volume delete 
                    oci bv volume delete --volume-id ${INST_VOLUME_OCID} --force >>${LOGFILE} 2>&1
                else    
                    # bv volume delete and let oci ask
                    oci bv volume delete --volume-id ${INST_VOLUME_OCID} 
                fi
            fi
        fi
    done
fi


CleanAndQuit 0

# oci compute instance list --compartment-id $COMPARTMENT_OCID \
# --output table \
# --query "data [?contains(\"display-name\",'${HOST_NAME}')].{\"display-name\":\"display-name\",\"lifecycle-state\":\"lifecycle-state\"}"


# INSTANCE_OCID=$(oci compute instance list \
# --compartment-id $COMPARTMENT_OCID  \
# --lifecycle-state 'RUNNING' \
# --raw-output --query "data [?contains(\"display-name\",'${HOST_NAME}')].id|[0]")

# oci compute instance action \
# --action SOFTSTOP \
# --instance-id ${INSTANCE_OCID}


# - EOF Main ----------------------------------------------------------------
# --- EOF -------------------------------------------------------------------