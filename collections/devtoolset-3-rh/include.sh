export INSTALL_SCLS=devtoolset-3
if [ `os_major_version` -le 6 ] ; then
  export INSTALL_PKGS=devtoolset-3-toolchain
fi
export ENABLE_SCLS=devtoolset-3
