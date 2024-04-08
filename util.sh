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
