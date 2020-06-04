---
title: "First Hugo"
date: 2020-06-04T14:33:53+08:00
draft: true
---



如果没有SSH Key，则需要先生成一下

```git
ssh-keygen -t rsa -C "xiangshuo1992@gmail.com"
```

### 三、获取SSH Key

```git
cat id_rsa.pub
//拷贝秘钥 ssh-rsa开头
```

### 四、GitHub添加SSH Key

GitHub点击用户头像，选择setting

新建一个SSH Key