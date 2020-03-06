---
# 名称
title: npm,看这篇就够了
top: true
cover: true
toc: true
mathjax: true
img:
date: 2020-02-29 21:12:27
keywords: "npm package.json  组件发布"
tags: 
    - npm
    - 前端
categories: 
    - npm
    - 前端

summary: npm 相关 package.json 组件开发及发布

---

## 前言

最近在研究  `npm` 组件发布，碰到一些相关问题，算是整理一下。

### 涉及内容

- package.json 文件介绍
- .npmrc 的作用及配置
- 公网 npm 组件发布

## package.json

### 概述

package.json 定义了当前项目中 `npm包` 之间的依赖关系和项目的一些配置信息（项目名称，版本，描述，开发人，许可证 等等）。

当说到包管理器，就会遇到 `yarn` 和 `npm` 的选择性问题。我是喜欢用 `yarn`
的，看看 `github` 上的开源项目，比如 `vue` 项目下就有 `yarn.lock` 文件，由此我猜测 `yarn` 可能更受欢迎一些，日常使用中我也是 `yarn` 用的比较多。 

当我们 `npm install` 或 `yarn install` 会根据项目下的 `package.json` 解析依赖包之间的依赖关系然后从配置的 `npm registry` （ `.npmrc` 可以配置对应的 `registry`）地址中搜索并下载包。

我们可以在 `yarn.lock` 或 `package-lock.json` 看到包从哪里下载和依赖关系。

提交代码的时候排除 `node_modules` 目录，但是要提交 `yarn.lock` 或 `package-lock.json` ,用于锁定项目依赖包的版本。并且升级包的时候不要手动改 `package.json` 中的版本号，要使用命令 `yarn upgrade` 或 `npm upgrade ` 升级。

`npm init` 或 `yarn init` 可以生成 package.json。

```json
{
    "name": "@mflyyou/npm-description",
    "version": "0.1.0",
    "private": true,
    "author": "张攀钦",
    "license": "MIT",
    "main":"index.js",
    "keywords": [
        "npm 搜索关键词"
    ],
    "publishConfig": {
        "registry": "https://registry.npmjs.com/"
    },
    "repository": {
        "type": "git",
        "url": "http://git.com/项目git地址"
    },
    "files": [
        "dist",
        "src"
    ],
    "bugs": {
        "url": "http://localhost:8080//issues",
        "email": "bug@example.com"
    },
    "contributors": [
        {
            "name": "zhangpanqin",
            "email": "zhangpanqin@email.com"
        }
    ],
    "scripts": {
        "dev": "sh ./build/build.sh",
        "npm-version": "npm -v",
        "serve": "vue-cli-service serve"
    },
    "dependencies": {
        "vue": "^2.5.21"
    },
    "devDependencies": {
        "@vue/cli-plugin-babel": "^3.3.0"
    },
    "peerDependencies":{}
}

```

### package.json 字段介绍

#### name

`name` 字段作为项目的名称。 比如 vue 中的一个组件 `@vue/cli-plugin-babel` ，前面这个 `@vue` 其实就当前包的 scope ，既命名空间。我们可以根据 `scope` 配置一些私有包 `registry`，从而达到一些包来源于特定的地址。

```txt
registry=https://registry.npm.taobao.org/
@pay-plugin:registry=https://npm.udolphin.com
```

#### version

```bash
npm version [<newversion> | major | minor | patch | premajor | preminor | prepatch | prerelease [--preid=<prerelease-id>] | from-git]

'npm [-v | --version]' to print npm version
'npm view <pkg> version' to view a package's published version
'npm ls' to inspect current package/dependency versions
```

 "version": "0.1.0”, 对应 `major-minor-patch` 

```bash
# 更新 major 的位置，其余位置为 0
npm version major 

# 更新 minor 的位置，major 不变，其余位置为 0
npm version minor 

# 更新 patch 的位置，其余位置不变
npm version patch 
```

- major 对应一次大的迭代，比如 vue 3.0 ts 重新，添加新的功能，更新 major 版本号
- minor 对应小版本迭代，发生兼容旧版API的修改或功能添加时，更新 minor 版本号
- patch 对应修订版本号，一般针对 bug 修复时，修改 patch 的版本号

当你的项目需要发布的时候，version 一定要和以前的不一样，否则发布不成功。

#### private

标识当前包是否私有，为 `true` 时包不能发布。

#### main

默认 index.js。指定 import 或 require 的时候加载的 js。

#### keywords

描述当前项目的关键字，用于检索当前插件。

#### publishConfig

```js
"publishConfig": {
    "registry": "https://registry.npmjs.com/"
}
```

有的时候呢我们在 `.npmrc` 配置了别的 `registry` ，比如淘宝镜像。我安装依赖包的时候呢，想从淘宝镜像安装。发布插件的时候想发布到官网上。就可以在 `publishConfig` 中配置了。 



