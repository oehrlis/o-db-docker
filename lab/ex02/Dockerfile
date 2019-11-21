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
FROM alpine

# Maintainer
# ----------------------------------------------------------------------
LABEL maintainer="stefan.oehrli@trivadis.com"

# Arguments for Oracle Installation
ARG   DOAG_USER

ENV DOAG_USER=${DOAG_USER:-"Docker Experte"}

# COPY base database software if part of the build context
COPY  beispiel.txt "/beispiel.txt"

# Define sqlplus as default command 
CMD ["echo -e \"Hallo ${DOAG_USER} anbei Deine Datei \n$(cat beispiel.txt)\""]
# --- EOF --------------------------------------------------------------