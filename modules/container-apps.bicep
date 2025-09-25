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

param containerAppSandboxName string = 'sandbox'
param sandboxApiKey string = 'dify-sandbox'
param sandboxGinMode string = 'release'
param sandboxWorkerTimeout string = '15'
param sandboxEnableNetwork string = 'true'
param sandboxHttpProxy string = 'http://ssrf_proxy:3128'
param sandboxHttpsProxy string = 'http://ssrf_proxy:3128'
param pipMirrorUrl string = ''
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
param celeryWorkerClass string = ''
param gunicornTimeout string = '360'
param celeryWorkerAmount string = ''
param celeryAutoScale string = 'false'
param celeryMaxWorkers string = ''
param celeryMinWorkers string = ''
param apiToolDefaultConnectTimeout string = '10'
param apiToolDefaultReadTimeout string = '60'
param enableWebsiteJinareader string = 'true'
param enableWebsiteFirecrawl string = 'true'
param enableWebsiteWatercrawl string = 'true'
param dbUsername string = 'postgres'
param dbPassword string = 'difyai123456'
param dbHost string = 'db'
param dbPort string = '5432'
param dbDatabase string = 'dify'
param sqlalchemyPoolSize string = '30'
param sqlalchemyMaxOverflow string = '10'
param sqlalchemyPoolRecycle string = '3600'
param sqlalchemyEcho string = 'false'
param sqlalchemyPoolPrePing string = 'false'
param sqlalchemyPoolUseLifo string = 'false'
param sqlalchemyPoolTimeout string = '30'
// param postgresMaxConnections string = '100'
// param postgresSharedBuffers string = '128MB'
// param postgresWorkMem string = '4MB'
param postgresMaintenanceWorkMem string = '64MB'
// param postgresEffectiveCacheSize string = '4096MB'
param redisHost string = 'redis'
param redisPort string = '6379'
param redisUsername string = ''
// param redisPassword string = 'difyai123456'
param redisUseSsl string = 'false'
param redisSslCertReqs string = 'CERT_NONE'
param redisSslCaCerts string = ''
param redisSslCertfile string = ''
param redisSslKeyfile string = ''
param redisDb string = '0'
param redisUseSentinel string = 'false'
param redisSentinels string = ''
param redisSentinelServiceName string = ''
param redisSentinelUsername string = ''
param redisSentinelPassword string = ''
param redisSentinelSocketTimeout string = '0.1'
param redisUseClusters string = 'false'
param redisClusters string = ''
param redisClustersPassword string = ''
param celeryBrokerUrl string = 'redis://:difyai123456@redis:6379/1'
param celeryBackend string = 'redis'
param brokerUseSsl string = 'false'
param celeryUseSentinel string = 'false'
param celerySentinelMasterName string = ''
param celerySentinelPassword string = ''
param celerySentinelSocketTimeout string = '0.1'
param webApiCorsAllowOrigins string = '*'
param consoleCorsAllowOrigins string = '*'
param storageType string = 'opendal'
param opendalScheme string = 'fs'
param opendalFsRoot string = 'storage'
param clickzettaVolumeType string = 'user'
param clickzettaVolumeName string = ''
param clickzettaVolumeTablePrefix string = 'dataset_'
param clickzettaVolumeDifyPrefix string = 'dify_km'

