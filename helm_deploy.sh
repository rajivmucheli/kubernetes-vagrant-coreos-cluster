#!/usr/bin/env bash

if [ "local" != $(kubectl config current-context) ]; then
    echo "Should only run against a local kubectl context."
    exit
fi

export SAPCC_HELM_CHARTS_DIR=${SAPCC_HELM_CHARTS_DIR:-~/helm-charts}

export NAMESPACE=dex
echo "Deploying dex.."
helm upgrade dex ${SAPCC_HELM_CHARTS_DIR}/system/kube-system/charts/dex --namespace ${NAMESPACE} -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/dex.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml --reset-values

#export NAMESPACE=ldap
#echo "Deploying ldap.."
#kubectl create namespace ldap
#kubectl create secret tls ldap-tls-secret --key ../certificates/ldap-proxy.cluster.local-key.pem --cert ../certificates/ldap-proxy.cluster.local.pem -n ldap
#kubectl create secret generic ldap-ca-secret --from-file=ca.crt=../certificates/ca.pem -n ldap
#helm upgrade ldap stable/openldap --namespace ${NAMESPACE} -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/ldap.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml --reset-values

#export NAMESPACE=clair
#echo "Deploying clair.."
#(cd ${SAPCC_HELM_CHARTS_DIR}/global/clair && helm dependency up)
#helm upgrade clair ${SAPCC_HELM_CHARTS_DIR}/global/clair --namespace ${NAMESPACE} -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/clair.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml --reset-values

export NAMESPACE=monsoon3

echo "Deploying openstack-seeder.."
helm upgrade openstack-seeder ${SAPCC_HELM_CHARTS_DIR}/openstack/openstack-seeder --namespace ${NAMESPACE} -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/openstack-seeder.yaml --reset-values --force
echo "Deploying keystone.."
(cd ${SAPCC_HELM_CHARTS_DIR}/openstack/keystone && helm dependency up)
helm upgrade keystone ${SAPCC_HELM_CHARTS_DIR}/openstack/keystone --namespace ${NAMESPACE} -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/keystone.yaml  --reset-values --debug
echo "Deploying domain-seeds.."
helm upgrade seeds ${SAPCC_HELM_CHARTS_DIR}/openstack/domain-seeds --namespace ${NAMESPACE} -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/domain-seeds.yaml --reset-values --force
#echo "Deploying glance.."
#(cd ${SAPCC_HELM_CHARTS_DIR}/openstack/glance && helm dependency up)
#helm upgrade glance ${SAPCC_HELM_CHARTS_DIR}/openstack/glance --namespace ${NAMESPACE} -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/glance.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml
#echo "Deploying horizon.."
#(cd ${SAPCC_HELM_CHARTS_DIR}/openstack/horizon && helm dependency up)
#helm upgrade horizon ${SAPCC_HELM_CHARTS_DIR}/openstack/horizon --namespace ${NAMESPACE} -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/horizon.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml
#echo "Deploying barbican.."
#(cd ${SAPCC_HELM_CHARTS_DIR}/openstack/barbican && helm dependency up)
#helm upgrade barbican ${SAPCC_HELM_CHARTS_DIR}/openstack/barbican --namespace ${NAMESPACE} -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/barbican.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml
#echo "Deploying elektra.."
#helm upgrade elektra ${SAPCC_HELM_CHARTS_DIR}/openstack/elektra --namespace elektra -i --values ~/vag/kubernetes-vagrant-coreos-cluster/values/elektra.yaml --values ~/vag/kubernetes-vagrant-coreos-cluster/values/globals.yaml
