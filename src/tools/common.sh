log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S.%3N') - $*"
}

log_stderr() {
    echo "$(date +'%Y-%m-%d %H:%M:%S.%3N') - $*" >&2
}

jq() {
  /var/vcap/packages/tools/bin/jq "$@"
}

yq() {
  /var/vcap/packages/tools/bin/yq "$@"
}

assert_declared_functions() {
  for func in "$@"; do
    if ! declare -f "$func" > /dev/null; then
      echo "Error: function $func is not declared!"
      exit 1
    fi
  done
}

assert_declared_variables() {
  for var in "$@"; do
    if [ -z "${!var+x}" ]; then
      echo "Error: variable $var is not declared!"
      exit 1
    fi
  done
}

assert_non_empty_variables() {
  # set -u
  for var in "$@"; do
    if [ -z "${!var:-}" ]; then
      echo "Error: variable $var is empty!"
      # set +u
      exit 1
    fi
  done
  # set +u
}

