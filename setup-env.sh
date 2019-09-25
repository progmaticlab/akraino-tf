#Regional Controler (ip address or FQDN)
export RC_HOST=172.31.43.214

#Node for deployment (ip address or FQDN)
export NODE=15.188.56.151

#ssh user for logging into the node
export SSH_USER=ubuntu
#File with private ssh key (public key must be added into the node for auth)
export SSH_KEY=ssh_key.pem

#web server for downloading scripts and ssh key
#you can run "python3 -m http.server" in current directory 
export BASE_URL=http://172.31.43.214:8000

#repo URL and branch for airship with tungstenfabric
export REPO_URL=https://github.com/OlegBravo/treasuremap
export REPO_BRANCH=tf-on-1.3

