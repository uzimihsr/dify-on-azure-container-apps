#!/bin/sh
set -e

echo "リソースグループ $rgName を作成"
az group create --name $rgName --location japaneast

echo "リソースグループに必要なリソースを作成"
az deployment group create \
  -g $rgName \
  -f main.bicep \
  -p main.bicepparam

echo "一部のコンテナでマウントが必要なファイルをAzure File共有にアップロード"
sleep 10
stName=$(az storage account list -g $rgName --query "[0].name" -o tsv)
stKey=$(az storage account keys list -g $rgName -n $stName --query "[0].value" -o tsv)
az storage file upload-batch --account-name $stName --account-key $stKey --destination "volume-nginx" --source ./volumes/nginx
az storage file upload-batch --account-name $stName --account-key $stKey --destination "volume-dify-sandbox" --source ./volumes/sandbox
az storage file upload-batch --account-name $stName --account-key $stKey --destination "volume-ssrf-proxy" --source ./volumes/ssrf_proxy 

echo "マウント後のコンテナを再起動"
sleep 10
ssrfProxyRevision=$(az containerapp revision list -g $rgName -n "ssrf-proxy" --query "[0].name" -o tsv)
az containerapp revision restart -g $rgName -n "ssrf-proxy" --revision $ssrfProxyRevision
sandboxRevision=$(az containerapp revision list -g $rgName -n "sandbox" --query "[0].name" -o tsv)
az containerapp revision restart -g $rgName -n "sandbox" --revision $sandboxRevision
nginxRevision=$(az containerapp revision list -g $rgName -n "nginx" --query "[0].name" -o tsv)
az containerapp revision restart -g $rgName -n "nginx" --revision $nginxRevision

fqdn=$(az containerapp show -g $rgName -n "nginx" --query "properties.configuration.ingress.fqdn" -o tsv)
echo "ブラウザで https://${fqdn} を開きます..."
sleep 10
az containerapp browse -g $rgName -n "nginx"

echo "Enjoy!"
