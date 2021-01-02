# GiteePack

一个GiteePremium增量打包工具


## 安装

```shell
$ gem install gitee_pack
```


## 使用

### 打包

在 gitee-premium 目录执行：

```shell
$ gitee_pack BASE HEAD
```

BASE: Commit提交的SHA值作为对比起点

HEAD: Commit提交的SHA值作为对比终点

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
├── run.log            // 打包时的运行日志
├── files              // 用于存放代码文件的目录
└── update.sh          // 部署脚本，更新代码时使用
```

### 更多选项

```
$ gitee_pack --help
Usage: gitee_pack BASE HEAD [options]

Specific options:
        --skip-compile-asset         Skip compile asset.
        --skip-compile-webpack       Skip compile webpack.
        --skip-package-gem           Skip package gem.
    -h, --help                       Show this message.
    -v, --version                    Show version info.
```

`--skip-compile-asset`   当有前端文件改动时，跳过 asset 资源文件编译
`--skip-compile-webpack` 当有 vue 文件改动时，跳过 npm 资源文件编译
`--skip-package-gem`     当有 gem 改动时，跳过 gem 打包

### 部署

在升级包中执行update.sh脚本，一键自动部署

```shell
$ cd upgrade-20200430
$ ./update.sh [gitee-path]
```

gitee-path: gitee-premium 的绝对路径

示例

```shell
$ ./update.sh /home/gite/gitee-premium/gitee
```


## 版本变更

### v1.5.0

- feat: 支持打包完成后，检测包的完整性
- feat: 支持跳过编译流程打包
- feat: 支持新增、修改、删除 Gem 时自动打包
- feat: 支持记录打包日志到升级包中
- fix: 修复打包过程中失败，以非0值推出程序

### v1.4.0

- feat: 支持部署备份代码时过滤 tmp 目录

### v1.3.0

- feat: 支持检测 asset 文件改动并自动编译及打包

### v1.2.0

- feat: 支持部署时代码备份功能
- feat: 打包时记录 Commit 信息
- feat: 支持中文文件名打包（见常见问题）
- fix: 修复部署脚本 Bug

### v1.1.0

- feat: 支持通过脚本自动化部署改动文件

### v1.0.0

- feat: 支持代码文件打包
- feat: 支持检测 webpack 文件改动并自动编译及打包


## 常见问题

1. 执行 `git status`、`git diff` 等命令，中文名文件显示为乱码，导致中文名文件无法打包成功。

```shell
$ git config --global core.quotepath false
```
