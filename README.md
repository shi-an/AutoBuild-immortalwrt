
# 源码地址

- 官方源码：    https://github.com/openwrt/openwrt      

- lede源码：    https://github.com/coolsnowwolf/lede  

- lienol源码：  https://github.com/Lienol/openwrt 

- immortalwrt源码： https://github.com/immortalwrt/immortalwrt


## 使用方法

1. 注册账号

- 点击github.com 网站右上角的【Sign up】按钮，根据要求填写完成即可！


2. 设置权限

- 右上角点击自己的头像，下拉菜单中选择【Settings/设置】 > 【Developer settings/开发者设置】 > 【Personal access tokens/个人访问令牌 > 【Tokens（classic）/令牌（经典）】 > 【 Generate new token/生成新令牌 】 ( Name: GITHUB_TOKEN, Select: public_repo )，其他选项根据自己需要可以多选，提交保存，复制系统生成的加密 KEY 的值，先保存到自己电脑的记事本，下一步会用到这个值。

- 点击右上的 Fork 按钮，复制一份仓库代码到自己的账户下，稍等几秒钟，提示 Fork 完成后，到自己的账户下访问自己仓库里的AutoBuild-OpenWrt 。在右上角的 Settings > Secrets > Actions > New repostiory secret ( Name: TOKEN, Value: 填写刚才GITHUB_TOKEN的值 )，保存。并在左侧导航栏的 Actions > General > Workflow permissions 下选择 Read and write permissions 并保存。


3. 设置config
   
- 修改.config文件。


4. 自定义配置

 - diy-part1.sh文件主要是自定义软件仓库，diy-part2.sh文件主要是个性化配置。

    
   
5. 开始编译
 
 - 点击菜单栏的【Actions】，左边菜单栏选择对应的编译流程，Update Checker为自动更新插件。
 
 
6. 下载固件
 - 编译完成后会自动发布至release，自行前往下载。


 ## 特别感谢

 - [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
 - [xinlingduyu/build-openwrt](https://github.com/xinlingduyu/build-openwrt)
 - [Microsoft Azure](https://azure.microsoft.com)
 - [GitHub Actions](https://github.com/features/actions)
 - [OpenWrt](https://github.com/openwrt/openwrt)
 - [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
 - [Lienol/openwrt](https://github.com/Lienol/openwrt)
 - [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt)
 - [Mikubill/transfer](https://github.com/Mikubill/transfer)
 - [softprops/action-gh-release](https://github.com/softprops/action-gh-release)
 - [Mattraks/delete-workflow-runs](https://github.com/Mattraks/delete-workflow-runs)
 - [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases)
 - [peter-evans/repository-dispatch](https://github.com/peter-evans/repository-dispatch)

  
