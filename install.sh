#!/bin/bash
# Install or uninstall argon one fan control

install_dir='/opt/argon_one_fan_control'
script_files='argon_fan_control.conf argon_fan_control.sh install.sh'
service_dir='/lib/systemd/system/'
service_file='argon_fan_control.service'


usage() {
    cat <<EOF
This script will install the systemd service to ${service_dir}, and all the other files to /opt/argon_one_fan_control
Usage: $0 --install / --uninstall
EOF
    exit 1
}

check_root() {
    if [ $USER != "root" ]; then
        echo "This script needs to be run as root. Exiting."
        exit 2
    fi
}

install() {
    check_root

    echo "Creating ${install_dir}."
    mkdir ${install_dir}

    echo "Copying script files to ${install_dir}"
    cp ${script_files} ${install_dir}

    echo "Installing Service file"
    cp ${service_file} ${service_dir}

    echo "Running 'systemctl daemon-reload' and starting argon_fan_control.service"
    systemctl daemon-reload
    systemctl start argon_fan_control.service

    echo "Done!"
}

uninstall() {
    check_root

    echo "Stopping and removing the service"
    systemctl stop argon_fan_control.service
    rm -f "${service_dir}/${service_file}"
    systemctl daemon-reload

    echo "Removing ${install_dir} and all its files"
    rm -rf ${install_dir}

    echo "Bye Bye."
}


case $1 in
    --install)
        install
    ;;
    --uninstall)
        uninstall
    ;;
    --help|-h)
        usage
    ;;
    *)
        echo "$0 $1 is not valid."
        usage
    ;;
esac

