# ----------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ----------------------------------------------------------------------
# Name.......: regular.Dockerfile
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
    ORACLE_DOCKER_INSTALL=true \
    ORA_DB_PKG="LINUX.X64_193000_db_home.zip" \
    ORACLE_ROOT="/u00" \
    ORACLE_BASE="/u00/app/oracle" \
    ORACLE_HOME="/u00/app/oracle/product/19.0.0.0" \
    INVENTORY_LOCATION="/u00/app/oraInventory"

# COPY base database software if part of the build context either oracle-database-ee-19c-1.0-1.x86_64.rpm 
# or oracle-database-ee-19c-1.0-1.x86_64.rpm.download
COPY    "${ORA_DB_PKG}*" "${DOWNLOAD}/"

# copy the installer response file
COPY    db_install.rsp "${DOWNLOAD}/"

# Install a few base tools, ora preinstall and do a clean up
RUN     yum install -y zip unzip gzip tar which make passwd \
            oracle-database-preinstall-19c \ 
            elfutils-libelf-devel && \
        yum clean all && \
        rm -rf /var/cache/yum && \
        mkdir /u00 && \
        chown oracle:oinstall /u00

# change to user Oracle
USER oracle

# check if oracle database package is copied if not download it from orarepo
RUN     if [ ! -s "${DOWNLOAD}/${ORA_DB_PKG}" ]; then \
            echo "download ${DOWNLOAD}/${ORA_DB_PKG} from orarepo"; \
            curl -f http://${ORAREPO}/${ORA_DB_PKG} -o ${DOWNLOAD}/${ORA_DB_PKG}; \
        else \
            echo "use local copy of ${DOWNLOAD}/${ORA_DB_PKG}"; \
        fi && \
        mkdir -p ${ORACLE_BASE} ${ORACLE_HOME} && \
        unzip -q -o ${DOWNLOAD}/${ORA_DB_PKG} -d ${ORACLE_HOME} && \
        ${ORACLE_HOME}/runInstaller -silent -force -waitforcompletion -responsefile ${DOWNLOAD}/db_install.rsp && \
        rm -rf ${DOWNLOAD}

# change to user root
USER root

# run the root script
RUN /opt/oracle/oraInventory/orainstRoot.sh && \
    /opt/oracle/product/19c/dbhome_1/root.sh

# change to user Oracle
USER oracle
# --- EOF --------------------------------------------------------------