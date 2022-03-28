NODE1=127.0.0.1
REGISTRY=quay.io/coreos/etcd
ETCD_VERSION=v3.5.2
DATA_DIR="etcd-data"

echo "Creating etcd-data volume"
docker volume create --name etcd-data

echo "Starting etcd docker container"

docker run \
  -d \
  -p 2379:2379 \
  -p 2380:2380 \
  --restart unless-stopped \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:${ETCD_VERSION} \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name node1 \
  --initial-advertise-peer-urls http://${NODE1}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${NODE1}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster node1=http://${NODE1}:2380

sleep 10;
echo "Listing the cluster member..."

etcdctl --endpoints=http://${NODE1}:2379 member list