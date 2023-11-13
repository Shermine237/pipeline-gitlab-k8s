#!/bin/sh

echo "Copy addons file in Odoo pod";
POD=$(kubectl --namespace=$2 get pod -l app=$3 -o jsonpath="{.items[0].metadata.name}");
list_addons=();
for module in $1/addons/*;
        do kubectl cp  $module $2/$POD:/mnt/extra-addons/; done;
        list_addons+=("/mnt/extra-addons/$(basename $module)");
kubectl exec --namespace=$2 $POD -- /bin/sh -c 'if ! grep -q "addons_path" /etc/odoo/odoo.conf; then echo "addons_path=/mnt/extra-addons" >> /etc/odoo/odoo.conf; fi';
echo "Restarting pod...";
kubectl --namespace=$2 rollout restart deployment/$4;

