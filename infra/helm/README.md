
# install minikube on ubuntu
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb  

# ssh to minikube node
minikube node list
minikube ssh -n "minikube"
minikube ssh -n "minikube-m02"
minikube ssh -n "minikube-m03"