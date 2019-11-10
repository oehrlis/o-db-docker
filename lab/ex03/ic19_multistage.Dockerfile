# ----------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ----------------------------------------------------------------------
# Name.......: ic19_multistage.Dockerfile
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2019.11.07
# Purpose....: Dockerfile Oracle Instant Client Image
# Notes......: Using multistage build statement
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as
#              shown at http://oss.oracle.com/licenses/upl.
# ----------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ----------------------------------------------------------------------

# base image
# ----------------------------------------------------------------------
FROM oraclelinux:7-slim AS base
# Arguments for Oracle Installation
ARG release=19
ARG update=3

# install libaio in the base image
RUN yum -y install libaio && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV RELEASE=${release} \
    UPDATE=${update}
# New stage for installing the database binaries
FROM  base AS builder
# Install the software via YUM
RUN  yum -y install oracle-release-el7
RUN  yum-config-manager --enable ol7_oracle_instantclient
RUN  yum -y install oracle-instantclient${RELEASE}.${UPDATE}-basic oracle-instantclient${RELEASE}.${UPDATE}-devel oracle-instantclient${RELEASE}.${UPDATE}-sqlplus 

# New layer for database runtime
FROM  base
# copy binaries
COPY  --from=builder /usr/lib/oracle /usr/lib/oracle

# add softlinks for sqlplus and update ldconfig
RUN ln -s /usr/lib/oracle/19.3/client64/bin/sqlplus /usr/bin/sqlplus && \
    ln -s /usr/lib/oracle/19.3/client64/bin/sqlplus /usr/bin/sqlplus64 && \
    echo /usr/lib/oracle/19.3/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

# Define sqlplus as default command 
CMD ["sqlplus", "-v"]
# --- EOF --------------------------------------------------------------