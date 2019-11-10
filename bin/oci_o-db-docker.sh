#!/bin/bash
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
# - Customization -----------------------------------------------------------

# - End of Customization ----------------------------------------------------

# - Environment Variables ---------------------------------------------------
# define default values 
VERSION=v1.7.0
DOAPPEND="TRUE"                                 # enable log file append
VERBOSE="FALSE"                                 # enable verbose mode
DEBUG="FALSE"                                   # enable debug mode
SCRIPT_BIN=$(dirname ${BASH_SOURCE[0]})         # script bin directory
SCRIPT_NAME=$(basename ${BASH_SOURCE[0]})   # script name
SCRIPT_BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_BASE=$(dirname ${SCRIPT_BIN_DIR})
CURRENT_PWD=$(pwd)
DEFAULT_COMPARTMENT_NAME=$(basename ${SCRIPT_NAME} .sh| tr '[:lower:]' '[:upper:]' | cut -d_ -f2)
START_HEADER="START: Start of ${SCRIPT_NAME} (Version ${VERSION}) with $*"

# - Functions ---------------------------------------------------------------
function command_exists () {
# Purpose....: check if a command exists. 
# ---------------------------------------------------------------------------
    command -v $1 >/dev/null 2>&1;
}

function Usage() {
# Purpose....: Display Usage
# ---------------------------------------------------------------------------
    VERBOSE="TRUE"
    DoMsg "INFO : Usage, ${SCRIPT_NAME} [-hv -c <COMPARTMENT> -a <ACTIVITY> -i <INSTANCES>]"
    DoMsg "INFO :   -h                  Usage (this message"
    DoMsg "INFO :   -v                  enable verbose mode"
    DoMsg "INFO :   -d                  enable debug mode"
    DoMsg "INFO :   -a <ACTIVITY>       Activity status, start or stop (default status)"
    DoMsg "INFO :   -c <COMPARTMENT>    OCI compartment (default ${DEFAULT_COMPARTMENT_NAME})"
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
        45) DoMsg "ERR  : Exit Code ${1}. Directory ${2} is not writeable";;
        52) DoMsg "ERR  : Exit Code ${1}. Error unknown activity ${2}";;
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

# usage and getopts
DoMsg "INFO : processing commandline parameter"
while getopts hvdfa:c:i:E: arg; do
    case $arg in
        h) Usage 0;;
        v) VERBOSE="TRUE";;
        d) DEBUG="TRUE";;
        f) FORCE="TRUE";;
        a) ACTIVITY="${OPTARG}";;
        c) COMPARTMENT_NAME="${OPTARG}";;
        i) INSTANCES=$(echo "${OPTARG}"|sed s/\,/\ /g);;
        E) CleanAndQuit "${OPTARG}";;
        ?) Usage 2 $*;;
    esac
done

# Normalize activity
ACTIVITY=${ACTIVITY:-"STATUS"}
ACTIVITY=$(echo $ACTIVITY|sed "s/^start$/START/gi")
ACTIVITY=$(echo $ACTIVITY|sed "s/^stop$/STOP/gi")
ACTIVITY=$(echo $ACTIVITY|sed "s/^status$/STATUS/gi")

# set default compartment name
COMPARTMENT_NAME=${COMPARTMENT_NAME:-$DEFAULT_COMPARTMENT_NAME}
# check if we do have an oci in the path
if ! command_exists oci; then
    DoMsg "ERROR: oci isn't installed/available on this system..."
    exit 3 "oci";
fi

# check if OCID for compartment is defined as COMPARTMENT_OCID.
if [ -z "${COMPARTMENT_OCID}" ]; then
    DoMsg "INFO : get ocid for compartment ${COMPARTMENT_NAME}"
    COMPARTMENT_OCID=$(oci iam compartment list \
        --compartment-id-in-subtree true --all \
        --raw-output --query "data [?name == '${COMPARTMENT_NAME}'].id|[0]")
fi

 DoMsg "INFO : "
# For activity STATUS we silently ignore the instances
if [ "$ACTIVITY" == "STATUS" ]; then
    DoMsg "INFO : get status for all compute instance in compartment ${COMPARTMENT_NAME}"
    oci compute instance list --compartment-id $COMPARTMENT_OCID \
        --output table \
        --query "data[].{\"Name\":\"display-name\",\"State\":\"lifecycle-state\"}"
fi


# if [ "$INSTANCES" = "" ]; then
#     # Load list of OUD Instances from oudtab
#     DoMsg "INFO : Load list of OUD instances"
#     if [ -f "${ETC_BASE}/oudtab" ]; then
#         # create a OUD Instance Liste based on oudtab
#         export OUDTAB=${ETC_BASE}/oudtab
#         if [ "$MyActivity" == "START" ]; then
#             export OUD_INST_LIST=$(grep -v '^#' ${OUDTAB}|grep -iEv ':(N|D)$'|cut -f1 -d:)
#         else
#             export OUD_INST_LIST=$(grep -v '^#' ${OUDTAB}|cut -f1 -d:)
#         fi
#     else
#         DoMsg "WARN : Could not load OUD list from \${ETC_BASE}/oudtab"
#         DoMsg "WARN : Fallback to \${OUD_DATA}/*/OUD"
#         unset OUD_INST_LIST
#         for i in ${ORACLE_INSTANCE_BASE}/*/OUD; do
#             # create a OUD Instance Liste based on OUD Instance Base
#             OUD_INST_LIST="$(echo $i|sed 's/^.*\/\(.*\)\/OUD.*$/\1/')"
#         done
#     fi
# else
#     DoMsg "INFO : Use instance list from commandline"
#     # use list of OUD Instances from command line
#     OUD_INST_LIST=$(echo "${MyOUD_INSTANCES}" |tr ',' ' ')
# fi



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