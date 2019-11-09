#!/bin/bash
# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: 11_clone_git_repos.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2018.09.27
# Revision...: 
# Purpose....: Script to clone git Repositories.
# Notes......: ...
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as 
#              shown at http://oss.oracle.com/licenses/upl.
# ---------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ---------------------------------------------------------------------------
# - Customization -----------------------------------------------------------
# - just add/update any kind of customized environment variable here
# - End of Customization ----------------------------------------------------
# - Environment Variables ---------------------------------------------------
# source values from vagrant YAML file
. /vagrant/scripts/00_init_environment.sh
export DEFAULT_DOMAIN=${domain_name:-"trivadislabs.com"} 
# - EOF Environment Variables -----------------------------------------------

# - Main --------------------------------------------------------------------
echo "= Start part 11 ======================================================="
# echo "--- Get git stuff -----------------------------------------------------"
echo "- Clone oehrlis/o-db-docker -------------------------------------------"
su -l oracle -c "cd ${ORACLE_BASE}/local;git clone https://github.com/oehrlis/o-db-docker.git o-db-docker"
echo "- Clone oehrlis/docker ------------------------------------------------"
su -l oracle -c "cd ${ORACLE_BASE}/local;git clone https://github.com/oehrlis/docker.git docker"
echo "- Clone oracle/docker-images ------------------------------------------"
su -l oracle -c "cd ${ORACLE_BASE}/local;git clone https://github.com/oracle/docker-images.git docker-images"
echo "- add alias to OUD Base -----------------------------------------------"
su -l oracle -c "echo \"alias gito='cd $cdl/o-db-docker;git pull; cd -'\" >>${ORACLE_BASE}/local/oudbase/etc/oudenv_custom.conf"
su -l oracle -c "echo \"alias gitd='cd $cdl/docker;git pull; cd -'\" >>${ORACLE_BASE}/local/oudbase/etc/oudenv_custom.conf"
echo "= Finish part 11 ======================================================"
# --- EOF --------------------------------------------------------------------