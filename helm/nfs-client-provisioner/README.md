
```bash
helm repo add nfs-client-provisioner https://ckotzbauer.github.io/helm-charts

helm search repo nfs-client-provisioner
helm repo update

helm dep update && helm dep build .

helm install nfs-client-provisioner ./ -f values.yaml
helm upgrade -i nfs-client-provisioner ./ -f ./values.yaml

helm uninstall nfs-client-provisioner
```