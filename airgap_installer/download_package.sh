version=$1

k3s_download_link=https://github.com/k3s-io/k3s/releases/download/${version}/k3s
k3s_image_download_link=https://github.com/k3s-io/k3s/releases/download/${version}/k3s-airgap-images-amd64.tar.zst

mkdir k3s_offline && pushd k3s_offline

# k3s
wget -q ${k3s_download_link}
chmod +x k3s

# k3s image
wget -q ${k3s_image_download_link}
zstd -d k3s-airgap-images-amd64.tar.zst
rm k3s-airgap-images-amd64.tar.zst

# k3s install script
curl -sfL https://get.k3s.io > install.sh
chmod +x install.sh

ls -lah

cat <<EOF > README.md
export ARCH=amd64
sudo mkdir -p /var/lib/rancher/k3s/agent/images/
sudo cp ./k3s-airgap-images-$ARCH.tar /var/lib/rancher/k3s/agent/images/
sudo mv k3s /usr/local/bin/k3s

INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh
INSTALL_K3S_SKIP_DOWNLOAD=true K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken ./install.sh

EOF

popd

tar -czvf k3s_offline_${version}.tar.gz k3s_offline

ls -lah
