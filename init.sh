#!/bin/sh

[ -z $PLUGIN_USER ] && PLUGIN_USER=default
[ -z $PLUGIN_NAMESPACE ] && PLUGIN_NAMESPACE=default
[ -z $PLUGIN_TOKEN ] && echo "ERROR: no token has been provided"
[ -z $PLUGIN_SERVER ] && echo "ERROR: no server has been provided"

PATH=/opt/bin:$PATH

kubectl config set-credentials default --token=$PLUGIN_TOKEN

if [ ! -z $PLUGIN_CERT ]; then
  echo $PLUGIN_CERT | base64 -d > ca.crt
  kubectl config set-cluster default --server=$PLUGIN_SERVER --certificate-authority=ca.crt
else
  echo "WARNING: no certificate has been provided - skipping TLS verification"
  kubectl config set-cluster default --server=$PLUGIN_SERVER --insecure-skip-tls-verify=true
fi

kubectl config set-context default --cluster=default --user=$PLUGIN_USER --namespace=$PLUGIN_NAMESPACE
kubectl config use-context default