param vectorStore string = 'weaviate'
param vectorIndexNamePrefix string = 'Vector_index'
param weaviateEndpoint string = 'http://weaviate:8080'
param weaviateApiKey string = 'WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih'
param qdrantUrl string = 'http://qdrant:6333'
param qdrantApiKey string = 'difyai123456'
param qdrantClientTimeout string = '20'
param qdrantGrpcEnabled string = 'false'
param qdrantGrpcPort string = '6334'
param qdrantReplicationFactor string = '1'
param milvusUri string = 'http://host.docker.internal:19530'
param milvusDatabase string = ''
param milvusToken string = ''
param milvusUser string = ''
param milvusPassword string = ''
param milvusEnableHybridSearch string = 'False'
param milvusAnalyzerParams string = ''
param myscaleHost string = 'myscale'
param myscalePort string = '8123'
param myscaleUser string = 'default'
param myscalePassword string = ''
param myscaleDatabase string = 'dify'
param myscaleFtsParams string = ''
param couchbaseConnectionString string = 'couchbase://couchbase-server'
param couchbaseUser string = 'Administrator'
param couchbasePassword string = 'password'
param couchbaseBucketName string = 'Embeddings'
param couchbaseScopeName string = '_default'
param pgvectorHost string = 'pgvector'
param pgvectorPort string = '5432'
param pgvectorUser string = 'postgres'
param pgvectorPassword string = 'difyai123456'
param pgvectorDatabase string = 'dify'
param pgvectorMinConnection string = '1'
param pgvectorMaxConnection string = '5'
param pgvectorPgBigM string = 'false'
param pgvectorPgBigMVersion string = '1.2-20240606'
param vastbaseHost string = 'vastbase'
param vastbasePort string = '5432'
param vastbaseUser string = 'dify'
param vastbasePassword string = 'Difyai123456'
param vastbaseDatabase string = 'dify'
param vastbaseMinConnection string = '1'
param vastbaseMaxConnection string = '5'
param pgvectoRsHost string = 'pgvecto-rs'
param pgvectoRsPort string = '5432'
param pgvectoRsUser string = 'postgres'
param pgvectoRsPassword string = 'difyai123456'
param pgvectoRsDatabase string = 'dify'
param analyticdbKeyId string = 'your-ak'
param analyticdbKeySecret string = 'your-sk'
param analyticdbRegionId string = 'cn-hangzhou'
param analyticdbInstanceId string = 'gp-ab123456'
param analyticdbAccount string = 'testaccount'
param analyticdbPassword string = 'testpassword'
param analyticdbNamespace string = 'dify'
param analyticdbNamespacePassword string = 'difypassword'
param analyticdbHost string = 'gp-test.aliyuncs.com'
param analyticdbPort string = '5432'
param analyticdbMinConnection string = '1'
param analyticdbMaxConnection string = '5'
param tidbVectorHost string = 'tidb'
param tidbVectorPort string = '4000'
param tidbVectorUser string = ''
param tidbVectorPassword string = ''
param tidbVectorDatabase string = 'dify'
param matrixoneHost string = 'matrixone'
param matrixonePort string = '6001'
param matrixoneUser string = 'dump'
param matrixonePassword string = '111'
param matrixoneDatabase string = 'dify'
param tidbOnQdrantUrl string = 'http://127.0.0.1'
param tidbOnQdrantApiKey string = 'dify'
param tidbOnQdrantClientTimeout string = '20'
param tidbOnQdrantGrpcEnabled string = 'false'
param tidbOnQdrantGrpcPort string = '6334'
param tidbPublicKey string = 'dify'
param tidbPrivateKey string = 'dify'
param tidbApiUrl string = 'http://127.0.0.1'
param tidbIamApiUrl string = 'http://127.0.0.1'
param tidbRegion string = 'regions/aws-us-east-1'
param tidbProjectId string = 'dify'
param tidbSpendLimit string = '100'
param chromaHost string = '127.0.0.1'
param chromaPort string = '8000'
param chromaTenant string = 'default_tenant'
param chromaDatabase string = 'default_database'
param chromaAuthProvider string = 'chromadb.auth.token_authn.TokenAuthClientProvider'
param chromaAuthCredentials string = ''
param oracleUser string = 'dify'
param oraclePassword string = 'dify'
param oracleDsn string = 'oracle:1521/FREEPDB1'
param oracleConfigDir string = '/app/api/storage/wallet'
param oracleWalletLocation string = '/app/api/storage/wallet'
param oracleWalletPassword string = 'dify'
param oracleIsAutonomous string = 'false'
param relytHost string = 'db'
param relytPort string = '5432'
param relytUser string = 'postgres'
param relytPassword string = 'difyai123456'
param relytDatabase string = 'postgres'
param opensearchHost string = 'opensearch'
param opensearchPort string = '9200'
param opensearchSecure string = 'true'
param opensearchVerifyCerts string = 'true'
param opensearchAuthMethod string = 'basic'
param opensearchUser string = 'admin'
param opensearchPassword string = 'admin'
param opensearchAwsRegion string = 'ap-southeast-1'
param opensearchAwsService string = 'aoss'
param tencentVectorDbUrl string = 'http://127.0.0.1'
param tencentVectorDbApiKey string = 'dify'
param tencentVectorDbTimeout string = '30'
param tencentVectorDbUsername string = 'dify'
param tencentVectorDbDatabase string = 'dify'
param tencentVectorDbShard string = '1'
param tencentVectorDbReplicas string = '2'
param tencentVectorDbEnableHybridSearch string = 'false'
param elasticsearchHost string = '0.0.0.0'
param elasticsearchPort string = '9200'
param elasticsearchUsername string = 'elastic'
param elasticsearchPassword string = 'elastic'
param kibanaPort string = '5601'
param elasticsearchUseCloud string = 'false'
param elasticsearchCloudUrl string = 'YOUR-ELASTICSEARCH_CLOUD_URL'
param elasticsearchApiKey string = 'YOUR-ELASTICSEARCH_API_KEY'
param elasticsearchVerifyCerts string = 'False'
param elasticsearchCaCerts string = ''
param elasticsearchRequestTimeout string = '100000'
param elasticsearchRetryOnTimeout string = 'True'
param elasticsearchMaxRetries string = '10'
param baiduVectorDbEndpoint string = 'http://127.0.0.1:5287'
param baiduVectorDbConnectionTimeoutMs string = '30000'
param baiduVectorDbAccount string = 'root'
param baiduVectorDbApiKey string = 'dify'
param baiduVectorDbDatabase string = 'dify'
param baiduVectorDbShard string = '1'
param baiduVectorDbReplicas string = '3'
param baiduVectorDbInvertedIndexAnalyzer string = 'DEFAULT_ANALYZER'
param baiduVectorDbInvertedIndexParserMode string = 'COARSE_MODE'
param vikingdbAccessKey string = 'your-ak'
param vikingdbSecretKey string = 'your-sk'
param vikingdbRegion string = 'cn-shanghai'
param vikingdbHost string = 'api-vikingdb.xxx.volces.com'
param vikingdbSchema string = 'http'
param vikingdbConnectionTimeout string = '30'
param vikingdbSocketTimeout string = '30'
param lindormUrl string = 'http://localhost:30070'
param lindormUsername string = 'admin'
param lindormPassword string = 'admin'
param lindormUsingUgc string = 'True'
param lindormQueryTimeout string = '1'
param oceanbaseVectorHost string = 'oceanbase'
param oceanbaseVectorPort string = '2881'
param oceanbaseVectorUser string = 'root@test'
param oceanbaseVectorPassword string = 'difyai123456'
param oceanbaseVectorDatabase string = 'test'
param oceanbaseClusterName string = 'difyai'
param oceanbaseMemoryLimit string = '6G'
param oceanbaseEnableHybridSearch string = 'false'
param oceanbaseFulltextParser string = 'ik'
param opengaussHost string = 'opengauss'
param opengaussPort string = '6600'
param opengaussUser string = 'postgres'
param opengaussPassword string = 'Dify@123'
param opengaussDatabase string = 'dify'
param opengaussMinConnection string = '1'
param opengaussMaxConnection string = '5'
param opengaussEnablePq string = 'false'
param huaweiCloudHosts string = 'https://127.0.0.1:9200'
param huaweiCloudUser string = 'admin'
param huaweiCloudPassword string = 'admin'
param upstashVectorUrl string = 'https://xxx-vector.upstash.io'
param upstashVectorToken string = 'dify'
param tablstoreEndpoint string = 'https://instance-name.cn-hangzhou.ots.aliyuncs.com'
param tablstoreInstanceName string = 'instance-name'
param tablstoreAccessKeyId string = 'xxx'
param tablstoreAccessKeySecret string = 'xxx'
param tablstoreNormalizeFulltextBm25Score string = 'false'
param clickzettaUsername string = ''
param clickzettaPassword string = ''
param clickzettaInstance string = ''
param clickzettaService string = 'api.clickzetta.com'
param clickzettaWorkspace string = 'quick_start'
param clickzettaVcluster string = 'default_ap'
param clickzettaSchema string = 'dify'
param clickzettaBatchSize string = '100'
param clickzettaEnableInvertedIndex string = 'true'
param clickzettaAnalyzerType string = 'chinese'
param clickzettaAnalyzerMode string = 'smart'
param clickzettaVectorDistanceFunction string = 'cosine_distance'
param uploadFileSizeLimit string = '15'
param uploadFileBatchLimit string = '5'
param etlType string = 'dify'
param unstructuredApiUrl string = ''
param unstructuredApiKey string = ''
param scarfNoAnalytics string = 'true'
param promptGenerationMaxTokens string = '512'
param codeGenerationMaxTokens string = '1024'
param pluginBasedTokenCountingEnabled string = 'false'
param multimodalSendFormat string = 'base64'
param uploadImageFileSizeLimit string = '10'
param uploadVideoFileSizeLimit string = '100'
param uploadAudioFileSizeLimit string = '50'
param sentryDsn string = ''
param apiSentryDsn string = ''
param apiSentryTracesSampleRate string = '1.0'
param apiSentryProfilesSampleRate string = '1.0'
param webSentryDsn string = ''
param pluginSentryEnabled string = 'false'
param pluginSentryDsn string = ''
param notionIntegrationType string = 'public'
param notionClientSecret string = ''
param notionClientId string = ''
param notionInternalSecret string = ''
param mailType string = 'resend'
param mailDefaultSendFrom string = ''
param resendApiUrl string = 'https://api.resend.com'
param resendApiKey string = 'your-resend-api-key'
param smtpServer string = ''
param smtpPort string = '465'
param smtpUsername string = ''
param smtpPassword string = ''
param smtpUseTls string = 'true'
param smtpOpportunisticTls string = 'false'
param sendgridApiKey string = ''
param indexingMaxSegmentationTokensLength string = '4000'
param inviteExpiryHours string = '72'
param resetPasswordTokenExpiryMinutes string = '5'
param emailRegisterTokenExpiryMinutes string = '5'
param changeEmailTokenExpiryMinutes string = '5'
param ownerTransferTokenExpiryMinutes string = '5'
param codeExecutionEndpoint string = 'http://sandbox:8194'
param codeExecutionApiKey string = 'dify-sandbox'
param codeExecutionSslVerify string = 'True'
param codeExecutionPoolMaxConnections string = '100'
param codeExecutionPoolMaxKeepaliveConnections string = '20'
param codeExecutionPoolKeepaliveExpiry string = '5.0'
param codeMaxNumber string = '9223372036854775807'
param codeMinNumber string = '-9223372036854775808'
param codeMaxDepth string = '5'
param codeMaxPrecision string = '20'
param codeMaxStringLength string = '80000'
param codeMaxStringArrayLength string = '30'
param codeMaxObjectArrayLength string = '30'
param codeMaxNumberArrayLength string = '1000'
param codeExecutionConnectTimeout string = '10'
param codeExecutionReadTimeout string = '60'
param codeExecutionWriteTimeout string = '10'
param templateTransformMaxLength string = '80000'
param workflowMaxExecutionSteps string = '500'
param workflowMaxExecutionTime string = '1200'
param workflowCallMaxDepth string = '5'
param maxVariableSize string = '204800'
param workflowParallelDepthLimit string = '3'
param workflowFileUploadLimit string = '10'
param graphEngineMinWorkers string = '1'
param graphEngineMaxWorkers string = '10'
param graphEngineScaleUpThreshold string = '3'
param graphEngineScaleDownIdleTime string = '5.0'
param workflowNodeExecutionStorage string = 'rdbms'
param coreWorkflowExecutionRepository string = 'core.repositories.sqlalchemy_workflow_execution_repository.SQLAlchemyWorkflowExecutionRepository'
param coreWorkflowNodeExecutionRepository string = 'core.repositories.sqlalchemy_workflow_node_execution_repository.SQLAlchemyWorkflowNodeExecutionRepository'
param apiWorkflowRunRepository string = 'repositories.sqlalchemy_api_workflow_run_repository.DifyAPISQLAlchemyWorkflowRunRepository'
param apiWorkflowNodeExecutionRepository string = 'repositories.sqlalchemy_api_workflow_node_execution_repository.DifyAPISQLAlchemyWorkflowNodeExecutionRepository'
param workflowLogCleanupEnabled string = 'false'
param workflowLogRetentionDays string = '30'
param workflowLogCleanupBatchSize string = '100'
param httpRequestNodeMaxBinarySize string = '10485760'
param httpRequestNodeMaxTextSize string = '1048576'
param httpRequestNodeSslVerify string = 'True'
param respectXforwardHeadersEnabled string = 'false'
param ssrfProxyHttpUrl string = 'http://ssrf_proxy:3128'
param ssrfProxyHttpsUrl string = 'http://ssrf_proxy:3128'
param loopNodeMaxCount string = '100'
param maxToolsNum string = '10'
param maxParallelLimit string = '10'
param maxIterationsNum string = '99'
param textGenerationTimeoutMs string = '60000'
param allowUnsafeDataScheme string = 'false'
param maxTreeDepth string = '50'
// param postgresUser string = ''
// param postgresPassword string = ''
// param postgresDb string = ''
// param pgdata string = '/var/lib/postgresql/data/pgdata'
// param sandboxApiKey string = 'dify-sandbox'
// param sandboxGinMode string = 'release'
// param sandboxWorkerTimeout string = '15'
// param sandboxEnableNetwork string = 'true'
// param sandboxHttpProxy string = 'http://ssrf_proxy:3128'
// param sandboxHttpsProxy string = 'http://ssrf_proxy:3128'
// param sandboxPort string = '8194'
// param weaviatePersistenceDataPath string = '/var/lib/weaviate'
// param weaviateQueryDefaultsLimit string = '25'
// param weaviateAuthenticationAnonymousAccessEnabled string = 'true'
param weaviateDefaultVectorizerModule string = 'none'
// param weaviateClusterHostname string = 'node1'
// param weaviateAuthenticationApikeyEnabled string = 'true'
// param weaviateAuthenticationApikeyAllowedKeys string = 'WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih'
// param weaviateAuthenticationApikeyUsers string = 'hello@dify.ai'
// param weaviateAuthorizationAdminlistEnabled string = 'true'
// param weaviateAuthorizationAdminlistUsers string = 'hello@dify.ai'
param chromaServerAuthnCredentials string = 'difyai123456'
param chromaServerAuthnProvider string = 'chromadb.auth.token_authn.TokenAuthenticationServerProvider'
param chromaIsPersistent string = 'TRUE'
param oraclePwd string = 'Dify123456'
param oracleCharacterset string = 'AL32UTF8'
param etcdAutoCompactionMode string = 'revision'
param etcdAutoCompactionRetention string = '1000'
param etcdQuotaBackendBytes string = '4294967296'
param etcdSnapshotCount string = '50000'
param minioAccessKey string = 'minioadmin'
param minioSecretKey string = 'minioadmin'
param etcdEndpoints string = 'etcd:2379'
param minioAddress string = 'minio:9000'
param milvusAuthorizationEnabled string = 'true'
param pgvectorPguser string = 'postgres'
param pgvectorPostgresPassword string = 'difyai123456'
param pgvectorPostgresDb string = 'dify'
param pgvectorPgdata string = '/var/lib/postgresql/data/pgdata'
param opensearchDiscoveryType string = 'single-node'
param opensearchBootstrapMemoryLock string = 'true'
param opensearchJavaOptsMin string = '512m'
param opensearchJavaOptsMax string = '1024m'
param opensearchInitialAdminPassword string = 'Qazwsxedc!@#123'
param opensearchMemlockSoft string = '-1'
param opensearchMemlockHard string = '-1'
param opensearchNofileSoft string = '65536'
param opensearchNofileHard string = '65536'
param nginxServerName string = '_'
param nginxHttpsEnabled string = 'false'
param nginxPort string = '80'
param nginxSslPort string = '443'
param nginxSslCertFilename string = 'dify.crt'
param nginxSslCertKeyFilename string = 'dify.key'
param nginxSslProtocols string = 'TLSv1.1 TLSv1.2 TLSv1.3'
param nginxWorkerProcesses string = 'auto'
param nginxClientMaxBodySize string = '100M'
param nginxKeepaliveTimeout string = '65'
param nginxProxyReadTimeout string = '3600s'
param nginxProxySendTimeout string = '3600s'
param nginxEnableCertbotChallenge string = 'false'
param certbotEmail string = 'your_email@example.com'
param certbotDomain string = 'your_domain.com'
param certbotOptions string = ''
// param ssrfHttpPort string = '3128'
// param ssrfCoredumpDir string = '/var/spool/squid'
// param ssrfReverseProxyPort string = '8194'
// param ssrfSandboxHost string = 'sandbox'
param ssrfDefaultTimeOut string = '5'
param ssrfDefaultConnectTimeOut string = '5'
param ssrfDefaultReadTimeOut string = '5'
param ssrfDefaultWriteTimeOut string = '5'
param ssrfPoolMaxConnections string = '100'
param ssrfPoolMaxKeepaliveConnections string = '20'
param ssrfPoolKeepaliveExpiry string = '5.0'
param exposeNginxPort string = '80'
param exposeNginxSslPort string = '443'
param positionToolPins string = ''
param positionToolIncludes string = ''
param positionToolExcludes string = ''
param positionProviderPins string = ''
param positionProviderIncludes string = ''
param positionProviderExcludes string = ''
param cspWhitelist string = ''
param createTidbServiceJobEnabled string = 'false'
param maxSubmitCount string = '100'
param topKMaxValue string = '10'
param dbPluginDatabase string = 'dify_plugin'
param exposePluginDaemonPort string = '5002'
param pluginDaemonPort string = '5002'
param pluginDaemonKey string = 'lYkiYYT6owG+71oLerGzA7GXCgOT++6ovaezWAjpCjf+Sjc3ZtU+qUEi'
param pluginDaemonUrl string = 'http://plugin_daemon:5002'
param pluginMaxPackageSize string = '52428800'
param pluginPprofEnabled string = 'false'
param pluginDebuggingHost string = '0.0.0.0'
param pluginDebuggingPort string = '5003'
param exposePluginDebuggingHost string = 'localhost'
param exposePluginDebuggingPort string = '5003'
param pluginDifyInnerApiKey string = 'QaHbTe77CtuXmsfyhR7+vRjI/+XbV1AaFy691iy+kGDv2Jvy0/eAh8Y1'
param pluginDifyInnerApiUrl string = 'http://api:5001'
param endpointUrlTemplate string = 'http://localhost/e/{hook_id}'
param marketplaceEnabled string = 'true'
param marketplaceApiUrl string = 'https://marketplace.dify.ai'
param forceVerifyingSignature string = 'true'
param pluginStdioBufferSize string = '1024'
param pluginStdioMaxBufferSize string = '5242880'
param pluginPythonEnvInitTimeout string = '120'
param pluginMaxExecutionTimeout string = '600'
// param pipMirrorUrl string = ''
param pluginStorageType string = 'local'
param pluginStorageLocalRoot string = '/app/storage'
param pluginWorkingPath string = '/app/storage/cwd'
param pluginInstalledPath string = 'plugin'
param pluginPackageCachePath string = 'plugin_packages'
param pluginMediaCachePath string = 'assets'
param pluginStorageOssBucket string = ''
param pluginS3UseAws string = 'false'
param pluginS3UseAwsManagedIam string = 'false'
param pluginS3Endpoint string = ''
param pluginS3UsePathStyle string = 'false'
param pluginAwsAccessKey string = ''
param pluginAwsSecretKey string = ''
param pluginAwsRegion string = ''
param pluginAzureBlobStorageContainerName string = ''
param pluginAzureBlobStorageConnectionString string = ''
param pluginTencentCosSecretKey string = ''
param pluginTencentCosSecretId string = ''
param pluginTencentCosRegion string = ''
param pluginAliyunOssRegion string = ''
param pluginAliyunOssEndpoint string = ''
param pluginAliyunOssAccessKeyId string = ''
param pluginAliyunOssAccessKeySecret string = ''
param pluginAliyunOssAuthVersion string = 'v4'
param pluginAliyunOssPath string = ''
param pluginVolcengineTosEndpoint string = ''
param pluginVolcengineTosAccessKey string = ''
param pluginVolcengineTosSecretKey string = ''
param pluginVolcengineTosRegion string = ''
param enableOtel string = 'false'
param otlpTraceEndpoint string = ''
param otlpMetricEndpoint string = ''
param otlpBaseEndpoint string = 'http://localhost:4318'
param otlpApiKey string = ''
param otelExporterOtlpProtocol string = ''
param otelExporterType string = 'otlp'
param otelSamplingRate string = '0.1'
param otelBatchExportScheduleDelay string = '5000'
param otelMaxQueueSize string = '2048'
param otelMaxExportBatchSize string = '512'
param otelMetricExportInterval string = '60000'
param otelBatchExportTimeout string = '10000'
param otelMetricExportTimeout string = '30000'
param allowEmbed string = 'false'
param queueMonitorThreshold string = '200'
param queueMonitorAlertEmails string = ''
param queueMonitorInterval string = '30'
param swaggerUiEnabled string = 'true'
param swaggerUiPath string = '/swagger-ui.html'
param dslExportEncryptDatasetId string = 'true'
param enableCleanEmbeddingCacheTask string = 'false'
param enableCleanUnusedDatasetsTask string = 'false'
param enableCreateTidbServerlessTask string = 'false'
param enableUpdateTidbServerlessStatusTask string = 'false'
param enableCleanMessages string = 'false'
param enableMailCleanDocumentNotifyTask string = 'false'
param enableDatasetsQueueMonitor string = 'false'
param enableCheckUpgradablePluginTask string = 'true'
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
  { name: 'CELERY_WORKER_CLASS', value: celeryWorkerClass }
  { name: 'GUNICORN_TIMEOUT', value: gunicornTimeout }
  { name: 'CELERY_WORKER_AMOUNT', value: celeryWorkerAmount }
  { name: 'CELERY_AUTO_SCALE', value: celeryAutoScale }
  { name: 'CELERY_MAX_WORKERS', value: celeryMaxWorkers }
  { name: 'CELERY_MIN_WORKERS', value: celeryMinWorkers }
  { name: 'API_TOOL_DEFAULT_CONNECT_TIMEOUT', value: apiToolDefaultConnectTimeout }
  { name: 'API_TOOL_DEFAULT_READ_TIMEOUT', value: apiToolDefaultReadTimeout }
  { name: 'ENABLE_WEBSITE_JINAREADER', value: enableWebsiteJinareader }
  { name: 'ENABLE_WEBSITE_FIRECRAWL', value: enableWebsiteFirecrawl }
  { name: 'ENABLE_WEBSITE_WATERCRAWL', value: enableWebsiteWatercrawl }
  { name: 'DB_USERNAME', value: dbUsername }
  { name: 'DB_PASSWORD', value: dbPassword }
  { name: 'DB_HOST', value: dbHost }
  { name: 'DB_PORT', value: dbPort }
  { name: 'DB_DATABASE', value: dbDatabase }
  { name: 'SQLALCHEMY_POOL_SIZE', value: sqlalchemyPoolSize }
  { name: 'SQLALCHEMY_MAX_OVERFLOW', value: sqlalchemyMaxOverflow }
  { name: 'SQLALCHEMY_POOL_RECYCLE', value: sqlalchemyPoolRecycle }
  { name: 'SQLALCHEMY_ECHO', value: sqlalchemyEcho }
  { name: 'SQLALCHEMY_POOL_PRE_PING', value: sqlalchemyPoolPrePing }
  { name: 'SQLALCHEMY_POOL_USE_LIFO', value: sqlalchemyPoolUseLifo }
  { name: 'SQLALCHEMY_POOL_TIMEOUT', value: sqlalchemyPoolTimeout }
  { name: 'POSTGRES_MAX_CONNECTIONS', value: postgresMaxConnections }
  { name: 'POSTGRES_SHARED_BUFFERS', value: postgresSharedBuffers }
  { name: 'POSTGRES_WORK_MEM', value: postgresWorkMem }
  { name: 'POSTGRES_MAINTENANCE_WORK_MEM', value: postgresMaintenanceWorkMem }
  { name: 'POSTGRES_EFFECTIVE_CACHE_SIZE', value: postgresEffectiveCacheSize }
  { name: 'REDIS_HOST', value: redisHost }
  { name: 'REDIS_PORT', value: redisPort }
  { name: 'REDIS_USERNAME', value: redisUsername }
  { name: 'REDIS_PASSWORD', value: redisPassword }
  { name: 'REDIS_USE_SSL', value: redisUseSsl }
  { name: 'REDIS_SSL_CERT_REQS', value: redisSslCertReqs }
  { name: 'REDIS_SSL_CA_CERTS', value: redisSslCaCerts }
  { name: 'REDIS_SSL_CERTFILE', value: redisSslCertfile }
  { name: 'REDIS_SSL_KEYFILE', value: redisSslKeyfile }
  { name: 'REDIS_DB', value: redisDb }
  { name: 'REDIS_USE_SENTINEL', value: redisUseSentinel }
  { name: 'REDIS_SENTINELS', value: redisSentinels }
  { name: 'REDIS_SENTINEL_SERVICE_NAME', value: redisSentinelServiceName }
  { name: 'REDIS_SENTINEL_USERNAME', value: redisSentinelUsername }
  { name: 'REDIS_SENTINEL_PASSWORD', value: redisSentinelPassword }
  { name: 'REDIS_SENTINEL_SOCKET_TIMEOUT', value: redisSentinelSocketTimeout }
  { name: 'REDIS_USE_CLUSTERS', value: redisUseClusters }
  { name: 'REDIS_CLUSTERS', value: redisClusters }
  { name: 'REDIS_CLUSTERS_PASSWORD', value: redisClustersPassword }
  { name: 'CELERY_BROKER_URL', value: celeryBrokerUrl }
  { name: 'CELERY_BACKEND', value: celeryBackend }
  { name: 'BROKER_USE_SSL', value: brokerUseSsl }
  { name: 'CELERY_USE_SENTINEL', value: celeryUseSentinel }
  { name: 'CELERY_SENTINEL_MASTER_NAME', value: celerySentinelMasterName }
  { name: 'CELERY_SENTINEL_PASSWORD', value: celerySentinelPassword }
  { name: 'CELERY_SENTINEL_SOCKET_TIMEOUT', value: celerySentinelSocketTimeout }
  { name: 'WEB_API_CORS_ALLOW_ORIGINS', value: webApiCorsAllowOrigins }
  { name: 'CONSOLE_CORS_ALLOW_ORIGINS', value: consoleCorsAllowOrigins }
  { name: 'STORAGE_TYPE', value: storageType }
  { name: 'OPENDAL_SCHEME', value: opendalScheme }
  { name: 'OPENDAL_FS_ROOT', value: opendalFsRoot }
  { name: 'CLICKZETTA_VOLUME_TYPE', value: clickzettaVolumeType }
  { name: 'CLICKZETTA_VOLUME_NAME', value: clickzettaVolumeName }
  { name: 'CLICKZETTA_VOLUME_TABLE_PREFIX', value: clickzettaVolumeTablePrefix }
  { name: 'CLICKZETTA_VOLUME_DIFY_PREFIX', value: clickzettaVolumeDifyPrefix }
  { name: 'VECTOR_STORE', value: vectorStore }
  { name: 'VECTOR_INDEX_NAME_PREFIX', value: vectorIndexNamePrefix }
  { name: 'WEAVIATE_ENDPOINT', value: weaviateEndpoint }
  { name: 'WEAVIATE_API_KEY', value: weaviateApiKey }
  { name: 'QDRANT_URL', value: qdrantUrl }
  { name: 'QDRANT_API_KEY', value: qdrantApiKey }
  { name: 'QDRANT_CLIENT_TIMEOUT', value: qdrantClientTimeout }
  { name: 'QDRANT_GRPC_ENABLED', value: qdrantGrpcEnabled }
  { name: 'QDRANT_GRPC_PORT', value: qdrantGrpcPort }
  { name: 'QDRANT_REPLICATION_FACTOR', value: qdrantReplicationFactor }
  { name: 'MILVUS_URI', value: milvusUri }
  { name: 'MILVUS_DATABASE', value: milvusDatabase }
  { name: 'MILVUS_TOKEN', value: milvusToken }
  { name: 'MILVUS_USER', value: milvusUser }
  { name: 'MILVUS_PASSWORD', value: milvusPassword }
  { name: 'MILVUS_ENABLE_HYBRID_SEARCH', value: milvusEnableHybridSearch }
  { name: 'MILVUS_ANALYZER_PARAMS', value: milvusAnalyzerParams }
  { name: 'MYSCALE_HOST', value: myscaleHost }
  { name: 'MYSCALE_PORT', value: myscalePort }
  { name: 'MYSCALE_USER', value: myscaleUser }
  { name: 'MYSCALE_PASSWORD', value: myscalePassword }
  { name: 'MYSCALE_DATABASE', value: myscaleDatabase }
  { name: 'MYSCALE_FTS_PARAMS', value: myscaleFtsParams }
  { name: 'COUCHBASE_CONNECTION_STRING', value: couchbaseConnectionString }
  { name: 'COUCHBASE_USER', value: couchbaseUser }
  { name: 'COUCHBASE_PASSWORD', value: couchbasePassword }
  { name: 'COUCHBASE_BUCKET_NAME', value: couchbaseBucketName }
  { name: 'COUCHBASE_SCOPE_NAME', value: couchbaseScopeName }
  { name: 'PGVECTOR_HOST', value: pgvectorHost }
  { name: 'PGVECTOR_PORT', value: pgvectorPort }
  { name: 'PGVECTOR_USER', value: pgvectorUser }
  { name: 'PGVECTOR_PASSWORD', value: pgvectorPassword }
  { name: 'PGVECTOR_DATABASE', value: pgvectorDatabase }
  { name: 'PGVECTOR_MIN_CONNECTION', value: pgvectorMinConnection }
  { name: 'PGVECTOR_MAX_CONNECTION', value: pgvectorMaxConnection }
  { name: 'PGVECTOR_PG_BIGM', value: pgvectorPgBigM }
  { name: 'PGVECTOR_PG_BIGM_VERSION', value: pgvectorPgBigMVersion }
  { name: 'VASTBASE_HOST', value: vastbaseHost }
  { name: 'VASTBASE_PORT', value: vastbasePort }
  { name: 'VASTBASE_USER', value: vastbaseUser }
  { name: 'VASTBASE_PASSWORD', value: vastbasePassword }
  { name: 'VASTBASE_DATABASE', value: vastbaseDatabase }
  { name: 'VASTBASE_MIN_CONNECTION', value: vastbaseMinConnection }
  { name: 'VASTBASE_MAX_CONNECTION', value: vastbaseMaxConnection }
  { name: 'PGVECTO_RS_HOST', value: pgvectoRsHost }
  { name: 'PGVECTO_RS_PORT', value: pgvectoRsPort }
  { name: 'PGVECTO_RS_USER', value: pgvectoRsUser }
  { name: 'PGVECTO_RS_PASSWORD', value: pgvectoRsPassword }
  { name: 'PGVECTO_RS_DATABASE', value: pgvectoRsDatabase }
  { name: 'ANALYTICDB_KEY_ID', value: analyticdbKeyId }
  { name: 'ANALYTICDB_KEY_SECRET', value: analyticdbKeySecret }
  { name: 'ANALYTICDB_REGION_ID', value: analyticdbRegionId }
  { name: 'ANALYTICDB_INSTANCE_ID', value: analyticdbInstanceId }
  { name: 'ANALYTICDB_ACCOUNT', value: analyticdbAccount }
  { name: 'ANALYTICDB_PASSWORD', value: analyticdbPassword }
  { name: 'ANALYTICDB_NAMESPACE', value: analyticdbNamespace }
  { name: 'ANALYTICDB_NAMESPACE_PASSWORD', value: analyticdbNamespacePassword }
  { name: 'ANALYTICDB_HOST', value: analyticdbHost }
  { name: 'ANALYTICDB_PORT', value: analyticdbPort }
  { name: 'ANALYTICDB_MIN_CONNECTION', value: analyticdbMinConnection }
  { name: 'ANALYTICDB_MAX_CONNECTION', value: analyticdbMaxConnection }
  { name: 'TIDB_VECTOR_HOST', value: tidbVectorHost }
  { name: 'TIDB_VECTOR_PORT', value: tidbVectorPort }
  { name: 'TIDB_VECTOR_USER', value: tidbVectorUser }
  { name: 'TIDB_VECTOR_PASSWORD', value: tidbVectorPassword }
  { name: 'TIDB_VECTOR_DATABASE', value: tidbVectorDatabase }
  { name: 'MATRIXONE_HOST', value: matrixoneHost }
  { name: 'MATRIXONE_PORT', value: matrixonePort }
  { name: 'MATRIXONE_USER', value: matrixoneUser }
  { name: 'MATRIXONE_PASSWORD', value: matrixonePassword }
  { name: 'MATRIXONE_DATABASE', value: matrixoneDatabase }
  { name: 'TIDB_ON_QDRANT_URL', value: tidbOnQdrantUrl }
  { name: 'TIDB_ON_QDRANT_API_KEY', value: tidbOnQdrantApiKey }
  { name: 'TIDB_ON_QDRANT_CLIENT_TIMEOUT', value: tidbOnQdrantClientTimeout }
  { name: 'TIDB_ON_QDRANT_GRPC_ENABLED', value: tidbOnQdrantGrpcEnabled }
  { name: 'TIDB_ON_QDRANT_GRPC_PORT', value: tidbOnQdrantGrpcPort }
  { name: 'TIDB_PUBLIC_KEY', value: tidbPublicKey }
  { name: 'TIDB_PRIVATE_KEY', value: tidbPrivateKey }
  { name: 'TIDB_API_URL', value: tidbApiUrl }
  { name: 'TIDB_IAM_API_URL', value: tidbIamApiUrl }
  { name: 'TIDB_REGION', value: tidbRegion }
  { name: 'TIDB_PROJECT_ID', value: tidbProjectId }
  { name: 'TIDB_SPEND_LIMIT', value: tidbSpendLimit }
  { name: 'CHROMA_HOST', value: chromaHost }
  { name: 'CHROMA_PORT', value: chromaPort }
  { name: 'CHROMA_TENANT', value: chromaTenant }
  { name: 'CHROMA_DATABASE', value: chromaDatabase }
  { name: 'CHROMA_AUTH_PROVIDER', value: chromaAuthProvider }
  { name: 'CHROMA_AUTH_CREDENTIALS', value: chromaAuthCredentials }
  { name: 'ORACLE_USER', value: oracleUser }
  { name: 'ORACLE_PASSWORD', value: oraclePassword }
  { name: 'ORACLE_DSN', value: oracleDsn }
  { name: 'ORACLE_CONFIG_DIR', value: oracleConfigDir }
  { name: 'ORACLE_WALLET_LOCATION', value: oracleWalletLocation }
  { name: 'ORACLE_WALLET_PASSWORD', value: oracleWalletPassword }
  { name: 'ORACLE_IS_AUTONOMOUS', value: oracleIsAutonomous }
  { name: 'RELYT_HOST', value: relytHost }
  { name: 'RELYT_PORT', value: relytPort }
  { name: 'RELYT_USER', value: relytUser }
  { name: 'RELYT_PASSWORD', value: relytPassword }
  { name: 'RELYT_DATABASE', value: relytDatabase }
  { name: 'OPENSEARCH_HOST', value: opensearchHost }
  { name: 'OPENSEARCH_PORT', value: opensearchPort }
  { name: 'OPENSEARCH_SECURE', value: opensearchSecure }
  { name: 'OPENSEARCH_VERIFY_CERTS', value: opensearchVerifyCerts }
  { name: 'OPENSEARCH_AUTH_METHOD', value: opensearchAuthMethod }
  { name: 'OPENSEARCH_USER', value: opensearchUser }
  { name: 'OPENSEARCH_PASSWORD', value: opensearchPassword }
  { name: 'OPENSEARCH_AWS_REGION', value: opensearchAwsRegion }
  { name: 'OPENSEARCH_AWS_SERVICE', value: opensearchAwsService }
  { name: 'TENCENT_VECTOR_DB_URL', value: tencentVectorDbUrl }
  { name: 'TENCENT_VECTOR_DB_API_KEY', value: tencentVectorDbApiKey }
  { name: 'TENCENT_VECTOR_DB_TIMEOUT', value: tencentVectorDbTimeout }
  { name: 'TENCENT_VECTOR_DB_USERNAME', value: tencentVectorDbUsername }
  { name: 'TENCENT_VECTOR_DB_DATABASE', value: tencentVectorDbDatabase }
  { name: 'TENCENT_VECTOR_DB_SHARD', value: tencentVectorDbShard }
  { name: 'TENCENT_VECTOR_DB_REPLICAS', value: tencentVectorDbReplicas }
  { name: 'TENCENT_VECTOR_DB_ENABLE_HYBRID_SEARCH', value: tencentVectorDbEnableHybridSearch }
  { name: 'ELASTICSEARCH_HOST', value: elasticsearchHost }
  { name: 'ELASTICSEARCH_PORT', value: elasticsearchPort }
  { name: 'ELASTICSEARCH_USERNAME', value: elasticsearchUsername }
  { name: 'ELASTICSEARCH_PASSWORD', value: elasticsearchPassword }
  { name: 'KIBANA_PORT', value: kibanaPort }
  { name: 'ELASTICSEARCH_USE_CLOUD', value: elasticsearchUseCloud }
  { name: 'ELASTICSEARCH_CLOUD_URL', value: elasticsearchCloudUrl }
  { name: 'ELASTICSEARCH_API_KEY', value: elasticsearchApiKey }
  { name: 'ELASTICSEARCH_VERIFY_CERTS', value: elasticsearchVerifyCerts }
  { name: 'ELASTICSEARCH_CA_CERTS', value: elasticsearchCaCerts }
  { name: 'ELASTICSEARCH_REQUEST_TIMEOUT', value: elasticsearchRequestTimeout }
  { name: 'ELASTICSEARCH_RETRY_ON_TIMEOUT', value: elasticsearchRetryOnTimeout }
  { name: 'ELASTICSEARCH_MAX_RETRIES', value: elasticsearchMaxRetries }
  { name: 'BAIDU_VECTOR_DB_ENDPOINT', value: baiduVectorDbEndpoint }
  { name: 'BAIDU_VECTOR_DB_CONNECTION_TIMEOUT_MS', value: baiduVectorDbConnectionTimeoutMs }
  { name: 'BAIDU_VECTOR_DB_ACCOUNT', value: baiduVectorDbAccount }
  { name: 'BAIDU_VECTOR_DB_API_KEY', value: baiduVectorDbApiKey }
  { name: 'BAIDU_VECTOR_DB_DATABASE', value: baiduVectorDbDatabase }
  { name: 'BAIDU_VECTOR_DB_SHARD', value: baiduVectorDbShard }
  { name: 'BAIDU_VECTOR_DB_REPLICAS', value: baiduVectorDbReplicas }
  { name: 'BAIDU_VECTOR_DB_INVERTED_INDEX_ANALYZER', value: baiduVectorDbInvertedIndexAnalyzer }
  { name: 'BAIDU_VECTOR_DB_INVERTED_INDEX_PARSER_MODE', value: baiduVectorDbInvertedIndexParserMode }
  { name: 'VIKINGDB_ACCESS_KEY', value: vikingdbAccessKey }
  { name: 'VIKINGDB_SECRET_KEY', value: vikingdbSecretKey }
  { name: 'VIKINGDB_REGION', value: vikingdbRegion }
  { name: 'VIKINGDB_HOST', value: vikingdbHost }
  { name: 'VIKINGDB_SCHEMA', value: vikingdbSchema }
  { name: 'VIKINGDB_CONNECTION_TIMEOUT', value: vikingdbConnectionTimeout }
  { name: 'VIKINGDB_SOCKET_TIMEOUT', value: vikingdbSocketTimeout }
  { name: 'LINDORM_URL', value: lindormUrl }
  { name: 'LINDORM_USERNAME', value: lindormUsername }
  { name: 'LINDORM_PASSWORD', value: lindormPassword }
  { name: 'LINDORM_USING_UGC', value: lindormUsingUgc }
  { name: 'LINDORM_QUERY_TIMEOUT', value: lindormQueryTimeout }
  { name: 'OCEANBASE_VECTOR_HOST', value: oceanbaseVectorHost }
  { name: 'OCEANBASE_VECTOR_PORT', value: oceanbaseVectorPort }
  { name: 'OCEANBASE_VECTOR_USER', value: oceanbaseVectorUser }
  { name: 'OCEANBASE_VECTOR_PASSWORD', value: oceanbaseVectorPassword }
  { name: 'OCEANBASE_VECTOR_DATABASE', value: oceanbaseVectorDatabase }
  { name: 'OCEANBASE_CLUSTER_NAME', value: oceanbaseClusterName }
  { name: 'OCEANBASE_MEMORY_LIMIT', value: oceanbaseMemoryLimit }
  { name: 'OCEANBASE_ENABLE_HYBRID_SEARCH', value: oceanbaseEnableHybridSearch }
  { name: 'OCEANBASE_FULLTEXT_PARSER', value: oceanbaseFulltextParser }
  { name: 'OPENGAUSS_HOST', value: opengaussHost }
  { name: 'OPENGAUSS_PORT', value: opengaussPort }
  { name: 'OPENGAUSS_USER', value: opengaussUser }
  { name: 'OPENGAUSS_PASSWORD', value: opengaussPassword }
  { name: 'OPENGAUSS_DATABASE', value: opengaussDatabase }
  { name: 'OPENGAUSS_MIN_CONNECTION', value: opengaussMinConnection }
  { name: 'OPENGAUSS_MAX_CONNECTION', value: opengaussMaxConnection }
  { name: 'OPENGAUSS_ENABLE_PQ', value: opengaussEnablePq }
  { name: 'HUAWEI_CLOUD_HOSTS', value: huaweiCloudHosts }
  { name: 'HUAWEI_CLOUD_USER', value: huaweiCloudUser }
  { name: 'HUAWEI_CLOUD_PASSWORD', value: huaweiCloudPassword }
  { name: 'UPSTASH_VECTOR_URL', value: upstashVectorUrl }
  { name: 'UPSTASH_VECTOR_TOKEN', value: upstashVectorToken }
  { name: 'TABLESTORE_ENDPOINT', value: tablstoreEndpoint }
  { name: 'TABLESTORE_INSTANCE_NAME', value: tablstoreInstanceName }
  { name: 'TABLESTORE_ACCESS_KEY_ID', value: tablstoreAccessKeyId }
  { name: 'TABLESTORE_ACCESS_KEY_SECRET', value: tablstoreAccessKeySecret }
  { name: 'TABLESTORE_NORMALIZE_FULLTEXT_BM25_SCORE', value: tablstoreNormalizeFulltextBm25Score }
  { name: 'CLICKZETTA_USERNAME', value: clickzettaUsername }
  { name: 'CLICKZETTA_PASSWORD', value: clickzettaPassword }
  { name: 'CLICKZETTA_INSTANCE', value: clickzettaInstance }
  { name: 'CLICKZETTA_SERVICE', value: clickzettaService }
  { name: 'CLICKZETTA_WORKSPACE', value: clickzettaWorkspace }
  { name: 'CLICKZETTA_VCLUSTER', value: clickzettaVcluster }
  { name: 'CLICKZETTA_SCHEMA', value: clickzettaSchema }
  { name: 'CLICKZETTA_BATCH_SIZE', value: clickzettaBatchSize }
  { name: 'CLICKZETTA_ENABLE_INVERTED_INDEX', value: clickzettaEnableInvertedIndex }
  { name: 'CLICKZETTA_ANALYZER_TYPE', value: clickzettaAnalyzerType }
  { name: 'CLICKZETTA_ANALYZER_MODE', value: clickzettaAnalyzerMode }
  { name: 'CLICKZETTA_VECTOR_DISTANCE_FUNCTION', value: clickzettaVectorDistanceFunction }
  { name: 'UPLOAD_FILE_SIZE_LIMIT', value: uploadFileSizeLimit }
  { name: 'UPLOAD_FILE_BATCH_LIMIT', value: uploadFileBatchLimit }
  { name: 'ETL_TYPE', value: etlType }
  { name: 'UNSTRUCTURED_API_URL', value: unstructuredApiUrl }
  { name: 'UNSTRUCTURED_API_KEY', value: unstructuredApiKey }
  { name: 'SCARF_NO_ANALYTICS', value: scarfNoAnalytics }
  { name: 'PROMPT_GENERATION_MAX_TOKENS', value: promptGenerationMaxTokens }
  { name: 'CODE_GENERATION_MAX_TOKENS', value: codeGenerationMaxTokens }
  { name: 'PLUGIN_BASED_TOKEN_COUNTING_ENABLED', value: pluginBasedTokenCountingEnabled }
  { name: 'MULTIMODAL_SEND_FORMAT', value: multimodalSendFormat }
  { name: 'UPLOAD_IMAGE_FILE_SIZE_LIMIT', value: uploadImageFileSizeLimit }
  { name: 'UPLOAD_VIDEO_FILE_SIZE_LIMIT', value: uploadVideoFileSizeLimit }
  { name: 'UPLOAD_AUDIO_FILE_SIZE_LIMIT', value: uploadAudioFileSizeLimit }
  { name: 'SENTRY_DSN', value: sentryDsn }
  { name: 'API_SENTRY_DSN', value: apiSentryDsn }
  { name: 'API_SENTRY_TRACES_SAMPLE_RATE', value: apiSentryTracesSampleRate }
  { name: 'API_SENTRY_PROFILES_SAMPLE_RATE', value: apiSentryProfilesSampleRate }
  { name: 'WEB_SENTRY_DSN', value: webSentryDsn }
  { name: 'PLUGIN_SENTRY_ENABLED', value: pluginSentryEnabled }
  { name: 'PLUGIN_SENTRY_DSN', value: pluginSentryDsn }
  { name: 'NOTION_INTEGRATION_TYPE', value: notionIntegrationType }
  { name: 'NOTION_CLIENT_SECRET', value: notionClientSecret }
  { name: 'NOTION_CLIENT_ID', value: notionClientId }
  { name: 'NOTION_INTERNAL_SECRET', value: notionInternalSecret }
  { name: 'MAIL_TYPE', value: mailType }
  { name: 'MAIL_DEFAULT_SEND_FROM', value: mailDefaultSendFrom }
  { name: 'RESEND_API_URL', value: resendApiUrl }
  { name: 'RESEND_API_KEY', value: resendApiKey }
  { name: 'SMTP_SERVER', value: smtpServer }
  { name: 'SMTP_PORT', value: smtpPort }
  { name: 'SMTP_USERNAME', value: smtpUsername }
  { name: 'SMTP_PASSWORD', value: smtpPassword }
  { name: 'SMTP_USE_TLS', value: smtpUseTls }
  { name: 'SMTP_OPPORTUNISTIC_TLS', value: smtpOpportunisticTls }
  { name: 'SENDGRID_API_KEY', value: sendgridApiKey }
  { name: 'INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH', value: indexingMaxSegmentationTokensLength }
  { name: 'INVITE_EXPIRY_HOURS', value: inviteExpiryHours }
  { name: 'RESET_PASSWORD_TOKEN_EXPIRY_MINUTES', value: resetPasswordTokenExpiryMinutes }
  { name: 'EMAIL_REGISTER_TOKEN_EXPIRY_MINUTES', value: emailRegisterTokenExpiryMinutes }
  { name: 'CHANGE_EMAIL_TOKEN_EXPIRY_MINUTES', value: changeEmailTokenExpiryMinutes }
  { name: 'OWNER_TRANSFER_TOKEN_EXPIRY_MINUTES', value: ownerTransferTokenExpiryMinutes }
  { name: 'CODE_EXECUTION_ENDPOINT', value: codeExecutionEndpoint }
  { name: 'CODE_EXECUTION_API_KEY', value: codeExecutionApiKey }
  { name: 'CODE_EXECUTION_SSL_VERIFY', value: codeExecutionSslVerify }
  { name: 'CODE_EXECUTION_POOL_MAX_CONNECTIONS', value: codeExecutionPoolMaxConnections }
  { name: 'CODE_EXECUTION_POOL_MAX_KEEPALIVE_CONNECTIONS', value: codeExecutionPoolMaxKeepaliveConnections }
  { name: 'CODE_EXECUTION_POOL_KEEPALIVE_EXPIRY', value: codeExecutionPoolKeepaliveExpiry }
  { name: 'CODE_MAX_NUMBER', value: codeMaxNumber }
  { name: 'CODE_MIN_NUMBER', value: codeMinNumber }
  { name: 'CODE_MAX_DEPTH', value: codeMaxDepth }
  { name: 'CODE_MAX_PRECISION', value: codeMaxPrecision }
  { name: 'CODE_MAX_STRING_LENGTH', value: codeMaxStringLength }
  { name: 'CODE_MAX_STRING_ARRAY_LENGTH', value: codeMaxStringArrayLength }
  { name: 'CODE_MAX_OBJECT_ARRAY_LENGTH', value: codeMaxObjectArrayLength }
  { name: 'CODE_MAX_NUMBER_ARRAY_LENGTH', value: codeMaxNumberArrayLength }
  { name: 'CODE_EXECUTION_CONNECT_TIMEOUT', value: codeExecutionConnectTimeout }
  { name: 'CODE_EXECUTION_READ_TIMEOUT', value: codeExecutionReadTimeout }
  { name: 'CODE_EXECUTION_WRITE_TIMEOUT', value: codeExecutionWriteTimeout }
  { name: 'TEMPLATE_TRANSFORM_MAX_LENGTH', value: templateTransformMaxLength }
  { name: 'WORKFLOW_MAX_EXECUTION_STEPS', value: workflowMaxExecutionSteps }
  { name: 'WORKFLOW_MAX_EXECUTION_TIME', value: workflowMaxExecutionTime }
  { name: 'WORKFLOW_CALL_MAX_DEPTH', value: workflowCallMaxDepth }
  { name: 'MAX_VARIABLE_SIZE', value: maxVariableSize }
  { name: 'WORKFLOW_PARALLEL_DEPTH_LIMIT', value: workflowParallelDepthLimit }
  { name: 'WORKFLOW_FILE_UPLOAD_LIMIT', value: workflowFileUploadLimit }
  { name: 'GRAPH_ENGINE_MIN_WORKERS', value: graphEngineMinWorkers }
  { name: 'GRAPH_ENGINE_MAX_WORKERS', value: graphEngineMaxWorkers }
  { name: 'GRAPH_ENGINE_SCALE_UP_THRESHOLD', value: graphEngineScaleUpThreshold }
  { name: 'GRAPH_ENGINE_SCALE_DOWN_IDLE_TIME', value: graphEngineScaleDownIdleTime }
  { name: 'WORKFLOW_NODE_EXECUTION_STORAGE', value: workflowNodeExecutionStorage }
  { name: 'CORE_WORKFLOW_EXECUTION_REPOSITORY', value: coreWorkflowExecutionRepository }
  { name: 'CORE_WORKFLOW_NODE_EXECUTION_REPOSITORY', value: coreWorkflowNodeExecutionRepository }
  { name: 'API_WORKFLOW_RUN_REPOSITORY', value: apiWorkflowRunRepository }
  { name: 'API_WORKFLOW_NODE_EXECUTION_REPOSITORY', value: apiWorkflowNodeExecutionRepository }
  { name: 'WORKFLOW_LOG_CLEANUP_ENABLED', value: workflowLogCleanupEnabled }
  { name: 'WORKFLOW_LOG_RETENTION_DAYS', value: workflowLogRetentionDays }
  { name: 'WORKFLOW_LOG_CLEANUP_BATCH_SIZE', value: workflowLogCleanupBatchSize }
  { name: 'HTTP_REQUEST_NODE_MAX_BINARY_SIZE', value: httpRequestNodeMaxBinarySize }
  { name: 'HTTP_REQUEST_NODE_MAX_TEXT_SIZE', value: httpRequestNodeMaxTextSize }
  { name: 'HTTP_REQUEST_NODE_SSL_VERIFY', value: httpRequestNodeSslVerify }
  { name: 'RESPECT_XFORWARD_HEADERS_ENABLED', value: respectXforwardHeadersEnabled }
  { name: 'SSRF_PROXY_HTTP_URL', value: ssrfProxyHttpUrl }
  { name: 'SSRF_PROXY_HTTPS_URL', value: ssrfProxyHttpsUrl }
  { name: 'LOOP_NODE_MAX_COUNT', value: loopNodeMaxCount }
  { name: 'MAX_TOOLS_NUM', value: maxToolsNum }
  { name: 'MAX_PARALLEL_LIMIT', value: maxParallelLimit }
  { name: 'MAX_ITERATIONS_NUM', value: maxIterationsNum }
  { name: 'TEXT_GENERATION_TIMEOUT_MS', value: textGenerationTimeoutMs }
  { name: 'ALLOW_UNSAFE_DATA_SCHEME', value: allowUnsafeDataScheme }
  { name: 'MAX_TREE_DEPTH', value: maxTreeDepth }
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
  { name: 'CHROMA_SERVER_AUTHN_CREDENTIALS', value: chromaServerAuthnCredentials }
  { name: 'CHROMA_SERVER_AUTHN_PROVIDER', value: chromaServerAuthnProvider }
  { name: 'CHROMA_IS_PERSISTENT', value: chromaIsPersistent }
  { name: 'ORACLE_PWD', value: oraclePwd }
  { name: 'ORACLE_CHARACTERSET', value: oracleCharacterset }
  { name: 'ETCD_AUTO_COMPACTION_MODE', value: etcdAutoCompactionMode }
  { name: 'ETCD_AUTO_COMPACTION_RETENTION', value: etcdAutoCompactionRetention }
  { name: 'ETCD_QUOTA_BACKEND_BYTES', value: etcdQuotaBackendBytes }
  { name: 'ETCD_SNAPSHOT_COUNT', value: etcdSnapshotCount }
  { name: 'MINIO_ACCESS_KEY', value: minioAccessKey }
  { name: 'MINIO_SECRET_KEY', value: minioSecretKey }
  { name: 'ETCD_ENDPOINTS', value: etcdEndpoints }
  { name: 'MINIO_ADDRESS', value: minioAddress }
  { name: 'MILVUS_AUTHORIZATION_ENABLED', value: milvusAuthorizationEnabled }
  { name: 'PGVECTOR_PGUSER', value: pgvectorPguser }
  { name: 'PGVECTOR_POSTGRES_PASSWORD', value: pgvectorPostgresPassword }
  { name: 'PGVECTOR_POSTGRES_DB', value: pgvectorPostgresDb }
  { name: 'PGVECTOR_PGDATA', value: pgvectorPgdata }
  { name: 'OPENSEARCH_DISCOVERY_TYPE', value: opensearchDiscoveryType }
  { name: 'OPENSEARCH_BOOTSTRAP_MEMORY_LOCK', value: opensearchBootstrapMemoryLock }
  { name: 'OPENSEARCH_JAVA_OPTS_MIN', value: opensearchJavaOptsMin }
  { name: 'OPENSEARCH_JAVA_OPTS_MAX', value: opensearchJavaOptsMax }
  { name: 'OPENSEARCH_INITIAL_ADMIN_PASSWORD', value: opensearchInitialAdminPassword }
  { name: 'OPENSEARCH_MEMLOCK_SOFT', value: opensearchMemlockSoft }
  { name: 'OPENSEARCH_MEMLOCK_HARD', value: opensearchMemlockHard }
  { name: 'OPENSEARCH_NOFILE_SOFT', value: opensearchNofileSoft }
  { name: 'OPENSEARCH_NOFILE_HARD', value: opensearchNofileHard }
  { name: 'NGINX_SERVER_NAME', value: nginxServerName }
  { name: 'NGINX_HTTPS_ENABLED', value: nginxHttpsEnabled }
  { name: 'NGINX_PORT', value: nginxPort }
  { name: 'NGINX_SSL_PORT', value: nginxSslPort }
  { name: 'NGINX_SSL_CERT_FILENAME', value: nginxSslCertFilename }
  { name: 'NGINX_SSL_CERT_KEY_FILENAME', value: nginxSslCertKeyFilename }
  { name: 'NGINX_SSL_PROTOCOLS', value: nginxSslProtocols }
  { name: 'NGINX_WORKER_PROCESSES', value: nginxWorkerProcesses }
  { name: 'NGINX_CLIENT_MAX_BODY_SIZE', value: nginxClientMaxBodySize }
  { name: 'NGINX_KEEPALIVE_TIMEOUT', value: nginxKeepaliveTimeout }
  { name: 'NGINX_PROXY_READ_TIMEOUT', value: nginxProxyReadTimeout }
  { name: 'NGINX_PROXY_SEND_TIMEOUT', value: nginxProxySendTimeout }
  { name: 'NGINX_ENABLE_CERTBOT_CHALLENGE', value: nginxEnableCertbotChallenge }
  { name: 'CERTBOT_EMAIL', value: certbotEmail }
  { name: 'CERTBOT_DOMAIN', value: certbotDomain }
  { name: 'CERTBOT_OPTIONS', value: certbotOptions }
  { name: 'SSRF_HTTP_PORT', value: ssrfHttpPort }
  { name: 'SSRF_COREDUMP_DIR', value: ssrfCoredumpDir }
  { name: 'SSRF_REVERSE_PROXY_PORT', value: ssrfReverseProxyPort }
  { name: 'SSRF_SANDBOX_HOST', value: ssrfSandboxHost }
  { name: 'SSRF_DEFAULT_TIME_OUT', value: ssrfDefaultTimeOut }
  { name: 'SSRF_DEFAULT_CONNECT_TIME_OUT', value: ssrfDefaultConnectTimeOut }
  { name: 'SSRF_DEFAULT_READ_TIME_OUT', value: ssrfDefaultReadTimeOut }
  { name: 'SSRF_DEFAULT_WRITE_TIME_OUT', value: ssrfDefaultWriteTimeOut }
  { name: 'SSRF_POOL_MAX_CONNECTIONS', value: ssrfPoolMaxConnections }
  { name: 'SSRF_POOL_MAX_KEEPALIVE_CONNECTIONS', value: ssrfPoolMaxKeepaliveConnections }
  { name: 'SSRF_POOL_KEEPALIVE_EXPIRY', value: ssrfPoolKeepaliveExpiry }
  { name: 'EXPOSE_NGINX_PORT', value: exposeNginxPort }
  { name: 'EXPOSE_NGINX_SSL_PORT', value: exposeNginxSslPort }
  { name: 'POSITION_TOOL_PINS', value: positionToolPins }
  { name: 'POSITION_TOOL_INCLUDES', value: positionToolIncludes }
  { name: 'POSITION_TOOL_EXCLUDES', value: positionToolExcludes }
  { name: 'POSITION_PROVIDER_PINS', value: positionProviderPins }
  { name: 'POSITION_PROVIDER_INCLUDES', value: positionProviderIncludes }
  { name: 'POSITION_PROVIDER_EXCLUDES', value: positionProviderExcludes }
  { name: 'CSP_WHITELIST', value: cspWhitelist }
  { name: 'CREATE_TIDB_SERVICE_JOB_ENABLED', value: createTidbServiceJobEnabled }
  { name: 'MAX_SUBMIT_COUNT', value: maxSubmitCount }
  { name: 'TOP_K_MAX_VALUE', value: topKMaxValue }
  { name: 'DB_PLUGIN_DATABASE', value: dbPluginDatabase }
  { name: 'EXPOSE_PLUGIN_DAEMON_PORT', value: exposePluginDaemonPort }
  { name: 'PLUGIN_DAEMON_PORT', value: pluginDaemonPort }
  { name: 'PLUGIN_DAEMON_KEY', value: pluginDaemonKey }
  { name: 'PLUGIN_DAEMON_URL', value: pluginDaemonUrl }
  { name: 'PLUGIN_MAX_PACKAGE_SIZE', value: pluginMaxPackageSize }
  { name: 'PLUGIN_PPROF_ENABLED', value: pluginPprofEnabled }
  { name: 'PLUGIN_DEBUGGING_HOST', value: pluginDebuggingHost }
  { name: 'PLUGIN_DEBUGGING_PORT', value: pluginDebuggingPort }
  { name: 'EXPOSE_PLUGIN_DEBUGGING_HOST', value: exposePluginDebuggingHost }
  { name: 'EXPOSE_PLUGIN_DEBUGGING_PORT', value: exposePluginDebuggingPort }
  { name: 'PLUGIN_DIFY_INNER_API_KEY', value: pluginDifyInnerApiKey }
  { name: 'PLUGIN_DIFY_INNER_API_URL', value: pluginDifyInnerApiUrl }
  { name: 'ENDPOINT_URL_TEMPLATE', value: endpointUrlTemplate }
  { name: 'MARKETPLACE_ENABLED', value: marketplaceEnabled }
  { name: 'MARKETPLACE_API_URL', value: marketplaceApiUrl }
  { name: 'FORCE_VERIFYING_SIGNATURE', value: forceVerifyingSignature }
  { name: 'PLUGIN_STDIO_BUFFER_SIZE', value: pluginStdioBufferSize }
  { name: 'PLUGIN_STDIO_MAX_BUFFER_SIZE', value: pluginStdioMaxBufferSize }
  { name: 'PLUGIN_PYTHON_ENV_INIT_TIMEOUT', value: pluginPythonEnvInitTimeout }
  { name: 'PLUGIN_MAX_EXECUTION_TIMEOUT', value: pluginMaxExecutionTimeout }
  { name: 'PIP_MIRROR_URL', value: pipMirrorUrl }
  { name: 'PLUGIN_STORAGE_TYPE', value: pluginStorageType }
  { name: 'PLUGIN_STORAGE_LOCAL_ROOT', value: pluginStorageLocalRoot }
  { name: 'PLUGIN_WORKING_PATH', value: pluginWorkingPath }
  { name: 'PLUGIN_INSTALLED_PATH', value: pluginInstalledPath }
  { name: 'PLUGIN_PACKAGE_CACHE_PATH', value: pluginPackageCachePath }
  { name: 'PLUGIN_MEDIA_CACHE_PATH', value: pluginMediaCachePath }
  { name: 'PLUGIN_STORAGE_OSS_BUCKET', value: pluginStorageOssBucket }
  { name: 'PLUGIN_S3_USE_AWS', value: pluginS3UseAws }
  { name: 'PLUGIN_S3_USE_AWS_MANAGED_IAM', value: pluginS3UseAwsManagedIam }
  { name: 'PLUGIN_S3_ENDPOINT', value: pluginS3Endpoint }
  { name: 'PLUGIN_S3_USE_PATH_STYLE', value: pluginS3UsePathStyle }
  { name: 'PLUGIN_AWS_ACCESS_KEY', value: pluginAwsAccessKey }
  { name: 'PLUGIN_AWS_SECRET_KEY', value: pluginAwsSecretKey }
  { name: 'PLUGIN_AWS_REGION', value: pluginAwsRegion }
  { name: 'PLUGIN_AZURE_BLOB_STORAGE_CONTAINER_NAME', value: pluginAzureBlobStorageContainerName }
  { name: 'PLUGIN_AZURE_BLOB_STORAGE_CONNECTION_STRING', value: pluginAzureBlobStorageConnectionString }
  { name: 'PLUGIN_TENCENT_COS_SECRET_KEY', value: pluginTencentCosSecretKey }
  { name: 'PLUGIN_TENCENT_COS_SECRET_ID', value: pluginTencentCosSecretId }
  { name: 'PLUGIN_TENCENT_COS_REGION', value: pluginTencentCosRegion }
  { name: 'PLUGIN_ALIYUN_OSS_REGION', value: pluginAliyunOssRegion }
  { name: 'PLUGIN_ALIYUN_OSS_ENDPOINT', value: pluginAliyunOssEndpoint }
  { name: 'PLUGIN_ALIYUN_OSS_ACCESS_KEY_ID', value: pluginAliyunOssAccessKeyId }
  { name: 'PLUGIN_ALIYUN_OSS_ACCESS_KEY_SECRET', value: pluginAliyunOssAccessKeySecret }
  { name: 'PLUGIN_ALIYUN_OSS_AUTH_VERSION', value: pluginAliyunOssAuthVersion }
  { name: 'PLUGIN_ALIYUN_OSS_PATH', value: pluginAliyunOssPath }
  { name: 'PLUGIN_VOLCENGINE_TOS_ENDPOINT', value: pluginVolcengineTosEndpoint }
  { name: 'PLUGIN_VOLCENGINE_TOS_ACCESS_KEY', value: pluginVolcengineTosAccessKey }
  { name: 'PLUGIN_VOLCENGINE_TOS_SECRET_KEY', value: pluginVolcengineTosSecretKey }
  { name: 'PLUGIN_VOLCENGINE_TOS_REGION', value: pluginVolcengineTosRegion }
  { name: 'ENABLE_OTEL', value: enableOtel }
  { name: 'OTLP_TRACE_ENDPOINT', value: otlpTraceEndpoint }
  { name: 'OTLP_METRIC_ENDPOINT', value: otlpMetricEndpoint }
  { name: 'OTLP_BASE_ENDPOINT', value: otlpBaseEndpoint }
  { name: 'OTLP_API_KEY', value: otlpApiKey }
  { name: 'OTEL_EXPORTER_OTLP_PROTOCOL', value: otelExporterOtlpProtocol }
  { name: 'OTEL_EXPORTER_TYPE', value: otelExporterType }
  { name: 'OTEL_SAMPLING_RATE', value: otelSamplingRate }
  { name: 'OTEL_BATCH_EXPORT_SCHEDULE_DELAY', value: otelBatchExportScheduleDelay }
  { name: 'OTEL_MAX_QUEUE_SIZE', value: otelMaxQueueSize }
  { name: 'OTEL_MAX_EXPORT_BATCH_SIZE', value: otelMaxExportBatchSize }
  { name: 'OTEL_METRIC_EXPORT_INTERVAL', value: otelMetricExportInterval }
  { name: 'OTEL_BATCH_EXPORT_TIMEOUT', value: otelBatchExportTimeout }
  { name: 'OTEL_METRIC_EXPORT_TIMEOUT', value: otelMetricExportTimeout }
  { name: 'ALLOW_EMBED', value: allowEmbed }
  { name: 'QUEUE_MONITOR_THRESHOLD', value: queueMonitorThreshold }
  { name: 'QUEUE_MONITOR_ALERT_EMAILS', value: queueMonitorAlertEmails }
  { name: 'QUEUE_MONITOR_INTERVAL', value: queueMonitorInterval }
  { name: 'SWAGGER_UI_ENABLED', value: swaggerUiEnabled }
  { name: 'SWAGGER_UI_PATH', value: swaggerUiPath }
  { name: 'DSL_EXPORT_ENCRYPT_DATASET_ID', value: dslExportEncryptDatasetId }
  { name: 'ENABLE_CLEAN_EMBEDDING_CACHE_TASK', value: enableCleanEmbeddingCacheTask }
  { name: 'ENABLE_CLEAN_UNUSED_DATASETS_TASK', value: enableCleanUnusedDatasetsTask }
  { name: 'ENABLE_CREATE_TIDB_SERVERLESS_TASK', value: enableCreateTidbServerlessTask }
  { name: 'ENABLE_UPDATE_TIDB_SERVERLESS_STATUS_TASK', value: enableUpdateTidbServerlessStatusTask }
  { name: 'ENABLE_CLEAN_MESSAGES', value: enableCleanMessages }
  { name: 'ENABLE_MAIL_CLEAN_DOCUMENT_NOTIFY_TASK', value: enableMailCleanDocumentNotifyTask }
  { name: 'ENABLE_DATASETS_QUEUE_MONITOR', value: enableDatasetsQueueMonitor }
  { name: 'ENABLE_CHECK_UPGRADABLE_PLUGIN_TASK', value: enableCheckUpgradablePluginTask }
]

