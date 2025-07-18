#!/bin/bash

# 设置 example 目录路径
EXAMPLE_DIR="../example"

# 获取当前目录下的所有 .cpp 文件
CPP_FILES=($(find "$EXAMPLE_DIR" -maxdepth 1 -name "*.cpp" -printf "%f\n" | sort))

# 如果没有找到文件，退出
if [ ${#CPP_FILES[@]} -eq 0 ]; then
    echo "当前目录下没有 .cpp 文件"
    exit 1
fi

# 打印编号列表
echo "可用的 .cpp 文件："
for i in "${!CPP_FILES[@]}"; do
    index=$((i+1))
    echo "[$index] ${CPP_FILES[$i]}"
done

# 提示用户选择
read -p "请输入要编译的编号: " SELECTED_INDEX

# 检查输入合法性
if ! [[ "$SELECTED_INDEX" =~ ^[0-9]+$ ]] || [ "$SELECTED_INDEX" -lt 1 ] || [ "$SELECTED_INDEX" -gt "${#CPP_FILES[@]}" ]; then
    echo "无效的编号：$SELECTED_INDEX"
    exit 1
fi

# 获取目标名（去掉扩展名）
FILENAME="${CPP_FILES[$((SELECTED_INDEX-1))]}"
TARGET_NAME="${FILENAME%.cpp}"

echo "开始构建目标: $TARGET_NAME"
echo "路径 $BUILD_DIR"

cmake --build . --target "$TARGET_NAME" install

if [ $? -eq 0 ]; then
    echo "$TARGET_NAME 构建完成..."
    echo -e "是否需要执行？按 [Enter] 执行，按 [Esc] 取消"

    # 读取单个字符（不显示）判断回车或 ESC
    read -s -n 1 key

    if [[ $key == "" ]]; then
        echo "执行 sudo ./bin/$TARGET_NAME"
        sudo "./bin/$TARGET_NAME"
    elif [[ $key == $'\e' ]]; then
        echo "已取消执行"
        exit 0
    else
        echo "未知按键，已取消执行"
        exit 1
    fi
else
    echo "$TARGET_NAME 构建失败"
    exit 1
fi

