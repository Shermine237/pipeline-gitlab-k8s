#!/bin/sh

echo "Odoo initialized with custom addons:  ${list_addons[@]}";
kubectl --namespace=$2 logs $POD > output.log;
if [ $(grep -c "CRITICAL\|ERROR\|Traceback\|AttributeError" output.log) -ne 0 ]
then
    cat output.log >&2;
    for addons in "${list_addons[@]}"
    do
      kubectl exec --namespace=$2 $POD -- /bin/sh -c "rm -r $addons" && echo "$addons deleted";
    done
    kubectl --namespace=$2 rollout restart deployment/$4;
    exit 1
else
    cat output.log && exit 0
fi

