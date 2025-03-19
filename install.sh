#!/bin/bash

TARGET_DIR=~/scripts
SWITCH_URL="https://raw.githubusercontent.com/594373646/jdk-switcher/main/switch_jdk.sh"

# 1. 自动检测 fzf
if ! command -v fzf &> /dev/null; then
    echo "🔍 检测到未安装 fzf，正在自动安装..."
    brew install fzf
else
    echo "✅ fzf 已安装，跳过"
fi

# 2. 下载 switch_jdk.sh
mkdir -p $TARGET_DIR
curl -o $TARGET_DIR/switch_jdk.sh $SWITCH_URL
chmod +x $TARGET_DIR/switch_jdk.sh

# 3. 自动判断 shell 类型
if [[ $SHELL == *"zsh" ]]; then
    SHELL_PROFILE=~/.zshrc
elif [[ $SHELL == *"bash" ]]; then
    SHELL_PROFILE=~/.bash_profile
else
    # 兜底
    SHELL_PROFILE=~/.bash_profile
fi

# 4. 自动注入 alias 和 JAVA_HOME 状态提示
if grep -q "switchjdk" "$SHELL_PROFILE"; then
    echo "🔔 alias 已存在，跳过添加"
else
    cat <<EOF >> "$SHELL_PROFILE"

# 👉 自动注入 switchjdk
alias switchjdk='source ~/scripts/switch_jdk.sh'

# 👉 登录时自动提示当前 JDK
if [ -n "\$JAVA_HOME" ]; then
  echo "🎉 当前 JDK: \$(java -version 2>&1 | head -n 1) -> \$JAVA_HOME"
else
  echo "⚠️  当前未设置 JAVA_HOME"
fi
EOF
    echo "✅ alias 和 JAVA_HOME 提示已写入 $SHELL_PROFILE"
fi

# 5. source 一下
source "$SHELL_PROFILE"

echo "🎉 安装完成！现在直接输入 switchjdk 即可使用！"