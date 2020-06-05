---
title: "Kubernetes_problem"
date: 2020-06-05T22:35:45+08:00
draft: false
tags: ["docker","kubernetes"]
description: "kubernetes 故障检查策略"
categories: ["server"]
author: "dannyz"
---

## K8S故障排除方法

### 1.查看pods哪些是有问题的，Runningg正常，其他异常；

```/opt/kubernetes/bin/kubectl get pods --all-namespaces -owide```

NAMESPACE NAME READY STATUS RESTARTS AGE IP NODE NOMINATED NODE

default nginx-dbddb74b8-d78cd 1/1 Running 0 17m 172.17.90.3 192.168.18.148 <none>

### 2.查看异常pod的详情

```/opt/kubernetes/bin/kubectl describe pods nginx-dbddb74b8-2hthr```

**我这边异常信息如下：**

Warning FailedScheduling 32m (x2 over 32m) default-scheduler 0/2 nodes are available: 2 node(s) had taints that the pod didn't tolerate.

解决办法：参考：https://github.com/kubernetes-sigs/kubespray/issues/2798

### 3.查看异常服务的详情

```
/opt/kubernetes/bin/kubectl describe services nginx
```
### 4.查看集群node的状态

```
/opt/kubernetes/bin/kubectl get nodes -o wide

NAME STATUS ROLES AGE VERSION INTERNAL-IP EXTERNAL-IP OS-IMAGE KERNEL-VERSION CONTAINER-RUNTIME

192.168.18.147 NotReady <none> 62m v1.12.1 192.168.18.147 <none> CentOS Linux 7 (Core) 3.10.0-862.el7.x86_64 docker://18.9.5
```
我这边是NotReady状态，经排查发现， node18.147上面的kubelet kube-proxy挂掉了，服务启来后就可以了

### 5.查看node的详情

```
/opt/kubernetes/bin/kubectl describe node 192.168.18.147

Warning FailedScheduling 32m (x2 over 32m) default-scheduler 0/2 nodes are available: 2 node(s) had taints that the pod didn't tolerate.
```
这个的具体解决方法：

我这边查看pod详情，Taints显示如下：

Taints: node.kubernetes.io/unreachable:NoSchedule

执下如下命令后即可

[root@master tmp]# /opt/kubernetes/bin/kubectl taint nodes --all node.kubernetes.io/unreachable-

node/192.168.18.147 untainted

node/192.168.18.148 untainted

### 6.查看集群组件状态

```
/opt/kubernetes/bin/kubectl get cs

NAME STATUS MESSAGE ERROR

scheduler Healthy ok

controller-manager Healthy ok

etcd-1 Healthy {"health":"true"}

etcd-2 Healthy {"health":"true"}

etcd-0 Healthy {"health":"true"}
```
7.查看服务集群IP、端口、运行时长

/opt/kubernetes/bin/kubectl get svc

NAME TYPE CLUSTER-IP EXTERNAL-IP PORT(S) AGE

kubernetes ClusterIP 10.0.0.1 <none> 443/TCP 4h51m

nginx NodePort 10.0.0.215 <none> 88:40675/TCP 92m

在dashboard界面删除容器，发现无法删除。使用命令查看发现该pod一直处于terminating的状态

Kubernetes强制删除一直处于Terminating状态的pod。

1、使用命令获取pod的名字

kubectl get po -n NAMESPACE |grep Terminating

2、使用kubectl中的强制删除命令

kubectl delete pod podName -n NAMESPACE --force --grace-period=0