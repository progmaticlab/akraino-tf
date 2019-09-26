#Regional Controler (ip address or FQDN)
export RC_HOST=172.31.43.214
#Regional Controler credentials
export RC_USER=admin
export RC_PW=admin123


#Node for airship remote deployment (ip address or FQDN)
export NODE=15.188.56.151

#ssh user for aisrship remote deployment
export SSH_USER=ubuntu
#File with private ssh key (public key must be added into the node for auth)
export SSH_KEY=ssh_key.pem

#web server for downloading scripts and ssh key
#simpliest way is running "python3 -m http.server" in current directory
export BASE_URL=http://172.31.43.214:8000

#repo URL and branch for airship with tungstenfabric
export REPO_URL=https://github.com/OlegBravo/treasuremap
export REPO_BRANCH=tf-on-1.3

