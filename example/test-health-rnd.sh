#!/bin/bash

deployment_name=etcd-rnd

log() {
    echo ""
    echo "$(date +'%Y-%m-%d %H:%M:%S.%3N') - $*"
}


log "test cluster health"

log "etcd/0"
bosh -d ${deployment_name} ssh etcd/0 -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh endpoint health" | grep "stdout"
bosh -d ${deployment_name} ssh etcd/0 -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh member list" | grep "stdout"

log "etcd/1"
bosh -d ${deployment_name} ssh etcd/1 -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh endpoint health" | grep "stdout"
bosh -d ${deployment_name} ssh etcd/1 -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh member list" | grep "stdout"

log "etcd/2"
bosh -d ${deployment_name} ssh etcd/2 -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh endpoint health" | grep "stdout"
bosh -d ${deployment_name} ssh etcd/2 -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh member list" | grep "stdout"


