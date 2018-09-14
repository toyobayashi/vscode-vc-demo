# vscode-vc-demo

在 Visual Studio Code 中使用 VC 编译器编译并调试 C++ 代码。

## 准备

1. 安装 1.22.1 版本以后的 Visual Studio Code 并安装 C/C++ 扩展
2. 安装 Visual Studio 2017 并安装 「使用 C++ 的桌面开发」。如果开发 Node.js 原生模块则需要安装对应架构的 Node.js 及其头文件到 ```${env.HOME}/.node-gyp/${config:nodeVersion}```
3. 添加环境变量 ```VS_ROOT``` ，设置为 Visual Studio 的安装根目录，例如 ```D:\somewhere\Microsoft Visual Studio```
4. 添加环境变量 ```HOME``` ，设置为系统用户根目录，例如 ```C:\Users\Administrator```

## 用法

* 使用 Visual Studio Code 打开 ```/console``` （用于开发控制台应用）或 ```/node``` （用于开发 Node.js 原生模块）文件夹
* 在 ```/${'console' | 'node'}/.vscode/settings.json``` 的配置 ```targetName``` （目标文件名）和 ```sources```  （编译源文件）， ```nodeVersion``` 选项（可选）用于寻找 Node.js 或 Electron 的头文件，例如 ```8.12.0```、 ```iojs-2.0.9```
* 在 ```/${'console' | 'node'}/vcbuild.bat``` 中配置编译和链接选项，具体可参照[巨硬文档](https://docs.microsoft.com/zh-cn/cpp/build/reference/c-cpp-building-reference)
* ```F5``` 编译生成 x64 (debug) 并启动调试，可以跟断点
* ```Ctrl + Shift + B``` 编译生成 x64 (release)

**注意**：调试 Node.js 32 位的原生模块时需要使用 32 位的 ```node.exe```。
