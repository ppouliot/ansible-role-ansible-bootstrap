[![Ansible Galaxy](https://img.shields.io/ansible/role/39520.svg?style=flat)](https://galaxy.ansible.com/ppouliot/ansible_bootstrap/) [![Ansible Galaxy Downloads](https://img.shields.io/ansible/role/d/39520.svg)](https://galaxy.ansible.com/ppouliot/ansible_bootstrap/)

# Ansible Role: ansible-bootstrap 
---------------------

In order to effectively run ansible, the target machine needs to have a python interpreter. CoreOS and Flatcar Linux machines are minimal and do not ship with any version of python.  Additonally when using jumpboxes that are managed by someone else you have limited access for software installation and may only be able to install into a single directory structure.

To get around this limitation pypy, a lightweight python interpreter, is installed. The ansible-bootstrap role will install pypy, including pip, in the users home directory, create symlinks for easy usage of the newly installed python stack, and adjust paths.   You then can update our inventory file to use the installed python interpreter on your Container Linux nodes with ansible.

Additionally it becomes extremely usefull to bootstrap contained ansible controller structure into this model.   As such additional features have been added for both bootstraping the pypy for ansible control as well as ansible as a contoller with ssh bastion host proxing enabled.
## Role Variables:
---------------------

### Enable PIP
Setting this value controls the installation of PIP and required tooling into the users home directory.  Default value is set to 'True' 

```
enable_pip: True
```
### Enable Ansible
Setting this value controls the installation of ansible using the newly deployed pypy environment. Additionally symlinks are created in ~/bin for application, and added to use the users path statement in .bashrc. Default value is set to 'False' 

```
enable_ansible: True
```

### Enable Ansible Folders
Setting this value creates the folder infrastructure and configuration files for an ansible contoller deployed into the home directory as the rest of the Tooling.  Default value is set to 'False' 

```
enable_ansible_folders: True
```
### Enable Bastion  (for Ansible SSH Proxying)
Setting this value creates an asible configration for using ansible with ssh proxying through a bastion host in the ansible/ssh.cfg file.  Default value is set to 'False' 

```
enable_bastion: True
bastion_hostname: bastion.contoso.ltd # Bastion Host FQDN
bastion_user: bwayne # Bastion Host User
bastion_ip: 172.168.1.10 # Bastion Host IP address
bastion_ansible_host: 192.168.1.* # Hosts on the other side of the Bastion
```

## Installation
---------------------

Use ansible-galaxy to install the latest module.

```
ansible-galaxy install ppouliot.ansible-bootstrap
```

## Configure your project

Unlike a typical role, you need to configure Ansible to use an alternative python interpreter for container-linux hosts. This can be done by adding a container-linux group to your inventory file and setting the group's vars to use the new python interpreter. This way, you can use ansible to manage CoreOS and non-CoreOS hosts. Simply put every host that has CoreOS into the container-linux inventory group and it will automatically use the specified python interpreter.

```
[container-linux]
host-01
host-02

[container-linux:vars]
enable_pip=True
ansible_ssh_user=core
ansible_python_interpreter=/home/core/bin/python
ansible_connection= ssh
ansible_ssh_private_key_file=/etc/ansible/keys/id_rsa

enable_ansible=True
enable_ansible_folders=True
enable_bastion=True

bastion_hostname=bastion.contoso.ltd
bastion_user=bwayne
bastion_ip=172.168.1.10
bastion_ansible_host=192.168.1.*
```

This will configure ansible to use the python interpreter at /home/core/bin/python which will be created by the ansible-bootstrap role.

## Bootstrap Playbook
---------------------

Now you can simply add the following to your playbook file and include it in your site.yml so that it runs on all hosts in the container-linux group.

```
- hosts: container-linux
  gather_facts: False
  remote_user: core
  roles:
    - ppouliot.ansible-bootstrap
```
Make sure that gather_facts is set to false, otherwise ansible will try to first gather system facts using python which is not yet installed!

## Contributors
---------------------

 * Peter Pouliot <peter@pouliot.net>

## Copyright and License
---------------------

Copyright (C) 2018 Peter J. Pouliot

Peter Pouliot can be contacted at: peter@pouliot.net

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
