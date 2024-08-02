#!/bin/bash -eu

export deployment_name=etcd-rnd
export temp_dir=.temp

echo "A backup and restore operation will be performed on deployment ${deployment_name}! Please confirm by typing 'Y':"
read -r confirmation
if [ "$confirmation" != "Y" ]; then
    echo "Operation cancelled."
    exit 1
fi

log() {
    echo -e "\n======"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $*"
}

mkdir -p "$temp_dir"

log "check cluster health"
bosh -d ${deployment_name} ssh etcd -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh endpoint health" | grep "stdout"


export test_key
test_key="/test/bbr-key-$(date +'%Y-%m-%d-%H-%M-%S')"

log "saving before-backup data, key $test_key"
bosh -d "$deployment_name" ssh etcd/0 -c "/var/vcap/jobs/etcd/bin/etcdctl.sh put $test_key before-backup"

log "backup, dir $temp_dir"
bbr deployment -d "$deployment_name" backup --with-manifest -a "$temp_dir"


log "saving after-backup data, key $test_key"
bosh -d "$deployment_name" ssh etcd/0 -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh put $test_key after-backup"

backup_dir=$(find "$temp_dir" -maxdepth 1 -name "${deployment_name}_*" 2>/dev/null | sort | tail -n 1)
log "restore, dir: $backup_dir"
bbr deployment -d "$deployment_name" restore -a "$backup_dir"

log "checking cluster health"
bosh -d "$deployment_name" ssh etcd -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh endpoint health" | grep "stdout"

log "reading value of the key $test_key"
bosh -d "$deployment_name" ssh etcd/0 -c "/var/vcap/jobs/etcd/bin/etcdctl.sh get $test_key" | grep "stdout"
