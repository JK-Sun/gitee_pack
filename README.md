# GiteePack

一个GiteePremium增量打包工具

## 安装

在gitee-premium目录执行：

```shell
$ gem install gitee_pack
```

## 使用

### 打包

在gitee-premium目录执行：

```shell
$ gitee_pack [base] [head]
```

base: Commit提交的SHA值作为对比起点

head: Commit提交的SHA值作为对比终点

示例：

```shell
$ gitee_pack a9b6296 6ac0f97
```

执行后会在当前目录下生成一个增量文件的升级包，例如 upgrade-20200430

### 部署

先备份原有文件

在升级包中执行update.sh脚本，一键自动部署

```shell
$ cd upgrade-20200430
$ ./update.sh [gitee-path]
```

gitee-path: gitee-premium的绝对路径

示例

```shell
$ ./update.sh /home/gite/gitee-premium/gitee
```

