# ----------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ----------------------------------------------------------------------
# Name.......: ic19_separate.Dockerfile
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2019.11.07
# Purpose....: Dockerfile Oracle Instant Client Image
# Notes......: Using one RUN command per statement
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as
#              shown at http://oss.oracle.com/licenses/upl.
# ----------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ----------------------------------------------------------------------

# base image
# ----------------------------------------------------------------------
FROM oraclelinux:7-slim
# Arguments for Oracle Installation
ARG release=19
ARG update=3

# Install the software via YUM
RUN  yum -y install oracle-release-el7
RUN  yum-config-manager --enable ol7_oracle_instantclient
RUN  yum -y install oracle-instantclient${release}.${update}-basic oracle-instantclient${release}.${update}-devel oracle-instantclient${release}.${update}-sqlplus 
RUN  rm -rf /var/cache/yum

# Define sqlplus as default command 
CMD ["sqlplus", "-v"]
# --- EOF --------------------------------------------------------------