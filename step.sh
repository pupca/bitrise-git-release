#!/bin/bash

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e

echo "This is the value specified for the input 'example_step_input': ${github_token}"

ruby "${THIS_SCRIPT_DIR}/main.rb"

exit 0