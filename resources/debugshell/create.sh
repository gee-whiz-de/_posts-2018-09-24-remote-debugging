#!/usr/bin/bash -e

FRPC_CONFIG=$(mktemp)

function get_unused_port() {
    python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()'
}

function configure_frpc() {
    local_port=$(get_unused_port)
    admin_port=$(get_unused_port)
    username=$(hostname)-${local_port}

    sed -e "s|^user = .*$|user = ${username}|g" \
        -e "s|^local_port = .*$|local_port = ${local_port}|g" \
        -e "s|^admin_port = .*$|admin_port = ${admin_port}|g" \
        /etc/frp/frpc.ini > ${FRPC_CONFIG}
}

function run_frpc() {
    frpc -c ${FRPC_CONFIG} &
    sleep 1

    external_endpoint=$(frpc status -c ${FRPC_CONFIG} | grep shell | awk '{print $4}')
    local_port=$(grep local_port ${FRPC_CONFIG} | awk '{print $NF}')

    echo -e "\033[38;5;208m"
    echo "------------------------------"
    echo "Reverse connection endpoint to localhost:${local_port} created on: ${external_endpoint}"
    echo "Connect via: socat file:\$(tty),raw,echo=0,escape=0x0f tcp:${external_endpoint}"
}

function execute_socat() {
    local_port=$(grep local_port ${FRPC_CONFIG} | awk '{print $NF}')
    socat exec:'bash --rcfile /tmp/debugshell/bashrc.sh -i',pty,stderr,setsid,sigint,sane tcp-listen:${local_port}
}

function run_socat() {
    if [ "${HALT_EXECUTION}" = "true" ]; then
        echo "Listening for incoming connection and pausing execution until connection terminates"
        echo "------------------------------"
        echo -e "\033[0m"
        execute_socat
    else
        echo "Listening for incoming connection in the background and continue execution"
        echo "------------------------------"
        echo -e "\033[0m"
        execute_socat &
    fi
}

configure_frpc
run_frpc
run_socat
