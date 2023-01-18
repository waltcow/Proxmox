#!/usr/bin/env bash
function header_info {
    cat <<"EOF"
       _  _                       _       _
      | |(_)                     | |     (_)
 _____| | _ _   _ _   _ ____   __| | ____ _ _   _ _____
(____ | || | | | | | | |  _ \ / _  |/ ___) | | | | ___ |
/ ___ | || | |_| | |_| | | | ( (_| | |   | |\ V /| ____|
\_____|\_)_|\__  |____/|_| |_|\____|_|   |_| \_/ |_____)
           (____/

EOF
}
IP=$(hostname -I | awk '{print $1}')
YW=$(echo "\033[33m"):q

BL=$(echo "\033[36m")
RD=$(echo "\033[01;31m")
BGN=$(echo "\033[4;92m")
GN=$(echo "\033[1;92m")
DGN=$(echo "\033[32m")
CL=$(echo "\033[m")
BFR="\\r\\033[K"
HOLD="-"
CM="${GN}✓${CL}"
APP="AliyunDriveFuse"
hostname="$(hostname)"
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
shopt -s expand_aliases
alias die='EXIT=$? LINE=$LINENO error_exit'
trap die ERR

function error_exit() {
    trap - ERR
    local reason="Unknown failure occured."
    local msg="${1:-$reason}"
    local flag="${RD}‼ ERROR ${CL}$EXIT@$LINE"
    echo -e "$flag $msg" 1>&2
    exit $EXIT
}
clear
header_info
while true; do
    read -p "This will Install ${APP} on $hostname. Proceed(y/n)?" yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) exit ;;
    *) echo "Please answer yes or no." ;;
    esac
done
clear
header_info
function msg_info() {
    local msg="$1"
    echo -ne " ${HOLD} ${YW}${msg}..."
}

function msg_ok() {
    local msg="$1"
    echo -e "${BFR} ${CM} ${GN}${msg}${CL}"
}

msg_info "Installing ${APP}"

echo -en "${GN} Downloading AliyunDriveFuse... "
wget https://github.com/messense/aliyundrive-fuse/releases/download/v0.1.14/aliyundrive-fuse_0.1.14_amd64.deb &>/dev/null
echo -e "${CM}${CL} \r"

echo -en "${GN} Installing  AliyunDriveFuse... "
apt udpate
apt install fuse3 -y
dpkg --install aliyundrive-fuse_0.1.14_amd64.deb &>/dev/null
echo -e "${CM}${CL} \r"

msg_ok "Installed ${APP} on $hostname"

msg_ok "Completed Successfully!\n"
