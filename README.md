# OCI Bastion access from commandline

Scripts to easily connect to OCI private servers or private OKE clusters (Kubernetes) using Bastion Service without visiting OCI console.


- [Accessing Private OKE Cluster](#accessing-private-oke-cluster)
  - [Prerequisites:](#prerequisites)
  - [Configurations](#configurations)
  - [Create bastion session](#create-bastion-session)
  - [Create the tunnel](#create-the-tunnel)
  - [Access OKE Cluser](#access-oke-cluster)
- [Accessing Private VM](accessing-private-vm)

## Accessing Private OKE Cluster

### Prerequisites
1. Setup OCI cli.
2. Install jq. `sudo apt install -y jq (Ubuntu) /  yum install jq -y (CentOS)` It is used to parse JSON.
3. Ensure that the required ports(6443 or 22) are opened via Security Lists or Network Security Groups from the Bastion network to the target cluster/machine.

#### Configurations
```
Fill these 3 variables in create_bastion.sh
BASTION= Bastion OCID
PUBKEY= This is the absolute path to your PUBLIC KEY
TARGET_IP= Kubernetes Private Endpoint API IP. You can find this IP from OKE cluster kube config file or OCI Console. 
TARGET_PORT=6443 <-- default port for k8s API endpoint
```
Open kube config file and look for this line `server: https://<K8S_API_ENDPOINT_IP_FROM_OCI>:6443` 

```
chmod +x create_bastion.sh # Make it executable.
```

#### Create bastion session

Run `./create_bastion.sh` - It creates a bastion session with 3 hours validity. Validity can be configured via `SESSION_TTL` variable, defaults to 3 hours(10800). bastion session is written to a file bastion_session_id - This can be configured by setting the TMP_FILE variable.

Replace YOUR_PRIVATE_KEY_LOCATION in get_bastion_details.sh with the absolute path to your PRIVATE KEY

```
#get_bastion_details.sh
YOUR_PRIVATE_KEY_LOCATION=YOUR_PRIVATE_KEY
```

`chmod +x  get_bastion_details.sh` # Make it executable.

### Create the tunnel

Run `./get_bastion_details.sh`

Note:
- Bastion session creation takes a few seconds, you can run this command til you get connected.
- Input to this command is TMP_FILE, which contains the Bastion session ID. 
- Session validity is 3 hours by default. Within this time period, we can re-run ./get_bastion_details.sh to connect to the tunnel - no need to run ./create_bastion.sh.
- After a successful connection terminal is unusable, you can either make it a background process(crtl-Z and bg command) or continue working on another screen window.

### Access OKE cluster

After a successful connection terminal is unusable, you can either make it a background process(crtl-Z and bg command) or continue working on another screen window.

**Edit kube config file to replace the k8s api endpoint IP with local tunnel.** This step is required only once.
`server: https://127.0.0.1:6443`

Run kubectl command to test connectivity

## Accessing Private VM

```
Fill these 3 variables in create_bastion.sh
BASTION= Bastion OCID
PUBKEY= This is the absolute path to your PUBLIC KEY
TARGET_IP= Private IP of the VM
TARGET_PORT=22 <-- SSH port
```

```
chmod +x create_bastion.sh # Make it executable.
Run `./create_bastion.sh`
```

```
#get_bastion_details.sh -> YOUR_PRIVATE_KEY_LOCATION=YOUR_PRIVATE_KEY
chmod +x  get_bastion_details.sh # Make it executable.
#Create the tunnel
Run `./get_bastion_details.sh`
# After a successful connection terminal is unusable, you can either make it a background process(crtl-Z and bg command) or continue working on another screen window.
```

Final step: SSH via tunnel
```
#SSH via local port 6443 from another shell
ssh -p 6443 user@127.0.0.1 -i private_key
```
