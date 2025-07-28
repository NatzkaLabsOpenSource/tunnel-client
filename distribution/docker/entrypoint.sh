#!/bin/bash

config_file=/etc/tunnel-client/config.toml

if [[ ! -f "/etc/tunnel-client/config.toml" ]]; then
  if [[ -n "$TUNNEL_ENDPOINT" ]] && [[ -n "$TUNNEL_TOKEN" ]] && [[ -n "$TUNNEL_SERVICE_NAME" ]] && [[ -n "$TUNNEL_SERVICE_ADDRESS" ]]; then
    config_file=$HOME/config.toml

    echo "[tunnels.tunnel]" >> $config_file
    echo "endpoint = \"$TUNNEL_ENDPOINT\"" >> $config_file
    echo "token = \"$TUNNEL_TOKEN\"" >> $config_file
    echo "[tunnels.tunnel.services.$TUNNEL_SERVICE_NAME]" >> $config_file
    echo "address = \"$TUNNEL_SERVICE_ADDRESS\"" >> $config_file
  else
    echo "WARNING: Neither a configuration file nor environment variables were provided, this will most likely fail!"
  fi
fi

exec tunnel-client -c "$config_file" "$@"
