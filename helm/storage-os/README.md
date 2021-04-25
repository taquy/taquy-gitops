```bash
helm repo add storageos https://charts.storageos.com

helm search repo storageos

rm -rf charts && helm dep update && helm dep build .

helm install storageos ./ -f values.yaml
helm upgrade -i storageos ./ -f ./values.yaml

helm uninstall nfs-client-provisioner
```