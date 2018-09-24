if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

function resize() {
    if [[ -t 0 && $# -eq 0 ]];then
        local IFS='[;' escape geometry x y
        echo -ne '\e7\e[r\e[999;999H\e[6n\e8'
        read -sd R escape geometry
        x=${geometry##*;} y=${geometry%%;*}
        if [[ ${COLUMNS} -eq ${x} && ${LINES} -eq ${y} ]]; then
            echo "${TERM} ${x}x${y}"
        elif [[ 1 -eq ${x} && 1 -eq ${y} ]]; then
            echo 'Warning: unable to determine window size, falling back to 80x25. You may set the size manually with "stty cols $x rows $y"'
            stty cols 80 rows 25
        else
            echo "Resizing local terminal: ${COLUMNS}x${LINES} -> ${x}x${y}"
            stty cols ${x} rows ${y}
        fi
    else
        print 'Usage: resize'
    fi
}

export PS1='$ '
resize

echo "Connected to buildcontainer ${HOSTNAME} on ${NODE_NAME} for job ${BUILD_URL} from $(netstat -pn 2>/dev/null | grep ${SOCAT_PID}/socat | awk '{print $5}')"
echo "Building commit ${GIT_COMMIT} on branch ${GIT_BRANCH} originating from ${GIT_URL}"
echo -e "Hello :)\n"