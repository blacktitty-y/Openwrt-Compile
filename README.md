# Openwrt编译详细流程

#### 介绍
Openwrt编译详细流程

#### 软件架构
Openwrt稳定版


#### 一.搭建编译环境
1.  安装vmware workstation虚拟机
2.  安装Ubuntu    替换国内源:    http://mirrors.aliyun.com/ubuntu
3.  硬盘分区只X第一个
![输入图片说明](https://images.gitee.com/uploads/images/2021/0312/144228_3f3fd5ff_5113630.png "屏幕截图.png")
4.  修改时区:    date -R    结果时区是：-0500
运行 tzselect    4 9 1 1
复制文件到/etc目录下:    sudo cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
再次查看时间date -R    已经修改为北京时间
5.  添加代理编译:
临时代理方式: (以下7890为 Clash for Windows 端口)
export http_proxy=http://ip:7890
export https_proxy=http://ip:7890
永久代理方式:
sudo vi /etc/netplan/00-installer-config.yaml
源码:    https://gitee.com/blacktitty/openwrt/raw/master/00-installer-config.yaml
修改后重启网络服务:    sudo netplan apply


#### 二.脚本执行顺序
1. 修改源码
wget -q https://gitee.com/blacktitty/openwrt/raw/master/op-change.sh && chmod +x op-change.sh && ./op-change.sh

2. 升级
wget -q https://gitee.com/blacktitty/openwrt/raw/master/op-update.sh && chmod +x op-update.sh && ./op-update.sh

3. make -j$(($(nproc) + 1)) V=s
