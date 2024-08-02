# ETCD BOSH Release

Bosh deployment for an ETCD cluster, forked from `cloudfoundry-incubator/cfcr-etcd-release`.

Support for:
- Cluster bootstrap after a complete shutdown: `bosh -d etcd-rnd stop; bosh -d etcd-rnd start`
- Backup and restore using BBR (data backup from the cluster leader): [`test-bbr-rnd.sh`](example/test-bbr-rnd.sh) 
- RBAC recreation on post-deploy: [example-rbac-config.yml](example/manifests/ops/example-rbac-config.yml) 
- Flexible ETCD server configuration: [example-server-config.yml](example/manifests/ops/example-server-config.yml)

See [more examples](example).

