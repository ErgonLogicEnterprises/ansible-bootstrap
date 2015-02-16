#!/bin/sh

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, this script must be run as root."
  exit 1
fi

while getopts ":c:" opt; do
  case $opt in
    c)
      checkout=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

which ansible >/dev/null 2>&1
if [ $? -eq 1 ]; then

  echo "Installing Ansible build dependencies."
  apt-get -qq --force-yes update > /dev/null 2>&1
  apt-get -qq --force-yes install git python-setuptools >/dev/null 2>&1

  ansible_dir=/usr/local/lib/ansible/
  if [ ! -d $ansible_dir ]; then
    echo "Cloning Ansible."
    git clone --quiet --recursive --depth=1 git://github.com/ansible/ansible.git $ansible_dir >/dev/null 2>&1
  fi

  if [ -z $checkout ] && [ ! -z $ANSIBLE_CHECKOUT ]; then
    echo "Setting checkout target from environment."
    checkout=$ANSIBLE_CHECKOUT
  fi

  if [ $checkout ]; then
    echo "Checking out '$checkout'."
    cd $ansible_dir
    git checkout $checkout --quiet
  fi

  echo "Running setups tasks for Ansible."
  cd $ansible_dir
  python ./setup.py install >/dev/null 2>&1

fi
