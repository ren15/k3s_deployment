# k3s_deployment



## Deploy k3s cluster on ubuntu 20.04 with cilium

```bash

# suppose we have two EC2 (VM on AWS) 10.2.0.11(host-1), 10.2.0.12(host-2)

# https://docs.cilium.io/en/v1.12/gettingstarted/k3s/

# install k3s-server on host-1
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh -

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# configure helm https://docs.cilium.io/en/latest/network/kubernetes/kubeproxy-free/
export API_SERVER_IP=10.2.0.11
export API_SERVER_PORT=6443
helm install cilium cilium/cilium \
    --namespace kube-system \
    --set kubeProxyReplacement=strict \
    --set k8sServiceHost=${API_SERVER_IP} \
    --set k8sServicePort=${API_SERVER_PORT} \
    --set operator.replicas=1


# get k3s-token
sudo cat /var/lib/rancher/k3s/server/node-token

# install k3s-agent on host-2
curl -sfL https://get.k3s.io | K3S_URL='https://${MASTER_IP}:6443' K3S_TOKEN=${NODE_TOKEN} sh -

# try deploy busybox to the cluster
kubectl apply -f a.yaml

kubectl exec -it dep -- sh
ping www.google.com  # works

```

