#!/bin/bash

BASE_DIR=$(dirname "$(realpath "$0")") #"
deployment_name=etcd-rnd

bosh -d ${deployment_name} deploy "$BASE_DIR/manifests/etcd.yml" \
  -v deployment_name="${deployment_name}" \
  -o "$BASE_DIR/manifests/ops/example-rbac-config.yml" \
  -o "$BASE_DIR/manifests/ops/example-server-config.yml" \
  -o "$BASE_DIR/manifests/ops/enable-bbr-etcd.yml" \
  --vars-file="$BASE_DIR/vars/${deployment_name}-vars.yml" \
  --no-redact --fix

