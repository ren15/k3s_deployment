version="v1.23.4+k3s1"

k3s_download_link=https://github.com/k3s-io/k3s/releases/download/${version}/k3s
k3s_image_download_link=https://github.com/k3s-io/k3s/releases/download/${version}/k3s-airgap-images-amd64.tar.zst

mkdir k3s_offline
cd k3s_offline

wget -q ${k3s_download_link}

wget -q ${k3s_image_download_link}
zstd -d k3s-airgap-images-amd64.tar.zst
rm k3s-airgap-images-amd64.tar.zst

curl -sfL https://get.k3s.io > install.sh

ls -lah

cd ..
tar -cvf k3s_offline_${version}.tar.gz k3s_offline

ls -lah
