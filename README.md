# dify-on-azure-container-apps
Dify(Community)をほぼAzure Container Apps+Storage Accountのみで建てることを目的に、  
https://github.com/langgenius/dify/blob/main/docker/docker-compose.yaml  
をBicepに書き換えたもの  

## deploy

```bash
az login
export rgName="yourResourceGroupName" # "rg-dify-001"
./deploy.sh
```

## 参考

- 偉大な先駆者様 : https://github.com/himanago/dify-azure-bicep  
  - Redis, PostgreSQLをAzure上のPaaSで作成されている完全上位互換。真面目な運用を見据えるなら間違いなくこちらの方が良い。
