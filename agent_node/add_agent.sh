export http_proxy=http://192.168.31.203:1087;export https_proxy=http://192.168.31.203:1087;

curl -sfL https://get.k3s.io | sh -s - agent \
--token=ren_org_k3s \
--server https://192.168.31.112:6443