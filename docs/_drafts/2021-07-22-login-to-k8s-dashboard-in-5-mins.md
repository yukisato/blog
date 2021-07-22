---
title: Login to k8s Dashboard in 5 mins
description: This is a quick tip for logging in k8s dashboard using k8s token.
tags:
  - docker
  - k8s
  - microk8s
---

This is a quick tip for logging in k8s dashboard using k8s token.
Be sure it's not explaining how to install the dashboard itself.

## Prerequisites

You need to fill the following requisites:

- kubernetes dashboard on the remote node
- kubectl command installed locally

## How to login to the dashboard

There are two steps to use the dash board, where are:

 1. Run kubernetes proxy on local
 2. Open the dashboard in a browser
 3. Get login token and use it for login in

Let's do one by one.

### 1. Run proxy

Type the following command to run proxy locally:

```bash
$ kubectl proxy --address='0.0.0.0' --accept-hosts='^*$'
Starting to serve on [::]:8001
```

Open the following URL and you'll see a login page of the dashboard:

`http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/`

At this time, let's login with a `token`.

### Generate a token for logging in

As described [in the microk8s's document](), you can ealisy get the token with this command:

```bash
token=$(kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
kubectl -n kube-system describe secret $token
```

You'll see the details of the secret, so use the token for logging into  the k8s dashboard.

All Done! Enjoy hacking with k8s! ;)
