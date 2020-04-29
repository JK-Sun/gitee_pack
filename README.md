# GiteePack

一个GiteePremium增量打包工具

## 安装

在gitee-premium目录执行：

    $ gem install gitee_pack

## 使用

在gitee-premium目录执行：

```
$ gitee_pack [base] [head]
```

base: Commit提交的SHA值作为对比起点

head: Commit提交的SHA值作为对比终点

示例：

```
$ gitee_pack a9b6296 6ac0f97
```

