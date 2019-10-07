#!/bin/bash

#This script will be run on akraino Regional Controller for deploy TF demo

WORKDIR=$(dirname $0)

INPUT=${WORKDIR}/INPUT.yaml
SSH_KEY=${WORKDIR}/ssh_key.pem 

yaml() {
    python3 -c "import yaml;print(yaml.load(open('$1'))$2)"
}

SSH_USER=$(yaml ${INPUT} "['ssh_user']")
NODE=$(yaml ${INPUT} "['node']")
REPO_URL=$(yaml ${INPUT} "['repo_url']")
REPO_BRANCH=$(yaml ${INPUT} "['repo_branch']")

#Creating deploy script for running on the remote node
cat <<EOF >start.sh
#!/bin/bash

git clone ${REPO_URL} --branch ${REPO_BRANCH}
cd treasuremap/tools/deployment/aiab/
sudo ./airship-in-a-bottle.sh -y | tee /tmp/airship-in-a-bottle.sh.output.log
touch /tmp/DEPLOYMENT_COMPLETED
EOF


chmod 600 ${SSH_KEY}

ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no -t ${SSH_USER}@${NODE} '/bin/bash -s' < start.sh

exit 0

