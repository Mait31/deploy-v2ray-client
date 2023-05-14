# deploy-v2ray-client
### 用途
为大陆服务器部署v2ray客户端，此脚本仅适用于Ubuntu，且服务器已部署好Vmess+ws+tls，望大家周知
### 安装脚本
运行下面的指令下载并安装
```bash
bash <(curl -L https://raw.githubusercontent.com/mait31/deploy-v2ray-client/master/ubuntu.sh)
```
### 环境变量
此脚本已默认将环境变量写入/etc/environment文件，使其全局生效。如果您需要删除http_proxy和https_proxy变量的设置，可以执行以下命令：
```bash
sudo sed -i '/http_proxy/d' /etc/environment
sudo sed -i '/https_proxy/d' /etc/environment
```
执行完上述命令后，环境变量就被删除了，再打开一个新的终端窗口使用即可
