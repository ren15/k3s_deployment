export http_proxy=http://192.168.31.203:1087;export https_proxy=http://192.168.31.203:1087;

DB_IP=192.168.31.188

curl -sfL https://get.k3s.io | sh -s - server \
  --token=ren_org_k3s \
  --datastore-endpoint="http://${DB_IP}:2379"