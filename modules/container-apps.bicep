param containerAppsEnvironmentName string

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2025-02-02-preview' existing = {
  name: containerAppsEnvironmentName
}

// https://github.com/langgenius/dify/blob/f104839672ccf111b2799fc31a85870e5e997b7d/docker/docker-compose.yaml#L7-L598
param consoleApiUrl string = ''
param consoleWebUrl string = ''
param serviceApiUrl string = ''
param appApiUrl string = ''
param appWebUrl string = ''
param filesUrl string = 'http://api:5001'
param internalFilesUrl string = ''
param lang string = 'en_US.UTF-8'
param lcAll string = 'en_US.UTF-8'
param pythonIoEncoding string = 'utf-8'
param logLevel string = 'INFO'
param logFile string = '/app/logs/server.log'
param logFileMaxSize string = '20'
param logFileBackupCount string = '5'
param logDateformat string = '%Y-%m-%d %H:%M:%S'
param logTz string = 'UTC'
param debug string = 'false'
param flaskDebug string = 'false'
param enableRequestLogging string = 'False'
param secretKey string = 'sk-9f73s3ljTXVcMT3Blb3ljTqtsKiGHXVcMT3BlbkFJLK7U'
param initPassword string = ''
param deployEnv string = 'PRODUCTION'
param checkUpdateUrl string = 'https://updates.dify.ai'
param openaiApiBase string = 'https://api.openai.com/v1'
param migrationEnabled string = 'true'
param filesAccessTimeout string = '300'
param accessTokenExpireMinutes string = '60'
param refreshTokenExpireDays string = '30'
param appMaxActiveRequests string = '0'
param appMaxExecutionTime string = '1200'
param difyBindAddress string = '0.0.0.0'
param difyPort string = '5001'
param serverWorkerAmount string = '1'
param serverWorkerClass string = 'gevent'
param serverWorkerConnections string = '10'
param gunicornTimeout string = '360'
param postgresMaxConnections string = '100'
param postgresSharedBuffers string = '128MB'
param postgresWorkMem string = '4MB'
param postgresMaintenanceWorkMem string = '64MB'
param postgresEffectiveCacheSize string = '4096MB'
param redisPassword string = 'difyai123456'
param postgresUser string = 'postgres'
param postgresPassword string = 'difyai123456'
param postgresDb string = 'dify'
param pgdata string = '/var/lib/postgresql/data/pgdata'
param sandboxApiKey string = 'dify-sandbox'
param sandboxGinMode string = 'release'
param sandboxWorkerTimeout string = '15'
param sandboxEnableNetwork string = 'true'
param sandboxHttpProxy string = 'http://ssrf_proxy:3128'
param sandboxHttpsProxy string = 'http://ssrf_proxy:3128'
param sandboxPort string = '8194'
param weaviatePersistenceDataPath string = '/var/lib/weaviate'
param weaviateQueryDefaultsLimit string = '25'
param weaviateAuthenticationAnonymousAccessEnabled string = 'true'
param weaviateDefaultVectorizerModule string = 'none'
param weaviateClusterHostname string = 'node1'
param weaviateAuthenticationApikeyEnabled string = 'true'
param weaviateAuthenticationApikeyAllowedKeys string = 'WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih'
param weaviateAuthenticationApikeyUsers string = 'hello@dify.ai'
param weaviateAuthorizationAdminlistEnabled string = 'true'
param weaviateAuthorizationAdminlistUsers string = 'hello@dify.ai'
param ssrfHttpPort string = '3128'
param ssrfCoredumpDir string = '/var/spool/squid'
param ssrfReverseProxyPort string = '8194'
param ssrfSandboxHost string = 'sandbox'
param pipMirrorUrl string = ''
var sharedApiWorkerEnv = [
  { name: 'CONSOLE_API_URL', value: consoleApiUrl }
  { name: 'CONSOLE_WEB_URL', value: consoleWebUrl }
  { name: 'SERVICE_API_URL', value: serviceApiUrl }
  { name: 'APP_API_URL', value: appApiUrl }
  { name: 'APP_WEB_URL', value: appWebUrl }
  { name: 'FILES_URL', value: filesUrl }
  { name: 'INTERNAL_FILES_URL', value: internalFilesUrl }
  { name: 'LANG', value: lang }
  { name: 'LC_ALL', value: lcAll }
  { name: 'PYTHONIOENCODING', value: pythonIoEncoding }
  { name: 'LOG_LEVEL', value: logLevel }
  { name: 'LOG_FILE', value: logFile }
  { name: 'LOG_FILE_MAX_SIZE', value: logFileMaxSize }
  { name: 'LOG_FILE_BACKUP_COUNT', value: logFileBackupCount }
  { name: 'LOG_DATEFORMAT', value: logDateformat }
  { name: 'LOG_TZ', value: logTz }
  { name: 'DEBUG', value: debug }
  { name: 'FLASK_DEBUG', value: flaskDebug }
  { name: 'ENABLE_REQUEST_LOGGING', value: enableRequestLogging }
  { name: 'SECRET_KEY', value: secretKey }
  { name: 'INIT_PASSWORD', value: initPassword }
  { name: 'DEPLOY_ENV', value: deployEnv }
  { name: 'CHECK_UPDATE_URL', value: checkUpdateUrl }
  { name: 'OPENAI_API_BASE', value: openaiApiBase }
  { name: 'MIGRATION_ENABLED', value: migrationEnabled }
  { name: 'FILES_ACCESS_TIMEOUT', value: filesAccessTimeout }
  { name: 'ACCESS_TOKEN_EXPIRE_MINUTES', value: accessTokenExpireMinutes }
  { name: 'REFRESH_TOKEN_EXPIRE_DAYS', value: refreshTokenExpireDays }
  { name: 'APP_MAX_ACTIVE_REQUESTS', value: appMaxActiveRequests }
  { name: 'APP_MAX_EXECUTION_TIME', value: appMaxExecutionTime }
  { name: 'DIFY_BIND_ADDRESS', value: difyBindAddress }
  { name: 'DIFY_PORT', value: difyPort }
  { name: 'SERVER_WORKER_AMOUNT', value: serverWorkerAmount }
  { name: 'SERVER_WORKER_CLASS', value: serverWorkerClass }
  { name: 'SERVER_WORKER_CONNECTIONS', value: serverWorkerConnections }
  { name: 'GUNICORN_TIMEOUT', value: gunicornTimeout }
  { name: 'POSTGRES_MAX_CONNECTIONS', value: postgresMaxConnections }
  { name: 'POSTGRES_SHARED_BUFFERS', value: postgresSharedBuffers }
  { name: 'POSTGRES_WORK_MEM', value: postgresWorkMem }
  { name: 'POSTGRES_MAINTENANCE_WORK_MEM', value: postgresMaintenanceWorkMem }
  { name: 'POSTGRES_EFFECTIVE_CACHE_SIZE', value: postgresEffectiveCacheSize }
  { name: 'REDIS_PASSWORD', value: redisPassword }
  { name: 'POSTGRES_USER', value: postgresUser }
  { name: 'POSTGRES_PASSWORD', value: postgresPassword }
  { name: 'POSTGRES_DB', value: postgresDb }
  { name: 'PGDATA', value: pgdata }
  { name: 'SANDBOX_API_KEY', value: sandboxApiKey }
  { name: 'SANDBOX_GIN_MODE', value: sandboxGinMode }
  { name: 'SANDBOX_WORKER_TIMEOUT', value: sandboxWorkerTimeout }
  { name: 'SANDBOX_ENABLE_NETWORK', value: sandboxEnableNetwork }
  { name: 'SANDBOX_HTTP_PROXY', value: sandboxHttpProxy }
  { name: 'SANDBOX_HTTPS_PROXY', value: sandboxHttpsProxy }
  { name: 'SANDBOX_PORT', value: sandboxPort }
  { name: 'WEAVIATE_PERSISTENCE_DATA_PATH', value: weaviatePersistenceDataPath }
  { name: 'WEAVIATE_QUERY_DEFAULTS_LIMIT', value: weaviateQueryDefaultsLimit }
  { name: 'WEAVIATE_AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED', value: weaviateAuthenticationAnonymousAccessEnabled }
  { name: 'WEAVIATE_DEFAULT_VECTORIZER_MODULE', value: weaviateDefaultVectorizerModule }
  { name: 'WEAVIATE_CLUSTER_HOSTNAME', value: weaviateClusterHostname }
  { name: 'WEAVIATE_AUTHENTICATION_APIKEY_ENABLED', value: weaviateAuthenticationApikeyEnabled }
  { name: 'WEAVIATE_AUTHENTICATION_APIKEY_ALLOWED_KEYS', value: weaviateAuthenticationApikeyAllowedKeys }
  { name: 'WEAVIATE_AUTHENTICATION_APIKEY_USERS', value: weaviateAuthenticationApikeyUsers }
  { name: 'WEAVIATE_AUTHORIZATION_ADMINLIST_ENABLED', value: weaviateAuthorizationAdminlistEnabled }
  { name: 'WEAVIATE_AUTHORIZATION_ADMINLIST_USERS', value: weaviateAuthorizationAdminlistUsers }
  { name: 'SSRF_HTTP_PORT', value: ssrfHttpPort }
  { name: 'SSRF_COREDUMP_DIR', value: ssrfCoredumpDir }
  { name: 'SSRF_REVERSE_PROXY_PORT', value: ssrfReverseProxyPort }
  { name: 'SSRF_SANDBOX_HOST', value: ssrfSandboxHost }
  { name: 'PIP_MIRROR_URL', value: pipMirrorUrl }
]

