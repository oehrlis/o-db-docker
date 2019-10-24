#!/bin/bash
# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: gen_doc_docker.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2019.05.13
# Revision...: 
# Purpose....: Script to generate CPU-Reports as pdf, docx and html using a Docker 
#              container (trivadis/pandoc) 
# Notes......: - The script stops if the Docker command docker can not be found.
#              - Local registry is checked for the image trivadis/pandoc.
#              - If the Docker image trivadis/pandoc is missing it will be pulled.
#              - If docker pull fails a new trivadis/pandoc image will be build.
#              - Old CPU-Reports will be removed prior generating the new ones.
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
export PANDOC_IMAGE="trivadis/pandoc" # Default Pandoc image name
export SCRIPT_BIN=$(dirname ${BASH_SOURCE[0]})
export SCRIPT_BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export SCRIPT_BASE=$(dirname ${SCRIPT_BIN_DIR})
export SCRIPT_DOC="${SCRIPT_BASE}/doc"
export PANDOC_METAFILE="doc/metadata.yml"
export PANDOC_TEX="./templates/trivadis.tex"
export PANDOC_DOCX="./templates/trivadis.docx"
export BUILD_CONTEXT="${SCRIPT_BASE}/docker"
export CURRENT_PWD=$(pwd)

# get the month name for the CPU Report
case $(date +%m) in
    "01")   MONTH="January";;
    "02")   MONTH="January";;
    "03")   MONTH="January";;
    "04")   MONTH="April";;
    "05")   MONTH="April";;
    "06")   MONTH="April";;
    "07")   MONTH="July";;
    "08")   MONTH="July";;
    "09")   MONTH="July";;
    "10")   MONTH="October";;
    "11")   MONTH="October";;
    "12")   MONTH="October";;
esac
export DOC_NAME="CPU-Report_${MONTH}_$(date +%Y)"
# - EOF Environment Variables -----------------------------------------------

# - Functions ---------------------------------------------------------------
function command_exists () {
# Purpose....: check if a command exists. 
# -----------------------------------------------------------------------
    command -v $1 >/dev/null 2>&1;
}

generate_docx() {
# Purpose....: generate docx. 
# -----------------------------------------------------------------------
    LAN=$(printf '%s\n' "$1" | tr '[:lower:]' '[:upper:]')
    echo -n "docx..."
    docker run --rm -v "$PWD":/workdir:z ${PANDOC_IMAGE} \
        --reference-doc ${PANDOC_DOCX} \
        --metadata-file=${PANDOC_METAFILE} \
        -t docx \
        -o doc/${DOC_NAME}_${LAN}.docx \
        ./doc/${1}/*.md
}

generate_pdf() {
# Purpose....: generate pdf. 
# -----------------------------------------------------------------------
    LAN=$(printf '%s\n' "$1" | tr '[:lower:]' '[:upper:]')
    echo -n "pdf..."
    docker run --rm -v "$PWD":/workdir:z ${PANDOC_IMAGE} \
        --template ${PANDOC_TEX} \
        --pdf-engine=xelatex \
        --metadata-file=${PANDOC_METAFILE} \
        -o doc/${DOC_NAME}_${LAN}.pdf \
        ./doc/${1}/*.md
}

generate_html() {
# Purpose....: generate pdf. 
# -----------------------------------------------------------------------
    LAN=$(printf '%s\n' "$1" | tr '[:lower:]' '[:upper:]')
    echo -n "html..."
    docker run --rm -v "$PWD":/workdir:z ${PANDOC_IMAGE} \
        -s -f gfm -t html5 \
        --metadata-file=${PANDOC_METAFILE} \
        -o doc/${DOC_NAME}_${LAN}.html \
        ./doc/${1}/*.md
}

function generate() {
# Purpose....: generate doc. 
# -----------------------------------------------------------------------
    echo -n "INFO : Generating documents ($1)..."
    cd ${SCRIPT_BASE}
    if [ -d "${SCRIPT_BASE}/doc/$1" ];
    then
        generate_docx $1
        generate_pdf $1
        generate_html $1
        echo "done."
    else
        echo "WARN : No markdown files found in directory $1"
    fi
}
# - EOF Functions -----------------------------------------------------------

# check if we do have a docker
if ! command_exists docker; then
    echo "ERR  : Docker isn't installed/available on this system..."
    exit 1;
fi

# check if we have the local pandoc image
if [[ "$(docker images -q ${PANDOC_IMAGE} 2> /dev/null)" == "" ]]; then
    echo "WARN : image ${PANDOC_IMAGE} is not available locally!"
    echo "INFO : try to pull the image ${PANDOC_IMAGE}"
    docker pull ${PANDOC_IMAGE} >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "WARN : could not pull image ${PANDOC_IMAGE}"
        echo "INFO : start to build the image ${PANDOC_IMAGE}"
        echo docker build -t ${PANDOC_IMAGE} ${BUILD_CONTEXT}
        docker build -t ${PANDOC_IMAGE} ${BUILD_CONTEXT}
        if [ $? -ne 0 ]; then
            echo "ERR  : Can not build docker image ${PANDOC_IMAGE}"
            exit 1
        fi
    fi
fi

# build PDF doc's
echo "INFO : Remove old reports (pdf,html,docx)"
rm -f ${SCRIPT_DOC}/CPU-Report_*.pdf
rm -f ${SCRIPT_DOC}/CPU-Report_*.html
rm -f ${SCRIPT_DOC}/CPU-Report_*.docx
echo "INFO : Will use local image ${PANDOC_IMAGE}"
cd ${SCRIPT_DOC}
for i in de en; do
    generate $(basename $i)
done
# --- EOF --------------------------------------------------------------------