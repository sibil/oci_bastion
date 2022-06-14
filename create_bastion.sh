BASTION=<OCID_OF_BASTION_FROM_OCI>
PUBKEY=<PUB_KEY_LOCATION>
TARGET_IP=<K8S_API_ENDPOINT_IP_FROM_OCI>
TARGET_PORT=6443
DISPLAY_NAME_PREFIX=MY_SESSION
SESSION_TTL=10800
TMP_FILE=bastion_session_id

oci bastion session create-port-forwarding --bastion-id $BASTION --display-name $DISPLAY_NAME_PREFIX`date +%F_%s` --ssh-public-key-file $PUBKEY  --target-private-ip $TARGET_IP --target-port $TARGET_PORT --session-ttl $SESSION_TTL |  jq '.data.id'| tee $TMP_FILE
