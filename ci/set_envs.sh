#!/bin/bash
# This script is reads the current ENV environment variable value and injects
# the corresponding parameter values to the template.yaml before `sam deploy`

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd "$parent_path"

if [ -z "$ENV" ]; then
  echo "Error: ENV environment variable not set"
  exit 1
fi

env_file=".env.$ENV"

if [ ! -f "$env_file" ]; then
  echo "Error: $env_file not found"
  exit 1
fi

parameter_overrides="--parameter-overrides"

while IFS='=' read -r key value || [[ -n "$key" ]]; do
  parameter_overrides+=" $key=$value"
done < "$env_file"

echo "Running 'sam deploy' command with parameter overrides:"
echo "$parameter_overrides"

