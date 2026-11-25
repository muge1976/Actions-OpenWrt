#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 默认 LAN IP 改为 192.168.2.2
sed -i 's/192.168.1.1/192.168.2.2/g' package/base-files/files/bin/config_generate

# 主机名
sed -i 's/ImmortalWrt/BleachWrt/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/BleachWrt/g' package/base-files/files/bin/config_generate
