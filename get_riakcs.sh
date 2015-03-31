#!/bin/bash

## Install script for riak

default_node_count=5
default_tmpdir="/tmp"
default_install_path="/opt"


function print_help(){
    cat <<EOF
Usage: $0 [-v <ver>] [-r <rel>] [-t <tmp>] [-i <inst>] [-h]
    Where:
        -n <node_count> - number of nodes to expect
        -t <tmp> - temp dir to use ( /tmp/ is default )
        -i <inst> - get_riakcs install dir ( /opt/get_riakcs is default )
        -h - this help screen

############################################################

Typical usage:

    curl https://raw.githubusercontent.com/glickbot/get_riakcs/master/get_riakcs.sh | bash

    curl https://raw.githubusercontent.com/glickbot/get_riakcs/master/get_riakcs.sh | <option>=<value> bash

    Where <option>=<value> can be:
        node_count=5
        tmpdir="/other/dir"
        install_path="/other/path"
EOF
}

function download(){
    echo "Downloading $1"
    echo "Saving to $2"
    if [ -f $2 ]; then
        echo "File already exists at $2, skipping download"
    elif which curl >/dev/null 2>&1; then
        curl $1 -o $2;
    elif which wget >/dev/null 2>&1; then
        wget -O $2 $1;
    else
        echo "Unable to find curl or wget, exiting"
        exit 1
    fi

    if [ ! -f "${tmpdir}/${file}" ]; then
        "There was an error downloading ${file} to ${tmpdir}"
        exit 1
    fi
}


while getopts n: opt; do
    case "$opt" in
        n) node_count="$OPTARG";;
        h) print_help && exit 0;;
       \?) print_help && exit 1;;
    esac
done

[ -z $node_count ] && node_count=$default_node_count

UNAME=$(uname);
case $(uname -m|tr '[:upper:]' '[:lower:]') in
    x86_64)
        ARCH="x86_64"
        ;;
    *)
        ARCH="i386"
esac

if [ "${UNAME}" == "Darwin" ]; then
    OS="osx"
elif [ "${UNAME}" == "SunOS" ]; then
    OS="solaris"
elif [ "${UNAME}" == "Linux" ]; then
    if [ -f "/etc/lsb-release" ]; then
        OS=$(grep DISTRIB_ID /etc/lsb-release | cut -d "=" -f 2 | tr '[:upper:]' '[:lower:]');
        ARCH=$(echo $ARCH|sed 's/x86_/amd/')
    elif [ -f "/etc/debian_version" ]; then
        OS="debian";
        ARCH=$(echo $ARCH|sed 's/x86_/amd/')
    elif [ -f "/etc/redhat-release" ]; then
        OS=$(sed 's/^\(.\+\) release.*/\1/' /etc/redhat-release | tr '[:upper:]' '[:lower:]')
        if [ "${OS}" = "centos" ]; then
            OS="redhat"
        fi
        REL=$(sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release | cut -d "." -f 1)
    elif [ -f "/etc/system-release" ]; then
        if grep -i "amazon linux ami" /etc/system-release 1>/dev/null 2>&1; then
            OS="redhat"
            REL="6"
        else
            OS=$(sed 's/^\(.\+\) release.\+/\1/' /etc/system-release | tr '[:upper:]' '[:lower:]')
        fi
    fi
fi

if [ -z $OS ]; then
    echo "Unable to identify Operating System"
    exit 1
fi

majver=$(echo $version | cut -d "." -f 1,2)

url="http://ps.basho.s3.amazonaws.com/get_riakcs/"
case "${OS}" in
    osx)
        echo "OSX isn't supported yet"
        exit 1
        ;;
    solaris)
        echo "Solaris isn't supported yet"
        exit 1
        ;;
    ubuntu)
        method="deb"
        echo "Ubuntu isn't supported yet"
        exit 1
        # file="riak_${version}-${relnum}_${ARCH}.deb"
        # if ! dpkg -s libssl0.9.8 > /dev/null 2>&1; then
        #     echo "Installing dependency: libssl0.9.8"
        #     apt-get install -y libssl0.9.8
        # fi
        ;;
    debian)
        echo "Debian isn't supported yet"
        exit 1
        # method="deb"
        # file="riak_${version}-${relnum}_${ARCH}.deb"
        ;;
    fedora)
        method="yum"
        echo "Fedora hasn't been tested yet"
        exit 1
        ;;
    redhat)
        method="yum"
        case "${REL}" in
          6)
            file="get_riakcs-v0.01-centos6.tar.gz"
            ;;
          *)
            echo "Unhandled Centos Release: ${REL}"
            exit 1
        esac
	;;
    *)
        echo "Unhandled OS type"
        exit 1
esac

download "${url}/${file}" "${tmpdir}/${file}";
tar -xzf "${tmpdir}/${file}" -C "${install_path}"
rm -f "${tmpdir}/${file}"
cd ${install_path}/get_riakcs
./install.sh
