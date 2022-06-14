# Easy OCI Bastion access from commandline
Scripts to easily connect to OCI private servers or private OKE clusters (Kubernetes) using Bastion Service.

These scripts allows to create bastion session from the command line.

## Prerequisites
- Setup OCI cli.
- Install jq - To parse JSON.

```
In ubunutu, sudo apt install -y jq

In CentOS, yum install jq -y
```

Fill these 3 variables in create_bastion.sh

- `BASTION=<OCID_OF_BASTION_FROM_OCI>`

- `PUBKEY=<LOCAL_PUB_KEY_LOCATION>` This is the absolute path to your PUBLIC KEY

- `TARGET_IP=<K8S_API_ENDPOINT_IP_FROM_OCI>` You can find this IP from OKE cluster kube config file. 

Open kube config file and look for the line with server:

`server: https://<K8S_API_ENDPOINT_IP_FROM_OCI>:6443` 

`TARGET_PORT=6443`

*Use 6443 for OKE clusters, For SSH use 22 or custom SSH port of the server.*

Ensure that the required ports are opened via Security Lists or Network Security Groups.

`chmod +x create_bastion.sh`

### Run the below command to create bastion session:

`./create_bastion.sh`

Replace YOUR_PRIVATE_KEY_LOCATION in get_bastion_details.sh with the absolute path to your PRIVATE KEY

`chmod +x  get_bastion_details.sh`

### Run the below command to connect to the bastion session

Sometimes the bastion session creation takes a few seconds, you can run this command till you get connected.

./create_bastion.sh script is creating bastion session with 3 hours validity, Within this time period, we can re-run ./get_bastion_details.sh - no need to 

run ./create_bastion.sh.

`./get_bastion_details.sh`


*Open another terminal*

### For OKE cluster access
Edit kube config file to replace the k8s api endpoint IP with local tunnel.

This step is required only once.

`server: https://127.0.0.1:6443`

run kubectl command to test connectivity

### For SSH access to private server

SSH via local port 6443

ssh -p 6443 user@127.0.0.1 -i private_key
