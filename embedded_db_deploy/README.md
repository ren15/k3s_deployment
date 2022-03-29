
1. Prepare air-gap installer

2. Use air-gap installer to install 

3. bootstrap


```bash
export http_proxy=http://192.168.31.203:1087;export https_proxy=http://192.168.31.203:1087;
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true sh -s -

K3S_TOKEN=ren_org_k3s k3s server --cluster-init
K3S_TOKEN=ren_org_k3s k3s server --server https://192.168.31.112:6443

# /etc/systemd/system/k3s.service

```