param containerAppDbName string = 'db'
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
            'maintenance_work_mem=${postgresMaintenanceWorkMem}'
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
            { name: 'DEFAULT_VECTORIZER_MODULE', value: weaviateDefaultVectorizerModule }
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

param containerAppSsrfProxyName string = 'ssrf-proxy'
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
          name: 'ssrf-proxy'
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
              mountPath: '/etc/ssrf_proxy'
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

param containerAppSandboxName string = 'sandbox'
resource containerAppSandbox 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppSandboxName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {}
    template: {
      containers: [
        {
          name: 'sandbox'
          image: 'docker.io/langgenius/dify-sandbox:0.2.12'
          imageType: 'ContainerImage'
          env: [
            { name: 'API_KEY', value: sandboxApiKey }
            { name: 'GIN_MODE', value: sandboxGinMode }
            { name: 'WORKER_TIMEOUT', value: sandboxWorkerTimeout }
            { name: 'ENABLE_NETWORK', value: sandboxEnableNetwork }
            { name: 'HTTP_PROXY', value: sandboxHttpProxy }
            { name: 'HTTPS_PROXY', value: sandboxHttpsProxy }
            { name: 'SANDBOX_PORT', value: sandboxPort }
            { name: 'PIP_MIRROR_URL', value: pipMirrorUrl }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: [] // not supported... https://github.com/langgenius/dify/blob/f104839672ccf111b2799fc31a85870e5e997b7d/docker/docker-compose.yaml#L771
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
        cooldownPeriod: 300
        pollingInterval: 30
      }
    }
  }
}

