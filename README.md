# Ansible Role: container-Linux.bootstrap 

In order to effectively run ansible, the target machine needs to have a python interpreter. CoreOS and Flatcar Linux machines are minimal and do not ship with any version of python. To get around this limitation we can install pypy, a lightweight python interpreter. The container-linux-bootstrap role will install pypy for us and we will update our inventory file to use the installed python interpreter.

## Installation

ansible-galaxy install ppouliot.container-linux_bootstrap
Configure your project

Unlike a typical role, you need to configure Ansible to use an alternative python interpreter for container-linux hosts. This can be done by adding a container-linux group to your inventory file and setting the group's vars to use the new python interpreter. This way, you can use ansible to manage CoreOS and non-CoreOS hosts. Simply put every host that has CoreOS into the container-linux inventory group and it will automatically use the specified python interpreter.

```
[container-linux]
host-01
host-02

[container-linux:vars]
ansible_ssh_user=core
ansible_python_interpreter=/home/core/bin/python
```

This will configure ansible to use the python interpreter at /home/core/bin/python which will be created by the container-linux-bootstrap role.


## Bootstrap Playbook

Now you can simply add the following to your playbook file and include it in your site.yml so that it runs on all hosts in the container-linux group.

```
- hosts: container-linux
  gather_facts: False
  roles:
    - ppouliot.container-linux-bootstrap
```

Make sure that gather_facts is set to false, otherwise ansible will try to first gather system facts using python which is not yet installed!
