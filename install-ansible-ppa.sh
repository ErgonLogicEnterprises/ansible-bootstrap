#/bin/sh
#curl https://raw.githubusercontent.com/ErgonLogicEnterprises/ansible-bootstrap/master/install-ansible-ppa.sh | /bin/sh
sudo apt-get install git python-setuptools python-dev python-pip python-crypto -yq
sudo apt-get install software-properties-common -yq
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install ansible -y
