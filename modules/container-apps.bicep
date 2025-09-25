param containerAppsEnvironmentName string

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2025-02-02-preview' existing = {
  name: containerAppsEnvironmentName
}

param containerAppDbName string = 'db'
param postgresUser string = 'postgres'
param postgresPassword string = 'difyai123456'
param postgresDb string = 'dify'
param pgdata string = '/var/lib/postgresql/data/pgdata'
param postgresMaxConnections string = '100'
param postgresSharedBuffers string = '128MB'
param postgresWorkMem string = '4MB'
param postgresMainenceWorkMem string = '64MB'
param postgresEffectiveCacheSize string = '4096MB'
resource containerAppDb 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppDbName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {}
    template: {
      containers: [
        {
          name: 'db'
          image: 'docker.io/postgres:15-alpine'
          imageType: 'ContainerImage'
          env: [
            { name: 'POSTGRES_USER', value: postgresUser }
            { name: 'POSTGRES_PASSWORD', value: postgresPassword }
            { name: 'POSTGRES_DB', value: postgresDb }
            { name: 'PGDATA', value: pgdata }
          ]
          args: [
            '-c'
            'max_connections=${postgresMaxConnections}'
            '-c'
            'shared_buffers=${postgresSharedBuffers}'
            '-c'
            'work_mem=${postgresWorkMem}'
            '-c'
            'maintenance_work_mem=${postgresMainenceWorkMem}'
            '-c'
            'effective_cache_size=${postgresEffectiveCacheSize}'
          ]
          // command: [
          //   'postgres'
          //   '-c'
          //   'max_connections=${pgdata}'
          //   '-c'
          //   'shared_buffers=${postgresSharedBuffers}'
          //   '-c'
          //   'work_mem=${postgresWorkMem}'
          //   '-c'
          //   'maintenance_work_mem=${postgresMainenceWorkMem}'
          //   '-c'
          //   'effective_cache_size=${postgresEffectiveCacheSize}'
          // ] 
          // "root" execution of the PostgreSQL server is not permitted...
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: [] // not supported https://github.com/langgenius/dify/blob/e937c8c72e56ec8690c1790ff40cb4311bb63510/docker/docker-compose.yaml#L718
          volumeMounts: [
            {
              volumeName: 'volume-db-data'
              mountPath: '/var/lib/postgresql/data'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
        cooldownPeriod: 300
        pollingInterval: 30
      }
      volumes: [
        {
          name: 'volume-db-data'
          storageType: 'EmptyDir'
        }
      ]
    }
  }
}

param containerAppRedisName string = 'redis'
param redisPassword string = 'difyai123456'
resource containerAppRedis 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppRedisName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {}
    template: {
      containers: [
        {
          name: 'api'
          image: 'docker.io/redis:6-alpine'
          imageType: 'ContainerImage'
          env: [
            { name: 'REDISCLI_AUTH', value: redisPassword }
          ]
          command: [
            'redis-server'
            '--requirepass'
            '${redisPassword}'
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: 'volume-redis-data'
              mountPath: '/data'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
        cooldownPeriod: 300
        pollingInterval: 30
      }
      volumes: [
        {
          name: 'volume-redis-data'
          storageType: 'EmptyDir'
        }
      ]
    }
  }
}

param containerAppWeaviateName string = 'weaviate'
param weaviatePersistenceDataPath string = '/var/lib/weaviate'
param weaviateQueryDefaultsLimit string = '25'
param weaviateAuthenticationAnonymousAccessEnabled string = 'false'
param weviateDefaultVectorizerModule string = 'none'
param weaviateClusterHostname string = 'node1'
param weaviateAuthenticationApikeyEnabled string = 'true'
param weaviateAuthenticationApikeyAllowedKeys string = 'WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih'
param weaviateAuthenticationApikeyUsers string = 'hello@dify.ai'
param weaviateAuthorizationAdminlistEnabled string = 'true'
param weaviateAuthorizationAdminlistUsers string = 'hello@dify.ai'
resource containerAppWeaviate 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppWeaviateName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {}
    template: {
      containers: [
        {
          name: 'weaviate'
          image: 'docker.io/semitechnologies/weaviate:1.19.0'
          imageType: 'ContainerImage'
          env: [
            { name: 'PERSISTENCE_DATA_PATH', value: weaviatePersistenceDataPath }
            { name: 'QUERY_DEFAULTS_LIMIT', value: weaviateQueryDefaultsLimit }
            { name: 'AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED', value: weaviateAuthenticationAnonymousAccessEnabled }
            { name: 'DEFAULT_VECTORIZER_MODULE', value: weviateDefaultVectorizerModule }
            { name: 'CLUSTER_HOSTNAME', value: weaviateClusterHostname }
            { name: 'AUTHENTICATION_APIKEY_ENABLED', value: weaviateAuthenticationApikeyEnabled }
            { name: 'AUTHENTICATION_APIKEY_ALLOWED_KEYS', value: weaviateAuthenticationApikeyAllowedKeys }
            { name: 'AUTHENTICATION_APIKEY_USERS', value: weaviateAuthenticationApikeyUsers }
            { name: 'AUTHORIZATION_ADMINLIST_ENABLED', value: weaviateAuthorizationAdminlistEnabled }
            { name: 'AUTHORIZATION_ADMINLIST_USERS', value: weaviateAuthorizationAdminlistUsers }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: 'volume-weaviate'
              mountPath: '/var/lib/weaviate'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
        cooldownPeriod: 300
        pollingInterval: 30
      }
      volumes: [
        {
          name: 'volume-weaviate'
          storageType: 'EmptyDir'
        }
      ]
    }
  }
}

param containerAppSsrfProxyName string = 'ssrf_proxy'
param ssrfHttpPort string = '3128'
param ssrfCoredumpDir string = '/var/spool/squid'
param ssrfReverseProxyPort string = '8194'
param ssrfSandboxHost string = 'sandbox'
param sandboxPort string = '8194'
resource containerAppSsrfProxy 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppSsrfProxyName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {}
    template: {
      containers: [
        {
          name: 'ssrf_proxy'
          image: 'docker.io/ubuntu/squid:latest'
          imageType: 'ContainerImage'
          command: [
            'sh'
            '-c'
            'cp /docker-entrypoint-mount.sh /docker-entrypoint.sh && sed -i \'s/\r$$//\' /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh && /docker-entrypoint.sh'
          ]
          env: [
            { name: 'HTTP_PORT', value: ssrfHttpPort }
            { name: 'COREDUMP_DIR', value: ssrfCoredumpDir }
            { name: 'REVERSE_PROXY_PORT', value: ssrfReverseProxyPort }
            { name: 'SANDBOX_HOST', value: ssrfSandboxHost }
            { name: 'SANDBOX_PORT', value: sandboxPort }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: 'ssrf-proxy'
              mountPath: '/'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
        cooldownPeriod: 300
        pollingInterval: 30
      }
      volumes: [
        // TODO: Azure File共有に変更すること
        {
          name: 'ssrf-proxy'
          storageType: 'EmptyDir'
        }
      ]
    }
  }
}
