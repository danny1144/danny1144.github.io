---
title: "Docker Desktop Kubernetes"
date: 2020-06-05T15:31:54+08:00
draft: false
tags: ["docker","kubernetes"]
description: "windows10 docker-desktop安装kuberetes"
categories: ["server"]
author: "dannyz"
---


## windows10 docker-desktop安装kuberetes:v1.15.5

- 对应版本

![image-20200306124600307](https://upload-images.jianshu.io/upload_images/10040407-54bf69a36bf6c0b8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 首先创建一个镜像对应表文件 images.properties：

  ````
  k8s.gcr.io/pause:3.1=registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
  k8s.gcr.io/kube-controller-manager:v1.15.5=registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.15.5
  k8s.gcr.io/kube-scheduler:v1.15.5=registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.15.5
  k8s.gcr.io/kube-proxy:v1.15.5=registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.15.5
  k8s.gcr.io/kube-apiserver:v1.15.5=registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.15.5
  k8s.gcr.io/etcd:3.3.10=registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.3.10
  k8s.gcr.io/coredns:1.3.1=registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.3.1
  k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1=registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.1
  ````

  

- 然后在相同目录下，创建脚本 docker-images-k8s.ps1：

```
foreach($line in Get-Content .\images.properties) {
    $data = $line.Split('=')
    $key = $data[0];
    $value = $data[1];
    Write-Output "$key=$value"
    docker pull ${value}
    docker tag ${value} ${key}
    docker rmi ${value}
}
```

- 执行上面的脚本

- 启用kubeernetes功能

![image-20200306122944441](https://upload-images.jianshu.io/upload_images/10040407-2d1aae0d7ca150ee.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 启用dashboard

```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

```

部署成功后，启动 Kubernetes API Server 访问代理。



```csharp
$ kubectl proxy
Starting to serve on 127.0.0.1:8001
```

这时候，打开浏览器，通过如下 URL 访问 Kubernetes Dashboard：
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default

 

通过令牌访问

通过以下脚本，配置访问控制台所需的令牌。

```shell
TOKEN=$(kubectl -n kube-system describe secret default| awk '$1=="token:"{print $2}')
kubectl config set-credentials docker-desktop --token="${TOKEN}"
echo $TOKEN
```

