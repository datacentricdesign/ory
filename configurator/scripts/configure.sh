#!/bin/bash

set -euo pipefail

cd "$( dirname "${BASH_SOURCE[0]}" )/.."

echo "Sourcing helpers..."
source /scripts/helper/retry.sh
source /scripts/helper/envsubstfiles.sh
source /scripts/helper/getid.sh

echo "Substituting environment variables"
if [ -d "/config/hydra/clients/" ]; then
    envsubstfiles "/config/hydra/clients/*.json"
fi

echo "Executing bootstrap scripts..."

hydra_url=${HYDRA_URL:=undefined}
hydra_admin_url=${HYDRA_ADMIN_URL:=undefined}

export HYDRA_URL=${hydra_url%/}/
export HYDRA_ADMIN_URL=${hydra_admin_url%/}/

if [ -d "/config/hydra" ]; then
    backoff /scripts/services/hydra.sh "/config/hydra"
fi
