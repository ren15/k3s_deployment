# k3s_deployment



## Deploy k3s cluster on ubuntu 20.04 with cilium

```bash

# suppose we have two EC2 (VM on AWS) 10.2.0.11(host-1), 10.2.0.12(host-2)

# https://docs.cilium.io/en/v1.12/gettingstarted/k3s/
# https://docs.cilium.io/en/v1.12/gettingstarted/k8s-install-helm/
# https://docs.cilium.io/en/latest/network/kubernetes/kubeproxy-free/

# install k3s-server on host-1
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh -

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm repo add cilium https://helm.cilium.io/

# configure helm 
export API_SERVER_IP=10.2.0.11
export API_SERVER_PORT=6443
helm install cilium cilium/cilium \
    --namespace kube-system \
    --set kubeProxyReplacement=strict \
    --set k8sServiceHost=${API_SERVER_IP} \
    --set k8sServicePort=${API_SERVER_PORT} \
    --set operator.replicas=1

# Restart unmanaged Pods
kubectl get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,HOSTNETWORK:.spec.hostNetwork --no-headers=true | grep '<none>' | awk '{print "-n "$1" "$2}' | xargs -L 1 -r kubectl delete pod

# validate
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

cilium status 

# get k3s-token
sudo cat /var/lib/rancher/k3s/server/node-token

# install k3s-agent on host-2
curl -sfL https://get.k3s.io | K3S_URL='https://${MASTER_IP}:6443' K3S_TOKEN=${NODE_TOKEN} sh -

# try deploy busybox to the cluster
kubectl apply -f https://raw.githubusercontent.com/ren15/k3s_deployment/main/k8s/dep1.yaml

kubectl exec -it dep1 -- sh
ping www.google.com  # works

```

