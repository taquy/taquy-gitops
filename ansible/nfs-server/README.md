# reference source
- https://advishnuprasad.com/blog/2016/03/29/setup-nfs-server-and-client-using-ansible/

# run command

```bash
ansible all -i hosts.yaml --become --become-user=root --extra-vars "ansible_sudo_pass=1"
```