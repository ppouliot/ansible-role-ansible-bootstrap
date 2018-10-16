# Ansible Role: container-linux-bootstrap 
---------------------

In order to effectively run ansible, the target machine needs to have a python interpreter. CoreOS and Flatcar Linux machines are minimal and do not ship with any version of python. To get around this limitation pypy, a lightweight python interpreter, is installed. The container-linux-bootstrap role will install pypy, including pip, in the Container Linux's default 'core' user, and create symlinks for easy usage of the newly installed python stack.   You then can update our inventory file to use the installed python interpreter on your Container Linux nodes with ansible.

## Role Variables:
---------------------

### Enable PIP
Setting this value controls the installation of PIP and required tooling on the Container Linux platform.  Default value is set to 'True' 

```
enable_pip: True
```

## Installation
---------------------

ansible-galaxy install ppouliot.container-linux-bootstrap
Configure your project

Unlike a typical role, you need to configure Ansible to use an alternative python interpreter for container-linux hosts. This can be done by adding a container-linux group to your inventory file and setting the group's vars to use the new python interpreter. This way, you can use ansible to manage CoreOS and non-CoreOS hosts. Simply put every host that has CoreOS into the container-linux inventory group and it will automatically use the specified python interpreter.

```
[container-linux]
host-01
host-02

[container-linux:vars]
enable_pip=True
ansible_ssh_user=core
ansible_python_interpreter=/home/core/bin/python

```

This will configure ansible to use the python interpreter at /home/core/bin/python which will be created by the container-linux-bootstrap role.


## Bootstrap Playbook
---------------------

Now you can simply add the following to your playbook file and include it in your site.yml so that it runs on all hosts in the container-linux group.

```
- hosts: container-linux
  gather_facts: False
  remote_user: core
  roles:
    - ppouliot.container-linux-bootstrap
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

