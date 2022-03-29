version="v1.23.4+k3s1"

k3s_download_link=https://github.com/k3s-io/k3s/releases/download/${version}/k3s
k3s_image_download_link=https://github.com/k3s-io/k3s/releases/download/${version}/k3s-airgap-images-amd64.tar.zst

wget -c ${k3s_download_link}

wget -c ${k3s_image_download_link}
zstd -d k3s-airgap-images-amd64.tar.zst

ls -lah

