
1. Prepare air-gap installer

2. Use air-gap installer to install 

3. bootstrap


```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true sh -s -

K3S_TOKEN=ren_org_k3s k3s server --cluster-init
K3S_TOKEN=ren_org_k3s k3s server --server https://192.168.31.112:6443

# /etc/systemd/system/k3s.service

```



## Offline install 

```bash
## prepare files
tar xvf k3s_offline_v1.23.4+k3s1.tar.gz

sudo mkdir -p /var/lib/rancher/k3s/agent/images/
sudo cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/

sudo cp k3s /usr/local/bin/k3s
## -----------------------------

## install master
INSTALL_K3S_SKIP_DOWNLOAD=true K3S_TOKEN=ren_org_k3s INSTALL_K3S_SKIP_ENABLE=true ./install.sh

### install master 1
K3S_TOKEN=ren_org_k3s k3s server --cluster-init
### install master 2+
K3S_TOKEN=ren_org_k3s k3s server --server https://192.168.31.112:6443

sudo systemctl enable --now k3s.service
## -----------------------------


## install agent
INSTALL_K3S_SKIP_DOWNLOAD=true K3S_TOKEN=ren_org_k3s K3S_URL=https://192.168.31.112:6443 INSTALL_K3S_SKIP_ENABLE=true ./install.sh
K3S_TOKEN=ren_org_k3s K3S_URL=https://192.168.31.112:6443 k3s agent
sudo systemctl enable --now k3s-agent.service

```

