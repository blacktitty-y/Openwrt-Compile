#!/bin/bash

cd lede

# 放弃本地修改 使远程库内容强制覆盖本地代码
git fetch --all && git reset --hard

sed -i 's/+luci-theme-argon/+luci-theme-bootstrap/g' feeds/luci/collections/luci-ssl-nginx/Makefile

sed -i 's/"blacktitty"/"root"/g' feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/index.lua
sed -i 's/"blacktitty"/"root"/g' feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua
sed -i 's/"blacktitty"/"root"/g' feeds/luci/modules/luci-base/luasrc/controller/admin/servicectl.lua
sed -i 's/user blacktitty root/user root/g' feeds/packages/net/nginx-util/files/uci.conf.template

# 升级
git pull && cd package/lean
rm -rf luci-theme-argon luci-app-argon-config luci-app-serverchan luci-app-adguardhome luci-app-dockerman
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git && git clone https://github.com/jerrykuku/luci-app-argon-config.git && git clone https://github.com/tty228/luci-app-serverchan.git && git clone https://github.com/rufengsuixing/luci-app-adguardhome.git && cd -

# 更新
./scripts/feeds update -a && ./scripts/feeds install -a

echo "
首次用:
make -j8 download V=s
make -j1 V=s

非首次用:
make -j$(($(nproc) + 1)) V=s
"

rm -rf ./tmp && rm -rf .config
