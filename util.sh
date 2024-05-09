#! /usr/bin/bash

kill_port()
{
    local port="$1"

    if [ ! -n "$1" ];then
        echo "doesnet has any port"
        return 1
    fi

    local pids=$(lsof -ti :$port)

    if [ -z "$pids" ];then
        echo "no any process running in port $port"
    fi

    for pid in $pids;do
        echo "kill process : $pid"
        kill -9 "$pid"
    done
}

allow_port()
{
    if [ $# -eq 0 ]; then
        echo "No ports specified."
        return 1
    fi

    for port in "$@"; do
        ufw allow "$port"
    done

    ufw reload
}

alias net='netstat -nlpt'
alias ip='ifconfig'
alias disk='df -h'
alias mem='free -h'
alias dir='du --max-depth=1 -h'
