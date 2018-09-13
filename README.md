# vscode-vc-demo

在 Visual Studio Code 中使用 VC 编译器编译并调试 C++ 代码。

## 准备

1. 安装 1.22.1 版本以后的 Visual Studio Code 并安装 C/C++ 扩展
2. 安装 Visual Studio 2017 并安装 「使用 C++ 的桌面开发」
3. 添加环境变量 ```VS_ROOT``` ，设置为 Visual Studio 的安装根目录，例如 ```D:\somewhere\Microsoft Visual Studio```

## 用法

* ```F5``` 编译生成 x64 (debug) 并启动调试，可以跟断点
* ```Ctrl + Shift + B``` 编译生成 x64 (release)
* 在 ```/.vscode/settings.json``` 的 ```files``` 中加入编译的源文件
* 在 ```/vcbuild.bat``` 中配置编译和链接选项，具体可参照巨硬文档