param containerAppApiName string = 'api'
param difyImageName string = 'docker.io/langgenius/dify-api:1.9.0'
param apiSentryDsn string = ''
param apiSentryTracesSampleRate string = '1.0'
param apiSentryProfilesSampleRate string = '1.0'
param exposePluginDebuggingHost string = 'localhost'
param exposePluginDebuggingPort string = '5003'
param pluginMaxPackageSize string = '52428800'
param pluginDifyInnerApiKey string = 'QaHbTe77CtuXmsfyhR7+vRjI/+XbV1AaFy691iy+kGDv2Jvy0/eAh8Y1'
resource containerAppApi 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppApiName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 5001
        exposedPort: 0
        transport: 'Auto'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
        allowInsecure: false
        stickySessions: {
          affinity: 'none'
        }
      }
    }
    template: {
      containers: [
        {
          name: 'api'
          image: difyImageName
          imageType: 'ContainerImage'
          env: concat(sharedApiWorkerEnv, [
            { name: 'MODE', value: 'api' }
            { name: 'SENTRY_DSN', value: apiSentryDsn }
            { name: 'SENTRY_TRACES_SAMPLE_RATE', value: apiSentryTracesSampleRate }
            { name: 'SENTRY_PROFILES_SAMPLE_RATE', value: apiSentryProfilesSampleRate }
            { name: 'PLUGIN_REMOTE_INSTALL_HOST', value: exposePluginDebuggingHost }
            { name: 'PLUGIN_REMOTE_INSTALL_PORT', value: exposePluginDebuggingPort }
            { name: 'PLUGIN_MAX_PACKAGE_SIZE', value: pluginMaxPackageSize }
            { name: 'INNER_API_KEY_FOR_PLUGIN', value: pluginDifyInnerApiKey }
          ])
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: 'volume-app-storage'
              mountPath: '/app/api/storage'
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
          name: 'volume-app-storage'
          storageType: 'EmptyDir'
        }
      ]
    }
  }
}

