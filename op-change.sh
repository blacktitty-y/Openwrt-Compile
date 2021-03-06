#!/bin/bash

cd lede

#拉取插件并且更新luci-theme-argon插件
cd package/lean
rm -rf luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git && git clone https://github.com/jerrykuku/luci-app-argon-config.git && git clone https://github.com/tty228/luci-app-serverchan.git && git clone https://github.com/rufengsuixing/luci-app-adguardhome.git
cd -

# 添加插件至feeds.conf.default:
# 去掉src-git前面的# 在末尾追加插件源
sed -i 's/#src-git helloworld https:\/\/github.com\/fw876\/helloworld/src-git helloworld https:\/\/github.com\/fw876\/helloworld\nsrc-git openclash https:\/\/github.com\/vernesong\/OpenClash.git\nsrc-git passwall https:\/\/github.com\/xiaorouji\/openwrt-passwall.git\nsrc-git OpenAppFilter https:\/\/github.com\/destan19\/OpenAppFilter.git/g' feeds.conf.default

# 修改输出镜像参数
sed -i 's/default 160/default 512/g' config/Config-images.in
sed -i '/config GRUB_IMAGES/,+5s/default y/default n/g' config/Config-images.in
sed -i '/config GRUB_CONSOLE/,+3s/default y/default n/g' config/Config-images.in

# 默认nginx启动 最前面加#去掉uhttpd
sed -i '/init.d\/uhttpd/s/^/#&/g' package/network/services/uhttpd/Makefile

# 修改ssh端口
sed -i 's/22/2020/g' package/network/services/dropbear/files/dropbear.config

# default-settings 去掉luci 添加对python3的支持
sed -i 's/ +luci / +python3 +python3-requests /g' package/lean/default-settings/Makefile

# 更改默认主题
sed -i 's/+luci-theme-bootstrap/+luci-theme-argon/g' feeds/luci/collections/luci-ssl-nginx/Makefile

# 网络共享添加新增用户支持
sed -i 's/LUCI_DEPENDS:=/LUCI_DEPENDS:=+ksmbd-utils /g' package/lean/luci-app-cifsd/Makefile

# 修改默认配置
sed -i 's/autosamba //g;s/luci-app-ipsec-vpnd //g;s/luci-app-zerotier luci-app-xlnetacc //g' target/linux/x86/Makefile
sed -i 's/ luci / luci-ssl-nginx /g;s/luci-app-autoreboot luci-app-webadmin //g;s/luci-app-filetransfer //g;s/luci-app-sfe //g;s/luci-app-unblockmusic //g;s/luci-app-vlmcsd //g' include/target.mk
sed -i '/ddns-scripts_aliyun ddns-scripts_dnspod/a luci-app-softethervpn luci-app-transmission  luci-app-serverchan' include/target.mk
sed -i '/ddns-scripts_aliyun ddns-scripts_dnspod/a luci-app-oaf luci-app-openclash luci-app-qbittorrent luci-app-passwall luci-app-rclone \\' include/target.mk
sed -i '/ddns-scripts_aliyun ddns-scripts_dnspod/a luci-app-cifs-mount luci-app-cifsd luci-app-hd-idle luci-app-docker luci-app-nfs \\' include/target.mk
sed -i '/ddns-scripts_aliyun ddns-scripts_dnspod/a luci-app-adguardhome luci-app-amule luci-app-argon-config luci-app-aria2 \\' include/target.mk
sed -i 's/ddns-scripts_aliyun ddns-scripts_dnspod/ddns-scripts_aliyun ddns-scripts_cloudflare.com-v4 ddns-scripts_dnspod \\/g' include/target.mk

# 修改自定义用户名
sed -i '0,/root/s/root/blacktitty/' package/base-files/files/etc/passwd
sed -i '0,/root/s/root/blacktitty/' package/base-files/files/etc/shadow
sed -i 's/root/blacktitty/g' package/system/rpcd/files/rpcd.config
sed -i 's/"root"/"blacktitty"/g' feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/index.lua
sed -i 's/"root"/"blacktitty"/g' feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua
sed -i 's/"root"/"blacktitty"/g' feeds/luci/modules/luci-base/luasrc/controller/admin/servicectl.lua
sed -i 's/user root/user blacktitty root/g' feeds/packages/net/nginx-util/files/uci.conf.template
sed -i 's/root:/blacktitty:/g' package/lean/default-settings/files/zzz-default-settings

# 网页去掉默认用户名
sed -i "s/value=\"<%=duser%>\" //g;s/'luci_password'/'luci_username'/g" /home/tim/lede/package/lean/luci-theme-argon/luasrc/view/themes/argon/sysauth.htm

# 添加docker-compose的支持
sed -i 's/LUCI_DEPENDS:=/LUCI_DEPENDS:=+docker-compose /g' package/lean/luci-app-docker/Makefile

# 开始编译
./scripts/feeds update -a && ./scripts/feeds install -a

echo "
首次用:
make -j8 download V=s
make -j1 V=s

非首次用:
make -j$(($(nproc) + 1)) V=s
"

rm -rf ./tmp && rm -rf .config && make menuconfig
