#!/bin/bash
minikube start \
  --addons=[] \
  --apiserver-port=8443 \
  --auto-update-drivers=true \
  --cache-images=true \
  --cni='calico' \
  --container-runtime='docker' \
  --cpus='4' \
  --delete-on-failure=false \
  --disk-size='20g' \
  --dns-domain='taquy.local' \
  --docker-env=[] \
  --driver='virtualbox' \
  --dry-run=false \
  --force=true \
  --force-systemd=true \
  --host-only-cidr='172.16.0.1/24' \
  --install-addons=true \
  --interactive=false \
  --keep-context=false \
  --kubernetes-version='stable' \
  --memory='12g' \
  --mount=true \
  --mount-string='/home/qt:/minikube-host' \
  --namespace='default' \
  --native-ssh=true \
  --nodes=3 \
  --service-cluster-ip-range='10.0.0.0/16'

# cluster dns domain name used in the Kubernetes cluster
# virtualbox, vmwarefusion, kvm2, vmware, none, docker, podman, ssh
# The CIDR to be used for the minikube VM (virtualbox driver only)
# (ex: v1.2.3, 'stable' for v1.21.2, 'latest' for v1.22.0-beta.0)
# mount daemon and automatically mount files into minikube
# Use native Golang SSH client
# The CIDR to be used for service cluster IPs.
