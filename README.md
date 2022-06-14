# Easy OCI Bastion access from commandline
Scripts to easily connect to OCI private servers or private OKE clusters (Kubernetes) using Bastion Service.

These scripts allows to create bastion session from the command line.

## Prerequisites
- Setup OCI cli.
- Install jq - To parse JSON.

In ubunutu, sudo apt install -y jq

In CentOS, yum install jq -y

Fill these 3 variables in create_bastion.sh

`BASTION=<OCID_OF_BASTION_FROM_OCI>`

This is the absolute path to your PUBLIC KEY
`PUBKEY=<LOCAL_PUB_KEY_LOCATION>`

You can find this IP from OKE cluster kube config file. Open kube config file and look for the line with server:
server: https://<K8S_API_ENDPOINT_IP_FROM_OCI>:6443
`TARGET_IP=<K8S_API_ENDPOINT_IP_FROM_OCI>`
Use 6443 for OKE clusters, use 22 or your SSH port.
Ensure that the required ports are opened via Security Lists or Network Security Groups.
`TARGET_IP=6443`

`chmod +x create_bastion.sh`

Run the below command to create bastion session:
`./create_bastion.sh`

Replace YOUR_PRIVATE_KEY_LOCATION in get_bastion_details.sh with the absolute path to your PRIVATE KEY

`chmod +x  get_bastion_details.sh`

Run the below command to connect to the bastion
Sometimes the bastion session creation takes a few seconds, you can run this command till you get connected.
./create_bastion.sh script is creating bastion session with 3 hours validity, Within this time period, we can re-run ./get_bastion_details.sh - no need to run ./create_bastion.sh.
`./get_bastion_details.sh`


Open another terminal

Edit kube config file to replace the k8s api endpoint IP with local tunnel.
This step is required only once.
`server: https://127.0.0.1:6443`

run kubectl command to test connectivity

