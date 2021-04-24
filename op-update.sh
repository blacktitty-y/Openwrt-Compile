#!/bin/bash

cd lede

#删除拉取插件
cd package/lean
rm -rf luci-theme-argon luci-app-argon-config luci-app-serverchan luci-app-adguardhome
cd -

# 放弃本地修改 使远程库内容强制覆盖本地代码
git fetch --all && git reset --hard

sed -i 's/+luci-theme-argon/+luci-theme-bootstrap/g' feeds/luci/collections/luci-ssl-nginx/Makefile

sed -i 's/"blacktitty"/"root"/g' feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/index.lua
sed -i 's/"blacktitty"/"root"/g' feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua
sed -i 's/"blacktitty"/"root"/g' feeds/luci/modules/luci-base/luasrc/controller/admin/servicectl.lua
sed -i 's/user blacktitty root/user root/g' feeds/packages/net/nginx-util/files/uci.conf.template

# 升级更新
git pull && ./scripts/feeds update -a && ./scripts/feeds install -a

echo "
首次用:
make -j8 download V=s
make -j1 V=s

非首次用:
make -j$(($(nproc) + 1)) V=s
"

rm -rf ./tmp && rm -rf .config
