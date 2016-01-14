h=$(head -n 1 host)

cat > ssh_config << EOF
UserKnownHostsFile /dev/null
StrictHostKeyChecking no
User root
ConnectTimeout 10

Host host
  Hostname ${h}.ci.centos.org
EOF
