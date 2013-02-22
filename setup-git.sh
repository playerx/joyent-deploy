#!/bin/bash
# export PS4='+(line ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -o errexit      # crash on errors
set -o pipefail     # crash on errors in pipelines
# set -x

service_name="$1"
root_dir="$2"
service_repo="$root_dir/$service_name/repo"
config_dir="$root_dir/config"



echo "setup repo in $service_repo"
# PATH=/opt/local/bin:/opt/local/sbin:$PATH
# export PATH
# pkgin update
# echo y | pkgin install scmgit
cd $service_repo
echo $(pwd)
git init --bare
cd $service_repo/hooks
if [ -f "post-receive" ]; then
  mv post-receive post-receive.bak
fi
gsed -e "s#@@SERVICE_NAME@@#$service_name#g" \
	 -e "s#@@ROOT_DIR@@#$root_dir#g" \
         $config_dir/post-receive > ./post-receive

chmod +x ./post-receive