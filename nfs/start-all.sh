#!/bin/bash
kubectl delete-all -n taquy
kubectl apply -f nfs.svc.yaml
kubectl apply -f nfs-client.rbac.yaml
kubectl apply -f nfs-client.sc.yaml
kubectl apply -f nfs-client.svc.yaml
