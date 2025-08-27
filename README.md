# Ansible Apache Setup

This is a simple Ansible project to install and configure Apache on a Ubuntu host.

## Features

- Installs Apache2
- Deploys a custom index.html page
- Ensures Apache is running and enabled on boot

## Usage

```bash
ansible-playbook -i inventory/hosts.ini playbook.yml