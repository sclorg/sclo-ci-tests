export INSTALL_SCLS=mariadb55
export ENABLE_SCLS=mariadb55
export SERVICE_NAME=mariadb55-mariadb
[ `os_major_version` -le 6 ] && export SERVICE_NAME=mariadb55-mysqld
