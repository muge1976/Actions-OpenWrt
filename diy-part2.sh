#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 默认 LAN IP 改为 192.168.2.2
sed -i 's/192.168.1.1/192.168.2.2/g' package/base-files/files/bin/config_generate

# 主机名改为 winx86
sed -i 's/ImmortalWrt/winx86/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/winx86/g' package/base-files/bin/config_generate 2>/dev/null
sed -i 's/OpenWrt/winx86/g' package/base-files/files/bin/config_generate

# 修复：宿主 upx 不存在导致 mihomo 等 Go 包编译报 Error 127
sudo apt-get update -qq >/dev/null 2>&1 || true
sudo apt-get install -y -qq upx-ucl >/dev/null 2>&1 || true
mkdir -p "$PWD/staging_dir/host/bin"
if [ -x /usr/bin/upx ]; then
  cp -f /usr/bin/upx "$PWD/staging_dir/host/bin/upx"
  chmod +x "$PWD/staging_dir/host/bin/upx"
  echo "upx installed: $(ls -l $PWD/staging_dir/host/bin/upx)"
fi
if [ ! -x "$PWD/staging_dir/host/bin/upx" ]; then
  for mf in feeds/*/mihomo/Makefile; do
    [ -f "$mf" ] && sed -i 's|$(STAGING_DIR_HOST)/bin/upx|true|g' "$mf" && echo "patched $mf"
  done
fi
