# ----------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ----------------------------------------------------------------------
# Name.......: ic19.Dockerfile
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Date.......: 2019.11.20
# Purpose....: Simple Dockerfile
# Notes......: Using one RUN command
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
    JAVA_PKG="p29657335_170231_Linux-x86-64.zip" \
    JAVA_BASE=/usr/java \
    JAVA_HOME=/usr/java/default

# COPY base database software if part of the build context either p29657335_170231_Linux-x86-64.zip 
# or p29657335_170231_Linux-x86-64.zip.download
COPY  "${JAVA_PKG}*" "${DOWNLOAD}/"

# Install a few base tools and clean up
RUN     yum install -y libaio gzip tar zip unzip && \
        yum clean all && \
        rm -rf /var/cache/yum

# check if java package is copied if not download it from orarepo
RUN     if [ ! -s "${DOWNLOAD}/${JAVA_PKG}" ]; then \
            echo "download ${DOWNLOAD}/${JAVA_PKG} from orarepo"; \
            curl -f http://${ORAREPO}/${JAVA_PKG} -o ${DOWNLOAD}/${JAVA_PKG}; \
        else \
            echo "use local copy of ${DOWNLOAD}/${JAVA_PKG}"; \
        fi && \
        mkdir -p /usr/java && \
        unzip -p ${DOWNLOAD}/${JAVA_PKG} *tar* | tar zxv -C ${JAVA_BASE} && \
        rm -rf ${DOWNLOAD}

# Install Java respectively update alternatives for Java
# ----------------------------------------------------------------------
RUN export JAVA_DIR=$(ls -1 -d ${JAVA_BASE}/*) && \
    echo "JAVA_DIR=$JAVA_DIR" && \
    ln -s $JAVA_DIR ${JAVA_BASE}/latest && \
    ln -s $JAVA_DIR ${JAVA_BASE}/default && \
    alternatives --install /usr/bin/java java $JAVA_DIR/bin/java 20000 && \
    alternatives --install /usr/bin/javac javac $JAVA_DIR/bin/javac 20000 && \
    alternatives --install /usr/bin/jar jar $JAVA_DIR/bin/jar 20000
# --- EOF --------------------------------------------------------------