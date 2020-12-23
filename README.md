# GiteePack

一个GiteePremium增量打包工具

## 安装

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

升级包目录结构说明：

```
upgrade-20200430
├── commit.txt         // 记录 base、head 的 CommitID
├── diff.txt           // 记录 base 和 head 之间的所有改动文件名称
├── delete.txt         // 记录 base 和 head 之间被删除的文件名称
├── files              // 用于存放代码文件的目录
└── update.sh          // 部署脚本，更新代码时使用
```

### 更多选项

```
$ gitee_pack --help
Usage: gitee_pack BASE HEAD [options]

Specific options:
    -S, --skip-compile COMPILE_TYPE  Skip compile. aption: all, asset or webpack.
    -h, --help                       Show this message.
    -v, --version                    Show version info.
```

### 部署

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

## 功能

### 已支持

- 支持代码文件打包
- 支持检测 webpack 文件改动并自动编译及打包
- 支持部署时代码备份功能
- 支持检测 asset 文件改动并自动编译及打包
- 支持中文文件名打包（见常见问题）
- 支持部署备份代码时过滤 tmp 目录
- 修复打包过程中失败，以非0值推出程序
- 打包完成后，检测包的完整性
- 支持跳过编译流程打包

### 待支持

- 新增、修改、删除 Gem 时自动打包

## 常见问题

1. 执行 `git status`、`git diff` 等命令，中文名文件显示为乱码，导致中文名文件无法打包成功。

```shell
$ git config --global core.quotepath false
```

