#!/bin/bash

TARGET_DIR=~/scripts
SWITCH_URL="https://raw.githubusercontent.com/liguilong/jdk-switcher/main/switch_jdk.sh"

# 创建目录
mkdir -p $TARGET_DIR

# 下载最新的 switch_jdk.sh
curl -o $TARGET_DIR/switch_jdk.sh $SWITCH_URL
chmod +x $TARGET_DIR/switch_jdk.sh

# 自动注入 alias + 自动提示 JAVA_HOME
if grep -q "switchjdk" ~/.zshrc; then
    echo "🔔 alias 已存在，跳过添加"
else
    cat <<EOF >> ~/.zshrc

# 👉 自动注入 switchjdk
alias switchjdk='source ~/scripts/switch_jdk.sh'

# 👉 登录时自动提示当前 JDK
if [ -n "\$JAVA_HOME" ]; then
  echo "🎉 当前 JDK: \$(java -version 2>&1 | head -n 1) -> \$JAVA_HOME"
else
  echo "⚠️  当前未设置 JAVA_HOME"
fi
EOF
fi

source ~/.zshrc
echo "✅ 安装完成，直接输入 switchjdk 即可使用！"