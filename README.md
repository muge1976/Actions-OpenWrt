# Actions-OpenWrt（x86_64 在线编译）

本仓库部署自 [bleach1991/Actions-OpenWrt](https://github.com/bleach1991/Actions-OpenWrt)（原模板 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)）。

- 编译源码：`https://github.com/coolsnowwolf/lede`（master 分支）
- 目标平台：`x86/64` 的 `Generic` 通用镜像（可跑物理机、VMware、PVE、ESXi）
- 配置入口：仓库根目录 `.config`（改平台或加插件就改它）
- 自定义脚本：`diy-part1.sh`（更新 feeds 前）、`diy-part2.sh`（生成配置前）

## 怎么编译

1. 打开 `Actions` 页面 → 左侧选 `OpenWrt Builder` → 右侧 `Run workflow` → 分支 `main` → 运行。
2. 任务大约跑 1.5～2 小时。
3. 完成后在 `Releases` 里下载 `openwrt-x86-64-generic-squashfs-combined-efi.img.gz` 等固件；
   或在 Actions 运行详情页底部 `Artifacts` 下载 `OpenWrt_firmware_*` 压缩包。

## 说明

bleach1991 公开的 `lede` 仓库只有 README，不含源码，所以这里按他实际使用的模板路径来编译。
如果需要更接近 BleachWrt 24.10 基线的成品，把 `.github/workflows/openwrt-builder.yml` 里的
`REPO_URL` 改成 `https://github.com/immortalwrt/immortalwrt`、`REPO_BRANCH` 改成 `openwrt-24.10` 即可。

作者：牧歌