#### files

指定发布的依赖包，包含的文件，默认会忽略一些文件。也可以根目录下创建 .npmignore 忽略一些文件。

![](http://oss.mflyyou.cn/blog/20200304021818.png)

#### scripts

配置一些执行脚本。比如说 `npm run dev` 就是运行 `sh ./build/build.sh`。

```js
"scripts": {
    // 运行 shell 脚本
	"dev": "sh ./build/build.sh",
	"build": "npm -v",
    // build 成功之后会执行 publish    
	"pub": "npm run build && npm publish"
}
```

#### dependencies

项目的开发依赖。key 为模块名称，value 为版本范围。项目打包时会将这里的依赖打包进去。

[fly-npm 地址](https://github.com/wanguzhang/fly-npm)

fly-npm 和 fly-use-npm 已发布。

注意，这里也有个坑。比如我有两个插件 fly-npm，fly-use-npm，fly-use-npm 中 dependencies 中依赖 fly-npm。我在 my-vue 项目开发的时候引入 fly-use-npm。我是可以直接 `import fly-use-npm` 项目可以正常运行。但是当你 `import fly-npm`  项目解析依赖会报错。因为只有在当前项目中 dependencies 引入的依赖才可以被 import。

```js
<template>
    <div>
        <button @click="clickTest">
            测试
        </button>
    </div>
</template>
<script>
// fly-npm 只有在当前 my-vue 项目 dependencies 引入才可以被 import
//import flyNpm from 'fly-npm';    
import flyUseNpm from 'fly-use-npm';

export default {
    name: 'TestPlugin',
    methods: {
        clickTest() {
            flyUseNpm();
        },
    },
};
</script>


```



#### devDependencies

为开发依赖，打包的时候不会打包进去。比如我们使用的 `babel` `webpak` 等相关的插件，打包的时候，并不会被打包进去。

#### peerDependencies

在将这个之前，我们先来了解 npm 的树形依赖是什么意思。

我创建一个 vue 项目 my-vue 依赖 fly-use-npm(它依赖 fly-npm 1.0.0)，fly-npm(2.0.0)，在我们项目中可以看到。


当 `my-vue` 没有引入 `fly-npm 2.0.0` 的时候，`my-vue/node_modules/fly-npm` 为 1.0.0。


![](http://oss.mflyyou.cn/blog/20200304021831.png)

当我们引入 `fly-npm 2.0.0` 的时候，依赖关系图如上图，这就是树形依赖。

下面是测试引入 `fly-npm 2.0.0` 之后的变化。

```js
<template>
    <div>
        <button @click="clickTest">
            测试
        </button>
    </div>
</template>
<script>
import flyUseNpm from 'fly-use-npm';
import flyNpm from 'fly-npm';

export default {
    name: 'TestPlugin',
    methods: {
        clickTest() {
            // 打印 2.0.0
            console.log('fly-npm', flyNpm);
            // 使用的是 1.0.0
            flyUseNpm();
        },
    },
};
</script>

```

从上面我们可以看到，一个项目存在了两份 fly-npm 的包。这样打包的体积相应也会增大。为了解决这个问题，引入了 `peerDependencies` 。

创建 vue 项目 my-vue，依赖 fly-use-npm(4.0.0,其 `peerDependencies` 是 fly-npm 1.0.0 )。

`peerDependencies`  添加的依赖包，不会（测试的 yarn 1.22.0，npm 6.13.7）自动安装的。

当我在 my-vue 项目 `yarn install` 的时候，由于没有引入 `fly-npm` 会报错。

当我在项目中引入 `fly-npm 2.0.0` 安装会在当前项目下，出现警告信息。

> warning " > fly-use-npm@4.0.0" has incorrect peer dependency "fly-npm@1.0.0”。

当你开发一个组件，依赖特定包的版本就需要这样处理。

```js
// fly-use-npm
import flyNpm from 'fly-npm';
const obj = () => {
    console.log('引用的 fly-npm 版本为:', flyNpm.version);
    if (flyNpm.version > 1) {
        throw new Error('版本大于 1');
    }
}
export default obj;
```

算是场景模拟，fly-npm 最新包是 2.0.0，这算是一个重大版本升级，可能存在不兼容 1.0.0 的东西。所以我在 fly-use-npm 推荐使用（peerDependencies）1.0.0。当我在实际用的时候呢，引入 fly-npm 2.0.0 ,发现某个功能依赖 fly-npm 2.0.0 报错了，就需要想到是不是依赖包不兼容的问题了。

但是同时你还想用 fly-npm 2.0.0 的功能，那你只能去提交一个 pr 兼容 fly-npm 或者 fly-use-npm 。

这种情况很少会遇到，一般版本升级都会兼容以前的功能的，也不用太在意这样的问题。

一般我们很少会遇到这种问题。`github` 上流行的库也很少会用到 `peerDependencies`。

## .npmrc



`package.json` 中的依赖包从哪里安装呢？.npmrc 可以配置依赖包从哪里安装，也可以配置 npm 的一些别的配置。

### .npmrc 配置文件优先级

- 项目配置文件: `/project/.npmrc`
- 用户配置文件：`~/.npmrc`
- 全局配置文件：`/usr/local/etc/npmrc`
- npm 内置配置文件 `/path/to/npm/npmrc`



```bash
# 获取 .npmrc 用户配置文件路径
npm config get userconfig
```



项目下 .npmrc 文件的优先级最高，可以每个项目配置不同的镜像，项目之间的配置互不影响。我们也可以指定特殊的命名空间（scope）的来源。

以`@thingjs-plugin` 开头的包从 `registry=https://npm.udolphin.com` 这里下载，其余全去淘宝镜像下载。

```txt
registry=https://registry.npm.taobao.org/
@thingjs-plugin:registry=https://npm.udolphin.com
```

```txt
npm config set <key> <value> [-g|--global]  //给配置参数key设置值为value；
npm config get <key>                        //获取配置参数key的值；
npm config delete <key>  [-g|--global]      //删除置参数key及其值；
npm config list [-l]                		//显示npm的所有配置参数的信息；
npm config edit                     		//编辑用户配置文件
npm get <key>                           	//获取配置参数 key 生效的值；
npm set <key> <value> [-g|--global]         //给配置参数key设置值为value；
```

没有加 -g 配置的是用户配置文件

-g 会配置到全局配置文件

## npm 组件发布流程

- 去 npm 官网申请账号
- 添加账号到你电脑
- 开发你的组件，使用 webpack,babel 处理
- npm 发布你的包

### 申请账号

[官网](https://www.npmjs.com/)申请一个账号，用于登录和发布组件。

在项目的根路径下创建 `.npmrc` 配置文件，添加如下内容。

```txt
# 安装包的时候，配置阿里镜像
registry = https://registry.npm.taobao.org
```

在 `package.json` 中配置发布源。

```json
"publishConfig": {
    "registry": "https://registry.npmjs.com/"
}
```

这样下载依赖包会从淘宝镜像下载，发布依赖包会发布到 npm 官网去。



### 添加账号到你电脑

 [添加账号命令官网说明 npm adduser](https://docs.npmjs.com/cli/adduser)

```
# npm adduser [--registry=url] [--scope=@orgname] [--always-auth] [--auth-type=legacy]

npm adduser  --registry=https://registry.npmjs.com/
```

运行上述命令，.npmrc 用户配置文件生成一下内容

```
registry=https://registry.npmjs.com/
//registry.npmjs.com/:_authToken=xxx
```


### 开发你的组件，使用 webpack,babel 处理

由于 webpack,babel 配置比较麻烦，这里使用 [vue-cli](https://cli.vuejs.org/zh/) 脚手架进行开发

#### package.json 

```json
{
    "name": "@thingjs-ad/thingjs-app",
    "version": "0.1.1",
    "private": false,
    "scripts": {
        "serve": "vue-cli-service serve",
        "build": "vue-cli-service build --target lib --name thingjs-app ./src/index.js",
        "lint": "vue-cli-service lint",
        "pub": "npm run build && npm publish --access=public"
    },
    "main": "dist/thingjs-app.umd.min.js",
    "files": [
        "src",
        "dist"
    ],
    "devDependencies": {
        "@vue/cli-plugin-babel": "^4.2.0",
        "@vue/cli-plugin-eslint": "^4.2.0",
        "@vue/cli-service": "^4.2.0",
        "babel-eslint": "^10.0.3",
        "eslint": "^6.7.2",
        "eslint-plugin-vue": "^6.1.2",
        "vue-template-compiler": "^2.6.11"
    },
    "eslintConfig": {
        "root": true,
        "env": {
            "node": true
        },
        "extends": [
            "plugin:vue/essential",
            "eslint:recommended"
        ],
        "parserOptions": {
            "parser": "babel-eslint"
        },
        "rules": {}
    },
    "browserslist": [
        "> 1%",
        "last 2 versions"
    ]
}
```



#### 组件内容

![](http://oss.mflyyou.cn/blog/20200304021841.png)

- AA.vue 

```
<template>
     <div>
         AA 组件
     </div>
</template>
<script>
export default {
    name:'AA'
};
</script>
```

- index.js

```
import AA from './components/AA.vue';

const components = [AA];


// 当调用 Vue.use,实际会调用这个 install 方法。Vue.component 注册全局组件。

const install = function (Vue) {
    components.forEach(component => {
        Vue.component(component.name, component);
    });
};

if (typeof window !== 'undefined' && window.Vue) {
    install(window.Vue);
}

export default {
    version: '1.0.0',
    install,
    AA
}
```

### 发布组件

```bash
npm publish --access=public
```


