# ConvTool
Some easy-to-use scripts

- compile_run.sh
  - 功能：放在项目的Build文件夹内可以自动扫描上级目录example内的.cpp文件，并使用指令`cmake --build . --target <filename> install`执行编译和安装，以及询问是否在编译后执行
  - 用法：执行`./compile_run.sh` -> 输入扫描到的文件数字编号