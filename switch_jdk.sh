#!/bin/bash

MEMO_FILE=~/.jdk_switcher_last

if ! command -v fzf &> /dev/null; then
    echo "⚠️  需要安装 fzf 工具，请先运行: brew install fzf"
    exit 1
fi

jdk_list=$(/usr/libexec/java_home -V 2>&1 | grep -E '[0-9]+\.[0-9]+\.[0-9]+' | awk '{print $1 " " $(NF)}')

if [ -z "$jdk_list" ]; then
  echo "❌ 没有找到任何已安装的 JDK！"
  exit 1
fi

if [ -f "$MEMO_FILE" ]; then
  last_selected=$(cat "$MEMO_FILE")
else
  last_selected=""
fi

selected=$(echo "$jdk_list" | fzf --prompt="请选择要切换的 JDK: " --height=10 --tac --select-1 --query="$last_selected")

if [ -n "$selected" ]; then
  path=$(echo "$selected" | awk '{print $2}')
  version=$(echo "$selected" | awk '{print $1}')
  export JAVA_HOME="$path"
  export PATH="$JAVA_HOME/bin:$PATH"
  echo "$version" > "$MEMO_FILE"
  echo "✅ 已切换到: $JAVA_HOME"
  java -version
else
  echo "❌ 未选择任何版本，已取消切换。"
fi