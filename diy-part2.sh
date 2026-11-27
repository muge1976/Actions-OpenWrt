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
UPXSRC=""
for c in /usr/bin/upx /usr/bin/upx-ucl /usr/local/bin/upx; do
  [ -x "$c" ] && UPXSRC="$c" && break
done
if [ -n "$UPXSRC" ]; then
  cp -f "$UPXSRC" "$PWD/staging_dir/host/bin/upx"
  chmod +x "$PWD/staging_dir/host/bin/upx"
  echo "upx ready: $("$PWD/staging_dir/host/bin/upx" --version 2>&1 | head -1)"
else
  echo "upx not installed, patching Makefile"
  for mf in feeds/*/mihomo/Makefile; do
    [ -f "$mf" ] && sed -i 's|$(STAGING_DIR_HOST)/bin/upx|true|g' "$mf" && echo "patched $mf"
  done
fi

# 修复：luci-app-mosdns（来自 kenzok8/small）和官方 packages 源的 mosdns 都会装 /etc/init.d/mosdns，安装阶段文件冲突导致整轮编译失败
# 做法：改用 small 源的 mosdns（只装二进制，不装 init.d），与 luci-app-mosdns 的 init.d、配置、界面配套
if [ -e package/feeds/packages/mosdns ]; then
  rm -rf package/feeds/packages/mosdns
  echo "mosdns: removed packages feed link"
fi
if [ ! -e package/feeds/small/mosdns ]; then
  ln -s ../../../feeds/small/mosdns package/feeds/small/mosdns
  echo "mosdns: linked small feed version"
fi
ls -l package/feeds/packages/mosdns package/feeds/small/mosdns 2>/dev/null || true