// param containerAppApiName string = 'api'
// param difyImageName string = 'docker.io/langgenius/dify-api:1.9.0'
// param apiSentryDsn string = ''
// param apiSentryTracesSampleRate string = '1.0'
// param apiSentryProfilesSampleRate string = '1.0'
// param exposePluginDebuggingHost string = 'localhost'
// param exposePluginDebuggingPort string = '5003'
// param pluginMaxPackageSize string = '52428800'
// param pluginDifyInnerApiKey string = 'QaHbTe77CtuXmsfyhR7+vRjI/+XbV1AaFy691iy+kGDv2Jvy0/eAh8Y1'
// resource containerAppApi 'Microsoft.App/containerApps@2025-02-02-preview' = {
//   name: containerAppApiName
//   location: resourceGroup().location
//   kind: 'containerapps'
//   properties: {
//     environmentId: containerAppsEnvironment.id
//     workloadProfileName: 'Consumption'
//     configuration: {
//       ingress: {
//         external: true
//         targetPort: 5001
//         exposedPort: 0
//         transport: 'Auto'
//         traffic: [
//           {
//             weight: 100
//             latestRevision: true
//           }
//         ]
//         allowInsecure: false
//         stickySessions: {
//           affinity: 'none'
//         }
//       }
//     }
//     template: {
//       containers: [
//         {
//           name: 'api'
//           image: difyImageName
//           imageType: 'ContainerImage'
//           env: concat(sharedApiWorkerEnv, [
//             { name: 'MODE', value: 'api' }
//             { name: 'SENTRY_DSN', value: apiSentryDsn }
//             { name: 'SENTRY_TRACES_SAMPLE_RATE', value: apiSentryTracesSampleRate }
//             { name: 'SENTRY_PROFILES_SAMPLE_RATE', value: apiSentryProfilesSampleRate }
//             { name: 'PLUGIN_REMOTE_INSTALL_HOST', value: exposePluginDebuggingHost }
//             { name: 'PLUGIN_REMOTE_INSTALL_PORT', value: exposePluginDebuggingPort }
//             { name: 'PLUGIN_MAX_PACKAGE_SIZE', value: pluginMaxPackageSize }
//             { name: 'INNER_API_KEY_FOR_PLUGIN', value: pluginDifyInnerApiKey }
//           ])
//           resources: {
//             cpu: json('0.5')
//             memory: '1Gi'
//           }
//           probes: []
//           volumeMounts: [
//             {
//               volumeName: 'volume-app-storage'
//               mountPath: '/app/api/storage'
//             }
//           ]
//         }
//         {
//           name: 'worker'
//           image: difyImageName
//           imageType: 'ContainerImage'
//           env: concat(sharedApiWorkerEnv, [
//             { name: 'MODE', value: 'worker' }
//             { name: 'SENTRY_DSN', value: apiSentryDsn }
//             { name: 'SENTRY_TRACES_SAMPLE_RATE', value: apiSentryTracesSampleRate }
//             { name: 'SENTRY_PROFILES_SAMPLE_RATE', value: apiSentryProfilesSampleRate }
//             { name: 'PLUGIN_MAX_PACKAGE_SIZE', value: pluginMaxPackageSize }
//             { name: 'INNER_API_KEY_FOR_PLUGIN', value: pluginDifyInnerApiKey }
//           ])
//           resources: {
//             cpu: json('0.5')
//             memory: '1Gi'
//           }
//           probes: []
//           volumeMounts: [
//             {
//               volumeName: 'volume-app-storage'
//               mountPath: '/app/api/storage'
//             }
//           ]
//         }
//         {
//           name: 'worker-beat'
//           image: difyImageName
//           imageType: 'ContainerImage'
//           env: concat(sharedApiWorkerEnv, [
//             { name: 'MODE', value: 'beat' }
//           ])
//           resources: {
//             cpu: json('0.5')
//             memory: '1Gi'
//           }
//           probes: []
//         }
//       ]
//       scale: {
//         minReplicas: 1
//         maxReplicas: 1
//         cooldownPeriod: 300
//         pollingInterval: 30
//       }
//       volumes: [
//         {
//           name: 'volume-app-storage'
//           storageType: 'EmptyDir'
//         }
//       ]
//     }
//   }
// }
