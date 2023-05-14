#!/bin/bash

# 此脚本仅使用于Ubuntu，望大家周知

# 安装Docker
sudo apt install docker.io

# 创建目录
mkdir -p /etc/v2ray

# 提示用户输入V2ray监听端口
read -p "请输入您的V2ray本地监听端口: " port1

# 提示用户输入域名
read -p "请输入您的域名: " domain_name

# 提示用户输入Vmess端口
read -p "请输入您的Vmess端口: " port2

# 提示用户输入UUID
read -p "请输入您的UUID: " uuid

# 提示用户输入WebSocket 路径
read -p "请输入您的WebSocket 路径: " ws_path


# 配置文件
cat << EOF1 > /etc/v2ray/config.json
{
  "inbounds": [
    {
      "tag": "http",
      "port": $port1,
      "listen": "0.0.0.0",
      "protocol": "http",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "allowTransparent": false
      }
    }
  ],
  "outbounds": [
    {
      "tag": "proxy",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "$domain_name",
            "port": $port2,
            "users": [
              {
                "id": "$uuid",
                "alterId": 0
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "fingerprint": ""
        },
        "wsSettings": {
          "path": "/$ws_path"
        }
      },
      "mux": {
        "enabled": false,
        "concurrency": -1
      }
    },
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "block",
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      }
    }
  ],
  "dns": {
    "servers": [
      "114.114.114.114",
      "8.8.8.8"
    ]
  },
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "outboundTag": "direct",
        "domain": [
          "domain:example-example.com",
          "domain:example-example2.com"
        ],
        "enabled": true
      },
      {
        "type": "field",
        "outboundTag": "direct",
        "domain": [
          "geosite:cn"
        ],
        "enabled": true
      },
      {
        "type": "field",
        "outboundTag": "direct",
        "ip": [
          "geoip:private",
          "geoip:cn"
        ],
        "enabled": true
      },
      {
        "type": "field",
        "outboundTag": "block",
        "domain": [
          "geosite:category-ads-all"
        ],
        "enabled": true
      },
      {
        "type": "field",
        "port": "0-65535",
        "outboundTag": "proxy",
        "enabled": true
      }
    ]
  }
}
EOF1

# 安装 v2ray
sudo docker pull teddysun/v2ray
sudo docker run -d -p $port1:$port1 --name v2ray --network bridge --restart=always -v /etc/v2ray:/etc/v2ray/ teddysun/v2ray

echo "http_proxy=http://127.0.0.1:$port1/" | sudo tee -a /etc/environment
echo "https_proxy=http://127.0.0.1:$port1/" | sudo tee -a /etc/environment
echo "脚本执行完毕，请重启输入‘curl cip.cc’验证IP地址