param containerAppWorkerName string = 'worker'
resource containerAppWorker 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppWorkerName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {}
    template: {
      containers: [
        {
          name: 'worker'
          image: difyImageName
          imageType: 'ContainerImage'
          env: concat(sharedApiWorkerEnv, [
            { name: 'MODE', value: 'worker' }
            { name: 'SENTRY_DSN', value: apiSentryDsn }
            { name: 'SENTRY_TRACES_SAMPLE_RATE', value: apiSentryTracesSampleRate }
            { name: 'SENTRY_PROFILES_SAMPLE_RATE', value: apiSentryProfilesSampleRate }
            { name: 'PLUGIN_MAX_PACKAGE_SIZE', value: pluginMaxPackageSize }
            { name: 'INNER_API_KEY_FOR_PLUGIN', value: pluginDifyInnerApiKey }
          ])
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: 'volume-app-storage'
              mountPath: '/app/api/storage'
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
          name: 'volume-app-storage'
          storageType: 'EmptyDir'
        }
      ]
    }
  }
}

param containerAppBeatName string = 'worker-beat'
resource containerAppBeat 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppBeatName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {}
    template: {
      containers: [
        {
          name: 'worker-beat'
          image: difyImageName
          imageType: 'ContainerImage'
          env: concat(sharedApiWorkerEnv, [
            { name: 'MODE', value: 'beat' }
          ])
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

param containerAppWebName string = 'web'
param difyWebImageName string = 'docker.io/langgenius/dify-web:1.9.0'
param centryDsn string = ''
param nextTelemetryDisabled string = '0'
param textGenerationTimeoutMs string = '60000'
param cspWhitelist string = ''
param allowEmbed string = 'false'
param allowUnsafeDataScheme string = 'false'
param marketplaceApiUrl string = 'https://marketplace.dify.ai'
param marketplaceUrl string = 'https://marketplace.dify.ai'
param topKMaxValue string = ''
param indexingMaxSegmentationTokensLength string = ''
param pm2Instances string = '2'
param loopNodeMaxCount string = '100'
param maxToolsNum string = '10'
param maxParallelLimit string = '10'
param maxIterationsNum string = '99'
param maxTreeDepth string = '50'
param enableWebsiteJinareader string = 'true'
param enableWebsiteFirecrawl string = 'true'
param enableWebsiteWatercrawl string = 'true'
resource containerAppWeb 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppWebName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 3000
        exposedPort: 0
        transport: 'Auto'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
        allowInsecure: false
        stickySessions: {
          affinity: 'none'
        }
      }
    }
    template: {
      containers: [
        {
          name: 'web'
          image: difyWebImageName
          imageType: 'ContainerImage'
          env: [
            { name: 'CONSOLE_API_URL', value: consoleApiUrl }
            { name: 'APP_API_URL', value: appApiUrl }
            { name: 'SENTRY_DSN', value: centryDsn }
            { name: 'NEXT_TELEMETRY_DISABLED', value: nextTelemetryDisabled }
            { name: 'TEXT_GENERATION_TIMEOUT_MS', value: textGenerationTimeoutMs }
            { name: 'CSP_WHITELIST', value: cspWhitelist }
            { name: 'ALLOW_EMBED', value: allowEmbed }
            { name: 'ALLOW_UNSAFE_DATA_SCHEME', value: allowUnsafeDataScheme }
            { name: 'MARKETPLACE_API_URL', value: marketplaceApiUrl }
            { name: 'MARKETPLACE_URL', value: marketplaceUrl }
            { name: 'TOP_K_MAX_VALUE', value: topKMaxValue }
            { name: 'INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH', value: indexingMaxSegmentationTokensLength }
            { name: 'PM2_INSTANCES', value: pm2Instances }
            { name: 'LOOP_NODE_MAX_COUNT', value: loopNodeMaxCount }
            { name: 'MAX_TOOLS_NUM', value: maxToolsNum }
            { name: 'MAX_PARALLEL_LIMIT', value: maxParallelLimit }
            { name: 'MAX_ITERATIONS_NUM', value: maxIterationsNum }
            { name: 'MAX_TREE_DEPTH', value: maxTreeDepth }
            { name: 'ENABLE_WEBSITE_JINAREADER', value: enableWebsiteJinareader }
            { name: 'ENABLE_WEBSITE_FIRECRAWL', value: enableWebsiteFirecrawl }
            { name: 'ENABLE_WEBSITE_WATERCRAWL', value: enableWebsiteWatercrawl }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
          volumeMounts: []
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
        cooldownPeriod: 300
        pollingInterval: 30
      }
      volumes: []
    }
  }
}

param containerAppPluginDaemonName string = 'plugin-daemon'
param difyPluginDaemonImageName string = 'docker.io/langgenius/dify-plugin-daemon:0.3.0-local'
param dbPluginDatabase string = 'dify_plugin'
param pluginDaemonPort string = '5002'
param pluginDaemonKey string = 'lYkiYYT6owG+71oLerGzA7GXCgOT++6ovaezWAjpCjf+Sjc3ZtU+qUEi'
param pluginPprofEnabled string = 'false'
param pluginDifyInnerApiUrl string = 'http://api:5001'
param pluginDebuggingHost string = '0.0.0.0'
param pluginDebuggingPort string = '5003'
param pluginWorkingPath string = '/app/storage/cwd'
param forceVerifyingSignature string = 'true'
param pluginPythonEnvInitTimeout string = '120'
param pluginMaxExecutionTimeout string = '600'
param pluginStdioBufferSize string = '1024'
param pluginStdioMaxBufferSize string = '5242880'
param pluginStorageType string = 'local'
param pluginStorageLocalRoot string = '/app/storage'
param pluginInstalledPath string = 'plugin'
param pluginPackageCachePath string = 'plugin_packages'
param pluginMediaCachePath string = 'assets'
param pluginSentryEnabled string = 'false'
param pluginSentryDsn string = ''

resource containerAppPluginDaemon 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppPluginDaemonName
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 5002
        exposedPort: 0
        transport: 'Auto'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
        allowInsecure: false
        stickySessions: {
          affinity: 'none'
        }
      }
    }
    template: {
      containers: [
        {
          name: 'plugin-daemon'
          image: difyPluginDaemonImageName
          imageType: 'ContainerImage'
          env: concat(sharedApiWorkerEnv, [
            { name: 'DB_DATABASE', value: dbPluginDatabase }
            { name: 'SERVER_PORT', value: pluginDaemonPort }
            { name: 'SERVER_KEY', value: pluginDaemonKey }
            { name: 'MAX_PLUGIN_PACKAGE_SIZE', value: pluginMaxPackageSize }
            { name: 'PPROF_ENABLED', value: pluginPprofEnabled }
            { name: 'DIFY_INNER_API_URL', value: pluginDifyInnerApiUrl }
            { name: 'DIFY_INNER_API_KEY', value: pluginDifyInnerApiKey }
            { name: 'PLUGIN_REMOTE_INSTALLING_HOST', value: pluginDebuggingHost }
            { name: 'PLUGIN_REMOTE_INSTALLING_PORT', value: pluginDebuggingPort }
            { name: 'PLUGIN_WORKING_PATH', value: pluginWorkingPath }
            { name: 'FORCE_VERIFYING_SIGNATURE', value: forceVerifyingSignature }
            { name: 'PYTHON_ENV_INIT_TIMEOUT', value: pluginPythonEnvInitTimeout }
            { name: 'PLUGIN_MAX_EXECUTION_TIMEOUT', value: pluginMaxExecutionTimeout }
            { name: 'PLUGIN_STDIO_BUFFER_SIZE', value: pluginStdioBufferSize }
            { name: 'PLUGIN_STDIO_MAX_BUFFER_SIZE', value: pluginStdioMaxBufferSize }
            { name: 'PIP_MIRROR_URL', value: pipMirrorUrl }
            { name: 'PLUGIN_STORAGE_TYPE', value: pluginStorageType }
            { name: 'PLUGIN_STORAGE_LOCAL_ROOT', value: pluginStorageLocalRoot }
            { name: 'PLUGIN_INSTALLED_PATH', value: pluginInstalledPath }
            { name: 'PLUGIN_PACKAGE_CACHE_PATH', value: pluginPackageCachePath }
            { name: 'PLUGIN_MEDIA_CACHE_PATH', value: pluginMediaCachePath }
            { name: 'SENTRY_ENABLED', value: pluginSentryEnabled }
            { name: 'SENTRY_DSN', value: pluginSentryDsn }
          ])
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: 'volume-plugin-daemon'
              mountPath: '/app/storage'
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
          name: 'volume-plugin-daemon'
          storageType: 'EmptyDir'
        }
      ]
    }
  }
}

