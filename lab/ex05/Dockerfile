# ----------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ----------------------------------------------------------------------
# Name.......: Dockerfile
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Date.......: 2019.11.20
# Purpose....: Dockerfile to install Oracle Database
# Notes......: 
# License....: Licensed under the Universal Permissive License v 1.0 as
#              shown at http://oss.oracle.com/licenses/upl.
# ----------------------------------------------------------------------

# base image
# ----------------------------------------------------------------------
FROM oraclelinux:7-slim 

# Maintainer
# ----------------------------------------------------------------------
LABEL maintainer="stefan.oehrli@trivadis.com"

# Arguments for orarepo software repository host
ARG ORAREPO=orarepo

# Software stage area, repository, binary packages and patchs
ENV DOWNLOAD="/tmp/download" \
    SOFTWARE_REPO="http://$ORAREPO" \
    ORA_DB_PKG="oracle-database-ee-19c-1.0-1.x86_64.rpm"

# COPY base database software if part of the build context either oracle-database-ee-19c-1.0-1.x86_64.rpm 
# or oracle-database-ee-19c-1.0-1.x86_64.rpm.download
COPY  "${ORA_DB_PKG}*" "${DOWNLOAD}/"

# Install a few base tools and clean up
RUN     yum install -y zip unzip gzip tar which make passwd \
            oracle-database-preinstall-19c \
            elfutils-libelf-devel && \
        yum clean all && \
        rm -rf /var/cache/yum

# check if oracle database package is copied if not download it from orarepo
RUN     if [ ! -s "${DOWNLOAD}/${ORA_DB_PKG}" ]; then \
            echo "download ${DOWNLOAD}/${ORA_DB_PKG} from orarepo"; \
            curl -f http://${ORAREPO}/${ORA_DB_PKG} -o ${DOWNLOAD}/${ORA_DB_PKG}; \
        else \
            echo "use local copy of ${DOWNLOAD}/${ORA_DB_PKG}"; \
        fi && \
        cd ${DOWNLOAD} && \
        yum -y localinstall ${ORA_DB_PKG} && \
        yum clean all && \
        rm -rf /var/cache/yum && \
        rm -rf ${DOWNLOAD}
# --- EOF --------------------------------------------------------------