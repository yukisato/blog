---
title: Seting up microk8s on a single VPS
description: This post explains how to minimally setup a k8s cluster on a single Linux VPS using microk8s.
tags:
  - docker
  - k8s
  - microk8s
---

This post explains how to minimally setup a k8s cluster on a single VPS cluster using microk8s.

This process consists of the following:

 1. Install and setup microk8s
 2. Create k8s configurations and apply
 3. Setup Ingress to expose your site
 4. Cleanup

## Prerequisites

- Have a basic knowledge of both docker and kubernetes(pod, node, service etc)
 - Need to Have a VPS instance and can globally access to it via ssh.

## 1. Install and setup microk8s

**Install `snap`**
As microk8s is installed via `snap` package manager on Linux, you firstly need to have it installed.

```bash
sudo apt update
sudo apt install snapd
```

**Install `microk8s`**

```bash
sudo snap install microk8s --classic
```

**Add the working user to the microk8s group**
Once microk8s is installed, a microk8s group is created automatically. Just join your user to this group so that you can use microk8s command without sudoing.

```bash
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
```

**Check status**
The following fommand waits until microk8s is ready.

```bash
microk8s status --wait-ready
```

**Create an alias for kubectl**
microk8s comes with `kubecrl` but it is namespaced so you can't call it directly so you need to run `microk8s kubectl` command each time. Setting up an alias skilps father operations.

Open `.bashrc` or `.bash_aliases` and add the following line:

```bash
alias kubectl="microk8s kubectl"
```

*if you use `zsh` or other shells, follow your shell configuration ways instead.*

## 2. Create k8s configurations and apply

### Create Deployment

For create pods, replicaset, and deployment, it's a best practice that you define them into one file. Create a file `deployment.yml`:

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-deployment
  labels:
    app: nginx
spec:
  replicas: 1 # desired number of pods
  selector:
    matchLabels:
      app: nginx
  template: # pod configuration
    metadata:
      labels:
        app: nginx
    spec:
      containers: # containers being in a pod
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

## 3. Setup Ingress to expose your site

// TODO: write this

## 4. Cleanup

microk8s offers the very easy way to clean it up which is `reset` and `stop` subcommands. `reset` subcommand literally resets all the data and features to default. `stop` subcommand stops microk8s itself.

```bash
# Reset all the data and settings
microk8s reset

# Stop microk8s
microk8s stop
```

*You can anytime come back by `microk8s start` command.*


All Done! Enjoy your site building! ;)