param nginxImageName string = 'docker.io/nginx:latest'
param nginxServerName string = ''
param nginxHttpsEnabled string = 'false'
param nginxSslPort string = '443'
param nginxPort string = '80'
resource containerAppNginx 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: 'nginx'
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        exposedPort: 0
        transport: 'Auto'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
        allowInsecure: false
        stickySessions: {
          affinity: 'none'
        }
      }
    }
    template: {
      containers: [
        {
          name: 'nginx'
          image: nginxImageName
          imageType: 'ContainerImage'
          command: [
            'sh'
            '-c'
            'cp /docker-entrypoint-mount.sh /docker-entrypoint.sh && sed -i \'s/\r$$//\' /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh && /docker-entrypoint.sh'
          ]
          env: [
            { name: 'NGINX_SERVER_NAME', value: nginxServerName }
            { name: 'NGINX_HTTPS_ENABLED', value: nginxHttpsEnabled }
            { name: 'NGINX_SSL_PORT', value: nginxSslPort }
            { name: 'NGINX_PORT', value: nginxPort }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
          volumeMounts: [
            // {
            //   volumeName: 'nginx-conf'
            //   mountPath: '/etc/nginx'
            // }
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
        // {
        //   name: 'nginx-conf'
        //   storageType: 'EmptyDir'
        // }
      ]
    }
  }
}
