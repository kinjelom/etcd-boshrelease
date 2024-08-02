#!/bin/bash

deployment_name=etcd-rnd

log() {
    echo ""
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $*"
}


log "check cluster health"
bosh -d ${deployment_name} ssh etcd -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh endpoint health" | grep "stdout"



export test_key="/test/test-key-$(date +'%Y-%m-%d-%H-%M-%S')"

log "tests using key $test_key"

log "set key to v1, v2, v3 on each node, local endpoint"
bosh -d ${deployment_name} ssh etcd/0 -c "/var/vcap/jobs/etcd/bin/etcdctl.sh put $test_key v1" | grep "stdout"
bosh -d ${deployment_name} ssh etcd/1 -c "/var/vcap/jobs/etcd/bin/etcdctl.sh put $test_key v2" | grep "stdout"
bosh -d ${deployment_name} ssh etcd/2 -c "/var/vcap/jobs/etcd/bin/etcdctl.sh put $test_key v3" | grep "stdout"

log "get key on each node, cluster endpoints"
bosh -d ${deployment_name} ssh etcd -c "/var/vcap/jobs/etcd/bin/etcdctl.sh get $test_key" | grep "stdout"


log "set key to v4 on first node, cluster endpoints"
bosh -d ${deployment_name} ssh etcd/0 -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh put $test_key v4" | grep "stdout"

log "get key on each node, cluster endpoints"
bosh -d ${deployment_name} ssh etcd -c "/var/vcap/jobs/etcd/bin/etcdctl.sh get $test_key" | grep "stdout"


log "set key to v5 on each node, cluster endpoints"
bosh -d ${deployment_name} ssh etcd -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh put $test_key v5" | grep "stdout"

log "get key on each node, cluster endpoints"
bosh -d ${deployment_name} ssh etcd -c "/var/vcap/jobs/etcd/bin/etcdctl.sh get $test_key" | grep "stdout"


log "delete key on first node, cluster endpoints"
bosh -d ${deployment_name} ssh etcd/0 -c "CTL_MODE=cluster /var/vcap/jobs/etcd/bin/etcdctl.sh del $test_key" | grep "stdout"


