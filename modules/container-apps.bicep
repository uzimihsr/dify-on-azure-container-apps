param containerAppsEnvironmentName string
param storageNameSsrfProxy string
param storageNameDifySandbox string
param storageNameDifyApi string
param storageNameDifyPluginDaemon string
param storageNameNginx string

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2025-02-02-preview' existing = {
  name: containerAppsEnvironmentName
}

param containerAppNameDb string = 'db'
param containerAppNameRedis string = 'redis'
param containerAppNameWeaviate string = 'weaviate'
param containerAppNameSsrfProxy string = 'ssrf-proxy'
param containerAppNameSandbox string = 'sandbox'
param containerAppNameApi string = 'api'
param containerAppNameWorker string = 'worker'
param containerAppNameBeat string = 'worker-beat'
param containerAppNameWeb string = 'web'
param containerAppNamePluginDaemon string = 'plugin-daemon'
param containerAppNameNginx string = 'nginx'

param difyImageName string = 'docker.io/langgenius/dify-api:1.9.0'
param difyPluginDaemonImageName string = 'docker.io/langgenius/dify-plugin-daemon:0.3.0-local'
param nginxImageName string = 'docker.io/nginx:latest'

// https://github.com/langgenius/dify/blob/f104839672ccf111b2799fc31a85870e5e997b7d/docker/docker-compose.yaml#L7-L598
var consoleApiUrl string = ''
var appApiUrl string = ''
var textGenerationTimeoutMs string = '60000'
var cspWhitelist string = ''
var allowEmbed string = 'false'
var allowUnsafeDataScheme string = 'false'
var marketplaceApiUrl string = 'https://marketplace.dify.ai'
var topKMaxValue string = '10'
var indexingMaxSegmentationTokensLength string = '4000'
var loopNodeMaxCount string = '100'
var maxToolsNum string = '10'
var maxParallelLimit string = '10'
var maxIterationsNum string = '99'
var maxTreeDepth string = '50'
var enableWebsiteJinareader string = 'true'
var enableWebsiteFirecrawl string = 'true'
var enableWebsiteWatercrawl string = 'true'
var dbUserName string = 'postgres'
var dbPassword string = 'difyai123456'
var dbDatabase string = 'dify'
var pgdata string = '/var/lib/postgresql/data/pgdata'
var postgresMaxConnections string = '100'
var postgresSharedBuffers string = '128MB'
var postgresWorkMem string = '4MB'
var postgresMaintenanceWorkMem string = '64MB'
var postgresEffectiveCacheSize string = '4096MB'
var redisPassword string = 'difyai123456'
var weaviatePersistenceDataPath string = '/var/lib/weaviate'
var weaviateQueryDefaultsLimit string = '25'
var weaviateAuthenticationAnonymousAccessEnabled string = 'true'
var weaviateDefaultVectorizerModule string = 'none'
var weaviateClusterHostname string = 'node1'
var weaviateAuthenticationApikeyEnabled string = 'true'
var weaviateAuthenticationApikeyAllowedKeys string = 'WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih'
var weaviateAuthenticationApikeyUsers string = 'hello@dify.ai'
var weaviateAuthorizationAdminlistEnabled string = 'true'
var weaviateAuthorizationAdminlistUsers string = 'hello@dify.ai'
var ssrfHttpPort string = '3128'
var ssrfCoredumpDir string = '/var/spool/squid'
var ssrfReverseProxyPort string = '8194'
var ssrfSandboxHost string = containerAppNameSandbox // 'sandbox'
var sandboxApiKey string = 'dify-sandbox'
var sandboxGinMode string = 'release'
var sandboxWorkerTimeout string = '15'
var sandboxEnableNetwork string = 'true'
var sandboxHttpProxy string = 'http://${containerAppNameSsrfProxy}:3128' // 'http://ssrf_proxy:3128'
var sandboxHttpsProxy string = 'http://${containerAppNameSsrfProxy}:3128' // 'http://ssrf_proxy:3128'
var sandboxPort string = '8194'
var pipMirrorUrl string = ''
var apiSentryDsn string = ''
var apiSentryTracesSampleRate string = '1.0'
var apiSentryProfilesSampleRate string = '1.0'
var pluginMaxPackageSize string = '52428800'
var pluginDifyInnerApiKey string = 'QaHbTe77CtuXmsfyhR7+vRjI/+XbV1AaFy691iy+kGDv2Jvy0/eAh8Y1'
var pluginDifyInnerApiUrl string = 'http://${containerAppNameApi}:5001' // 'http://api:5001'
var exposePluginDebuggingHost string = 'localhost'
var exposePluginDebuggingPort string = '5003'
var dbPluginDatabase string = 'dify_plugin'
var pluginDaemonPort string = '5002'
var pluginDaemonKey string = 'lYkiYYT6owG+71oLerGzA7GXCgOT++6ovaezWAjpCjf+Sjc3ZtU+qUEi'
var pluginPprofEnabled string = 'false'
var pluginDebuggingHost string = '0.0.0.0'
var pluginDebuggingPort string = '5003'
var pluginWorkingPath string = '/app/storage/cwd'
var forceVerifyingSignature string = 'true'
var pluginPythonEnvInitTimeout string = '120'
var pluginMaxExecutionTimeout string = '600'
var pluginStdioBufferSize string = '1024'
var pluginStdioMaxBufferSize string = '5242880'
var pluginStorageType string = 'local'
var pluginStorageLocalRoot string = '/app/storage'
var pluginInstalledPath string = 'plugin'
var pluginPackageCachePath string = 'plugin_packages'
var pluginMediaCachePath string = 'assets'
var pluginSentryEnabled string = 'false'
var pluginSentryDsn string = ''
var nginxServerName string = '_'
var nginxHttpsEnabled string = 'false'
var nginxPort string = '80'
var nginxSslPort string = '443'
var nginxSslCertFilename string = 'dify.crt'
var nginxSslCertKeyFilename string = 'dify.key'
var nginxSslProtocols string = 'TLSv1.1 TLSv1.2 TLSv1.3'
var nginxWorkerProcesses string = 'auto'
var nginxClientMaxBodySize string = '100M'
var nginxKeepaliveTimeout string = '65'
var nginxProxyReadTimeout string = '3600s'
var nginxProxySendTimeout string = '3600s'
var nginxEnableCertbotChallenge string = 'false'
var certbotDomain string = 'your_domain.com'
var pluginS3UseAws string = 'false'
var pluginS3UseAwsManagedIam string = 'false'
var pluginS3Endpoint string = ''
var pluginS3UsePathStyle string = 'false'
var pluginAwsAccessKey string = ''
var pluginAwsSecretKey string = ''
var pluginAwsRegion string = ''
var pluginAzureBlobStorageContainerName string = ''
var pluginAzureBlobStorageConnectionString string = ''
var pluginTencentCosSecretKey string = ''
var pluginTencentCosSecretId string = ''
var pluginTencentCosRegion string = ''
var pluginAliyunOssRegion string = ''
var pluginAliyunOssEndpoint string = ''
var pluginAliyunOssAccessKeyId string = ''
var pluginAliyunOssAccessKeySecret string = ''
var pluginAliyunOssAuthVersion string = 'v4'
var pluginAliyunOssPath string = ''
var pluginVolcengineTosEndpoint string = ''
var pluginVolcengineTosAccessKey string = ''
var pluginVolcengineTosSecretKey string = ''
var pluginVolcengineTosRegion string = ''

var sharedApiWorkerEnv = [
  { name: 'CONSOLE_API_URL', value: consoleApiUrl }
  { name: 'CONSOLE_WEB_URL', value: '' }
  { name: 'SERVICE_API_URL', value: '' }
  { name: 'APP_API_URL', value: appApiUrl }
  { name: 'APP_WEB_URL', value: '' }
  { name: 'FILES_URL', value: '' }
  { name: 'INTERNAL_FILES_URL', value: '' }
  { name: 'LANG', value: 'en_US.UTF-8' }
  { name: 'LC_ALL', value: 'en_US.UTF-8' }
  { name: 'PYTHONIOENCODING', value: 'utf-8' }
  { name: 'LOG_LEVEL', value: 'INFO' }
  { name: 'LOG_FILE', value: '/app/logs/server.log' }
  { name: 'LOG_FILE_MAX_SIZE', value: '20' }
  { name: 'LOG_FILE_BACKUP_COUNT', value: '5' }
  { name: 'LOG_DATEFORMAT', value: '%Y-%m-%d %H:%M:%S' }
  { name: 'LOG_TZ', value: 'UTC' }
  { name: 'DEBUG', value: 'false' }
  { name: 'FLASK_DEBUG', value: 'false' }
  { name: 'ENABLE_REQUEST_LOGGING', value: 'False' }
  { name: 'SECRET_KEY', value: 'sk-9f73s3ljTXVcMT3Blb3ljTqtsKiGHXVcMT3BlbkFJLK7U' }
  { name: 'INIT_PASSWORD', value: '' }
  { name: 'DEPLOY_ENV', value: 'PRODUCTION' }
  { name: 'CHECK_UPDATE_URL', value: 'https://updates.dify.ai' }
  { name: 'OPENAI_API_BASE', value: 'https://api.openai.com/v1' }
  { name: 'MIGRATION_ENABLED', value: 'true' }
  { name: 'FILES_ACCESS_TIMEOUT', value: '300' }
  { name: 'ACCESS_TOKEN_EXPIRE_MINUTES', value: '60' }
  { name: 'REFRESH_TOKEN_EXPIRE_DAYS', value: '30' }
  { name: 'APP_MAX_ACTIVE_REQUESTS', value: '0' }
  { name: 'APP_MAX_EXECUTION_TIME', value: '1200' }
  { name: 'DIFY_BIND_ADDRESS', value: '0.0.0.0' }
  { name: 'DIFY_PORT', value: '5001' }
  { name: 'SERVER_WORKER_AMOUNT', value: '1' }
  { name: 'SERVER_WORKER_CLASS', value: 'gevent' }
  { name: 'SERVER_WORKER_CONNECTIONS', value: '10' }
  { name: 'CELERY_WORKER_CLASS', value: '' }
  { name: 'GUNICORN_TIMEOUT', value: '360' }
  { name: 'CELERY_WORKER_AMOUNT', value: '' }
  { name: 'CELERY_AUTO_SCALE', value: 'false' }
  { name: 'CELERY_MAX_WORKERS', value: '' }
  { name: 'CELERY_MIN_WORKERS', value: '' }
  { name: 'API_TOOL_DEFAULT_CONNECT_TIMEOUT', value: '10' }
  { name: 'API_TOOL_DEFAULT_READ_TIMEOUT', value: '60' }
  { name: 'ENABLE_WEBSITE_JINAREADER', value: enableWebsiteJinareader }
  { name: 'ENABLE_WEBSITE_FIRECRAWL', value: enableWebsiteFirecrawl }
  { name: 'ENABLE_WEBSITE_WATERCRAWL', value: enableWebsiteWatercrawl }
  { name: 'DB_USERNAME', value: dbUserName }
  { name: 'DB_PASSWORD', value: dbPassword }
  { name: 'DB_HOST', value: containerAppNameDb } // 'db'
  { name: 'DB_PORT', value: '5432' }
  { name: 'DB_DATABASE', value: 'dify' }
  { name: 'SQLALCHEMY_POOL_SIZE', value: '30' }
  { name: 'SQLALCHEMY_MAX_OVERFLOW', value: '10' }
  { name: 'SQLALCHEMY_POOL_RECYCLE', value: '3600' }
  { name: 'SQLALCHEMY_ECHO', value: 'false' }
  { name: 'SQLALCHEMY_POOL_PRE_PING', value: 'false' }
  { name: 'SQLALCHEMY_POOL_USE_LIFO', value: 'false' }
  { name: 'SQLALCHEMY_POOL_TIMEOUT', value: '30' }
  { name: 'POSTGRES_MAX_CONNECTIONS', value: postgresMaxConnections }
  { name: 'POSTGRES_SHARED_BUFFERS', value: postgresSharedBuffers }
  { name: 'POSTGRES_WORK_MEM', value: postgresWorkMem }
  { name: 'POSTGRES_MAINTENANCE_WORK_MEM', value: postgresMaintenanceWorkMem }
  { name: 'POSTGRES_EFFECTIVE_CACHE_SIZE', value: postgresEffectiveCacheSize }
  { name: 'REDIS_HOST', value: containerAppNameRedis } // 'redis'
  { name: 'REDIS_PORT', value: '6379' }
  { name: 'REDIS_USERNAME', value: '' }
  { name: 'REDIS_PASSWORD', value: redisPassword }
  { name: 'REDIS_USE_SSL', value: 'false' }
  { name: 'REDIS_SSL_CERT_REQS', value: 'CERT_NONE' }
  { name: 'REDIS_SSL_CA_CERTS', value: '' }
  { name: 'REDIS_SSL_CERTFILE', value: '' }
  { name: 'REDIS_SSL_KEYFILE', value: '' }
  { name: 'REDIS_DB', value: '0' }
  { name: 'REDIS_USE_SENTINEL', value: 'false' }
  { name: 'REDIS_SENTINELS', value: '' }
  { name: 'REDIS_SENTINEL_SERVICE_NAME', value: '' }
  { name: 'REDIS_SENTINEL_USERNAME', value: '' }
  { name: 'REDIS_SENTINEL_PASSWORD', value: '' }
  { name: 'REDIS_SENTINEL_SOCKET_TIMEOUT', value: '0.1' }
  { name: 'REDIS_USE_CLUSTERS', value: 'false' }
  { name: 'REDIS_CLUSTERS', value: '' }
  { name: 'REDIS_CLUSTERS_PASSWORD', value: '' }
  { name: 'CELERY_BROKER_URL', value: 'redis://:difyai123456@${containerAppNameRedis}:6379/1' } // 'redis://:difyai123456@redis:6379/1'
  { name: 'CELERY_BACKEND', value: 'redis' }
  { name: 'BROKER_USE_SSL', value: 'false' }
  { name: 'CELERY_USE_SENTINEL', value: 'false' }
  { name: 'CELERY_SENTINEL_MASTER_NAME', value: '' }
  { name: 'CELERY_SENTINEL_PASSWORD', value: '' }
  { name: 'CELERY_SENTINEL_SOCKET_TIMEOUT', value: '0.1' }
  { name: 'WEB_API_CORS_ALLOW_ORIGINS', value: '*' }
  { name: 'CONSOLE_CORS_ALLOW_ORIGINS', value: '*' }
  { name: 'STORAGE_TYPE', value: 'opendal' }
  { name: 'OPENDAL_SCHEME', value: 'fs' }
  { name: 'OPENDAL_FS_ROOT', value: 'storage' }
  { name: 'CLICKZETTA_VOLUME_TYPE', value: 'user' }
  { name: 'CLICKZETTA_VOLUME_NAME', value: '' }
  { name: 'CLICKZETTA_VOLUME_TABLE_PREFIX', value: 'dataset_' }
  { name: 'CLICKZETTA_VOLUME_DIFY_PREFIX', value: 'dify_km' }
  { name: 'S3_ENDPOINT', value: '' }
  { name: 'S3_REGION', value: 'us-east-1' }
  { name: 'S3_BUCKET_NAME', value: 'difyai' }
  { name: 'S3_ACCESS_KEY', value: '' }
  { name: 'S3_SECRET_KEY', value: '' }
  { name: 'S3_USE_AWS_MANAGED_IAM', value: 'false' }
  { name: 'AZURE_BLOB_ACCOUNT_NAME', value: 'difyai' }
  { name: 'AZURE_BLOB_ACCOUNT_KEY', value: 'difyai' }
  { name: 'AZURE_BLOB_CONTAINER_NAME', value: 'difyai-container' }
  { name: 'AZURE_BLOB_ACCOUNT_URL', value: 'https://<your_account_name>.blob.core.windows.net' }
  { name: 'GOOGLE_STORAGE_BUCKET_NAME', value: 'your-bucket-name' }
  { name: 'GOOGLE_STORAGE_SERVICE_ACCOUNT_JSON_BASE64', value: '' }
  { name: 'ALIYUN_OSS_BUCKET_NAME', value: 'your-bucket-name' }
  { name: 'ALIYUN_OSS_ACCESS_KEY', value: 'your-access-key' }
  { name: 'ALIYUN_OSS_SECRET_KEY', value: 'your-secret-key' }
  { name: 'ALIYUN_OSS_ENDPOINT', value: 'https://oss-ap-southeast-1-internal.aliyuncs.com' }
  { name: 'ALIYUN_OSS_REGION', value: 'ap-southeast-1' }
  { name: 'ALIYUN_OSS_AUTH_VERSION', value: 'v4' }
  { name: 'ALIYUN_OSS_PATH', value: 'your-path' }
  { name: 'TENCENT_COS_BUCKET_NAME', value: 'your-bucket-name' }
  { name: 'TENCENT_COS_SECRET_KEY', value: 'your-secret-key' }
  { name: 'TENCENT_COS_SECRET_ID', value: 'your-secret-id' }
  { name: 'TENCENT_COS_REGION', value: 'your-region' }
  { name: 'TENCENT_COS_SCHEME', value: 'your-scheme' }
  {
    name: 'OCI_ENDPOINT'
    value: 'https://your-object-storage-namespace.compat.objectstorage.us-ashburn-1.oraclecloud.com'
  }
  { name: 'OCI_BUCKET_NAME', value: 'your-bucket-name' }
  { name: 'OCI_ACCESS_KEY', value: 'your-access-key' }
  { name: 'OCI_SECRET_KEY', value: 'your-secret-key' }
  { name: 'OCI_REGION', value: 'us-ashburn-1' }
  { name: 'HUAWEI_OBS_BUCKET_NAME', value: 'your-bucket-name' }
  { name: 'HUAWEI_OBS_SECRET_KEY', value: 'your-secret-key' }
  { name: 'HUAWEI_OBS_ACCESS_KEY', value: 'your-access-key' }
  { name: 'HUAWEI_OBS_SERVER', value: 'your-server-url' }
  { name: 'VOLCENGINE_TOS_BUCKET_NAME', value: 'your-bucket-name' }
  { name: 'VOLCENGINE_TOS_SECRET_KEY', value: 'your-secret-key' }
  { name: 'VOLCENGINE_TOS_ACCESS_KEY', value: 'your-access-key' }
  { name: 'VOLCENGINE_TOS_ENDPOINT', value: 'your-server-url' }
  { name: 'VOLCENGINE_TOS_REGION', value: 'your-region' }
  { name: 'BAIDU_OBS_BUCKET_NAME', value: 'your-bucket-name' }
  { name: 'BAIDU_OBS_SECRET_KEY', value: 'your-secret-key' }
  { name: 'BAIDU_OBS_ACCESS_KEY', value: 'your-access-key' }
  { name: 'BAIDU_OBS_ENDPOINT', value: 'your-server-url' }
  { name: 'SUPABASE_BUCKET_NAME', value: 'your-bucket-name' }
  { name: 'SUPABASE_API_KEY', value: 'your-access-key' }
  { name: 'SUPABASE_URL', value: 'your-server-url' }
  { name: 'VECTOR_STORE', value: 'weaviate' }
  { name: 'VECTOR_INDEX_NAME_PREFIX', value: 'Vector_index' }
  { name: 'WEAVIATE_ENDPOINT', value: 'http://${containerAppNameWeaviate}:8080' } // 'http://weaviate:8080'
  { name: 'WEAVIATE_API_KEY', value: 'WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih' }
  { name: 'QDRANT_URL', value: 'http://qdrant:6333' }
  { name: 'QDRANT_API_KEY', value: 'difyai123456' }
  { name: 'QDRANT_CLIENT_TIMEOUT', value: '20' }
  { name: 'QDRANT_GRPC_ENABLED', value: 'false' }
  { name: 'QDRANT_GRPC_PORT', value: '6334' }
  { name: 'QDRANT_REPLICATION_FACTOR', value: '1' }
  { name: 'MILVUS_URI', value: 'http://host.docker.internal:19530' }
  { name: 'MILVUS_DATABASE', value: '' }
  { name: 'MILVUS_TOKEN', value: '' }
  { name: 'MILVUS_USER', value: '' }
  { name: 'MILVUS_PASSWORD', value: '' }
  { name: 'MILVUS_ENABLE_HYBRID_SEARCH', value: 'False' }
  { name: 'MILVUS_ANALYZER_PARAMS', value: '' }
  { name: 'MYSCALE_HOST', value: 'myscale' }
  { name: 'MYSCALE_PORT', value: '8123' }
  { name: 'MYSCALE_USER', value: 'default' }
  { name: 'MYSCALE_PASSWORD', value: '' }
  { name: 'MYSCALE_DATABASE', value: 'dify' }
  { name: 'MYSCALE_FTS_PARAMS', value: '' }
  { name: 'COUCHBASE_CONNECTION_STRING', value: 'couchbase://couchbase-server' }
  { name: 'COUCHBASE_USER', value: 'Administrator' }
  { name: 'COUCHBASE_PASSWORD', value: 'password' }
  { name: 'COUCHBASE_BUCKET_NAME', value: 'Embeddings' }
  { name: 'COUCHBASE_SCOPE_NAME', value: '_default' }
  { name: 'PGVECTOR_HOST', value: 'pgvector' }
  { name: 'PGVECTOR_PORT', value: '5432' }
  { name: 'PGVECTOR_USER', value: 'postgres' }
  { name: 'PGVECTOR_PASSWORD', value: 'difyai123456' }
  { name: 'PGVECTOR_DATABASE', value: 'dify' }
  { name: 'PGVECTOR_MIN_CONNECTION', value: '1' }
  { name: 'PGVECTOR_MAX_CONNECTION', value: '5' }
  { name: 'PGVECTOR_PG_BIGM', value: 'false' }
  { name: 'PGVECTOR_PG_BIGM_VERSION', value: '1.2-20240606' }
  { name: 'VASTBASE_HOST', value: 'vastbase' }
  { name: 'VASTBASE_PORT', value: '5432' }
  { name: 'VASTBASE_USER', value: 'dify' }
  { name: 'VASTBASE_PASSWORD', value: 'Difyai123456' }
  { name: 'VASTBASE_DATABASE', value: 'dify' }
  { name: 'VASTBASE_MIN_CONNECTION', value: '1' }
  { name: 'VASTBASE_MAX_CONNECTION', value: '5' }
  { name: 'PGVECTO_RS_HOST', value: 'pgvecto-rs' }
  { name: 'PGVECTO_RS_PORT', value: '5432' }
  { name: 'PGVECTO_RS_USER', value: 'postgres' }
  { name: 'PGVECTO_RS_PASSWORD', value: 'difyai123456' }
  { name: 'PGVECTO_RS_DATABASE', value: 'dify' }
  { name: 'ANALYTICDB_KEY_ID', value: 'your-ak' }
  { name: 'ANALYTICDB_KEY_SECRET', value: 'your-sk' }
  { name: 'ANALYTICDB_REGION_ID', value: 'cn-hangzhou' }
  { name: 'ANALYTICDB_INSTANCE_ID', value: 'gp-ab123456' }
  { name: 'ANALYTICDB_ACCOUNT', value: 'testaccount' }
  { name: 'ANALYTICDB_PASSWORD', value: 'testpassword' }
  { name: 'ANALYTICDB_NAMESPACE', value: 'dify' }
  { name: 'ANALYTICDB_NAMESPACE_PASSWORD', value: 'difypassword' }
  { name: 'ANALYTICDB_HOST', value: 'gp-test.aliyuncs.com' }
  { name: 'ANALYTICDB_PORT', value: '5432' }
  { name: 'ANALYTICDB_MIN_CONNECTION', value: '1' }
  { name: 'ANALYTICDB_MAX_CONNECTION', value: '5' }
  { name: 'TIDB_VECTOR_HOST', value: 'tidb' }
  { name: 'TIDB_VECTOR_PORT', value: '4000' }
  { name: 'TIDB_VECTOR_USER', value: '' }
  { name: 'TIDB_VECTOR_PASSWORD', value: '' }
  { name: 'TIDB_VECTOR_DATABASE', value: 'dify' }
  { name: 'MATRIXONE_HOST', value: 'matrixone' }
  { name: 'MATRIXONE_PORT', value: '6001' }
  { name: 'MATRIXONE_USER', value: 'dump' }
  { name: 'MATRIXONE_PASSWORD', value: '111' }
  { name: 'MATRIXONE_DATABASE', value: 'dify' }
  { name: 'TIDB_ON_QDRANT_URL', value: 'http://127.0.0.1' }
  { name: 'TIDB_ON_QDRANT_API_KEY', value: 'dify' }
  { name: 'TIDB_ON_QDRANT_CLIENT_TIMEOUT', value: '20' }
  { name: 'TIDB_ON_QDRANT_GRPC_ENABLED', value: 'false' }
  { name: 'TIDB_ON_QDRANT_GRPC_PORT', value: '6334' }
  { name: 'TIDB_PUBLIC_KEY', value: 'dify' }
  { name: 'TIDB_PRIVATE_KEY', value: 'dify' }
  { name: 'TIDB_API_URL', value: 'http://127.0.0.1' }
  { name: 'TIDB_IAM_API_URL', value: 'http://127.0.0.1' }
  { name: 'TIDB_REGION', value: 'regions/aws-us-east-1' }
  { name: 'TIDB_PROJECT_ID', value: 'dify' }
  { name: 'TIDB_SPEND_LIMIT', value: '100' }
  { name: 'CHROMA_HOST', value: '127.0.0.1' }
  { name: 'CHROMA_PORT', value: '8000' }
  { name: 'CHROMA_TENANT', value: 'default_tenant' }
  { name: 'CHROMA_DATABASE', value: 'default_database' }
  { name: 'CHROMA_AUTH_PROVIDER', value: 'chromadb.auth.token_authn.TokenAuthClientProvider' }
  { name: 'CHROMA_AUTH_CREDENTIALS', value: '' }
  { name: 'ORACLE_USER', value: 'dify' }
  { name: 'ORACLE_PASSWORD', value: 'dify' }
  { name: 'ORACLE_DSN', value: 'oracle:1521/FREEPDB1' }
  { name: 'ORACLE_CONFIG_DIR', value: '/app/api/storage/wallet' }
  { name: 'ORACLE_WALLET_LOCATION', value: '/app/api/storage/wallet' }
  { name: 'ORACLE_WALLET_PASSWORD', value: 'dify' }
  { name: 'ORACLE_IS_AUTONOMOUS', value: 'false' }
  { name: 'RELYT_HOST', value: 'db' }
  { name: 'RELYT_PORT', value: '5432' }
  { name: 'RELYT_USER', value: 'postgres' }
  { name: 'RELYT_PASSWORD', value: 'difyai123456' }
  { name: 'RELYT_DATABASE', value: 'postgres' }
  { name: 'OPENSEARCH_HOST', value: 'opensearch' }
  { name: 'OPENSEARCH_PORT', value: '9200' }
  { name: 'OPENSEARCH_SECURE', value: 'true' }
  { name: 'OPENSEARCH_VERIFY_CERTS', value: 'true' }
  { name: 'OPENSEARCH_AUTH_METHOD', value: 'basic' }
  { name: 'OPENSEARCH_USER', value: 'admin' }
  { name: 'OPENSEARCH_PASSWORD', value: 'admin' }
  { name: 'OPENSEARCH_AWS_REGION', value: 'ap-southeast-1' }
  { name: 'OPENSEARCH_AWS_SERVICE', value: 'aoss' }
  { name: 'TENCENT_VECTOR_DB_URL', value: 'http://127.0.0.1' }
  { name: 'TENCENT_VECTOR_DB_API_KEY', value: 'dify' }
  { name: 'TENCENT_VECTOR_DB_TIMEOUT', value: '30' }
  { name: 'TENCENT_VECTOR_DB_USERNAME', value: 'dify' }
  { name: 'TENCENT_VECTOR_DB_DATABASE', value: 'dify' }
  { name: 'TENCENT_VECTOR_DB_SHARD', value: '1' }
  { name: 'TENCENT_VECTOR_DB_REPLICAS', value: '2' }
  { name: 'TENCENT_VECTOR_DB_ENABLE_HYBRID_SEARCH', value: 'false' }
  { name: 'ELASTICSEARCH_HOST', value: '0.0.0.0' }
  { name: 'ELASTICSEARCH_PORT', value: '9200' }
  { name: 'ELASTICSEARCH_USERNAME', value: 'elastic' }
  { name: 'ELASTICSEARCH_PASSWORD', value: 'elastic' }
  { name: 'KIBANA_PORT', value: '5601' }
  { name: 'ELASTICSEARCH_USE_CLOUD', value: 'false' }
  { name: 'ELASTICSEARCH_CLOUD_URL', value: 'YOUR-ELASTICSEARCH_CLOUD_URL' }
  { name: 'ELASTICSEARCH_API_KEY', value: 'YOUR-ELASTICSEARCH_API_KEY' }
  { name: 'ELASTICSEARCH_VERIFY_CERTS', value: 'False' }
  { name: 'ELASTICSEARCH_CA_CERTS', value: '' }
  { name: 'ELASTICSEARCH_REQUEST_TIMEOUT', value: '100000' }
  { name: 'ELASTICSEARCH_RETRY_ON_TIMEOUT', value: 'True' }
  { name: 'ELASTICSEARCH_MAX_RETRIES', value: '10' }
  { name: 'BAIDU_VECTOR_DB_ENDPOINT', value: 'http://127.0.0.1:5287' }
  { name: 'BAIDU_VECTOR_DB_CONNECTION_TIMEOUT_MS', value: '30000' }
  { name: 'BAIDU_VECTOR_DB_ACCOUNT', value: 'root' }
  { name: 'BAIDU_VECTOR_DB_API_KEY', value: 'dify' }
  { name: 'BAIDU_VECTOR_DB_DATABASE', value: 'dify' }
  { name: 'BAIDU_VECTOR_DB_SHARD', value: '1' }
  { name: 'BAIDU_VECTOR_DB_REPLICAS', value: '3' }
  { name: 'BAIDU_VECTOR_DB_INVERTED_INDEX_ANALYZER', value: 'DEFAULT_ANALYZER' }
  { name: 'BAIDU_VECTOR_DB_INVERTED_INDEX_PARSER_MODE', value: 'COARSE_MODE' }
  { name: 'VIKINGDB_ACCESS_KEY', value: 'your-ak' }
  { name: 'VIKINGDB_SECRET_KEY', value: 'your-sk' }
  { name: 'VIKINGDB_REGION', value: 'cn-shanghai' }
  { name: 'VIKINGDB_HOST', value: 'api-vikingdb.xxx.volces.com' }
  { name: 'VIKINGDB_SCHEMA', value: 'http' }
  { name: 'VIKINGDB_CONNECTION_TIMEOUT', value: '30' }
  { name: 'VIKINGDB_SOCKET_TIMEOUT', value: '30' }
  { name: 'LINDORM_URL', value: 'http://localhost:30070' }
  { name: 'LINDORM_USERNAME', value: 'admin' }
  { name: 'LINDORM_PASSWORD', value: 'admin' }
  { name: 'LINDORM_USING_UGC', value: 'True' }
  { name: 'LINDORM_QUERY_TIMEOUT', value: '1' }
  { name: 'OCEANBASE_VECTOR_HOST', value: 'oceanbase' }
  { name: 'OCEANBASE_VECTOR_PORT', value: '2881' }
  { name: 'OCEANBASE_VECTOR_USER', value: 'root@test' }
  { name: 'OCEANBASE_VECTOR_PASSWORD', value: 'difyai123456' }
  { name: 'OCEANBASE_VECTOR_DATABASE', value: 'test' }
  { name: 'OCEANBASE_CLUSTER_NAME', value: 'difyai' }
  { name: 'OCEANBASE_MEMORY_LIMIT', value: '6G' }
  { name: 'OCEANBASE_ENABLE_HYBRID_SEARCH', value: 'false' }
  { name: 'OCEANBASE_FULLTEXT_PARSER', value: 'ik' }
  { name: 'OPENGAUSS_HOST', value: 'opengauss' }
  { name: 'OPENGAUSS_PORT', value: '6600' }
  { name: 'OPENGAUSS_USER', value: 'postgres' }
  { name: 'OPENGAUSS_PASSWORD', value: 'Dify@123' }
  { name: 'OPENGAUSS_DATABASE', value: 'dify' }
  { name: 'OPENGAUSS_MIN_CONNECTION', value: '1' }
  { name: 'OPENGAUSS_MAX_CONNECTION', value: '5' }
  { name: 'OPENGAUSS_ENABLE_PQ', value: 'false' }
  { name: 'HUAWEI_CLOUD_HOSTS', value: 'https://127.0.0.1:9200' }
  { name: 'HUAWEI_CLOUD_USER', value: 'admin' }
  { name: 'HUAWEI_CLOUD_PASSWORD', value: 'admin' }
  { name: 'UPSTASH_VECTOR_URL', value: 'https://xxx-vector.upstash.io' }
  { name: 'UPSTASH_VECTOR_TOKEN', value: 'dify' }
  { name: 'TABLESTORE_ENDPOINT', value: 'https://instance-name.cn-hangzhou.ots.aliyuncs.com' }
  { name: 'TABLESTORE_INSTANCE_NAME', value: 'instance-name' }
  { name: 'TABLESTORE_ACCESS_KEY_ID', value: 'xxx' }
  { name: 'TABLESTORE_ACCESS_KEY_SECRET', value: 'xxx' }
  { name: 'TABLESTORE_NORMALIZE_FULLTEXT_BM25_SCORE', value: 'false' }
  { name: 'CLICKZETTA_USERNAME', value: '' }
  { name: 'CLICKZETTA_PASSWORD', value: '' }
  { name: 'CLICKZETTA_INSTANCE', value: '' }
  { name: 'CLICKZETTA_SERVICE', value: 'api.clickzetta.com' }
  { name: 'CLICKZETTA_WORKSPACE', value: 'quick_start' }
  { name: 'CLICKZETTA_VCLUSTER', value: 'default_ap' }
  { name: 'CLICKZETTA_SCHEMA', value: 'dify' }
  { name: 'CLICKZETTA_BATCH_SIZE', value: '100' }
  { name: 'CLICKZETTA_ENABLE_INVERTED_INDEX', value: 'true' }
  { name: 'CLICKZETTA_ANALYZER_TYPE', value: 'chinese' }
  { name: 'CLICKZETTA_ANALYZER_MODE', value: 'smart' }
  { name: 'CLICKZETTA_VECTOR_DISTANCE_FUNCTION', value: 'cosine_distance' }
  { name: 'UPLOAD_FILE_SIZE_LIMIT', value: '15' }
  { name: 'UPLOAD_FILE_BATCH_LIMIT', value: '5' }
  { name: 'ETL_TYPE', value: 'dify' }
  { name: 'UNSTRUCTURED_API_URL', value: '' }
  { name: 'UNSTRUCTURED_API_KEY', value: '' }
  { name: 'SCARF_NO_ANALYTICS', value: 'true' }
  { name: 'PROMPT_GENERATION_MAX_TOKENS', value: '512' }
  { name: 'CODE_GENERATION_MAX_TOKENS', value: '1024' }
  { name: 'PLUGIN_BASED_TOKEN_COUNTING_ENABLED', value: 'false' }
  { name: 'MULTIMODAL_SEND_FORMAT', value: 'base64' }
  { name: 'UPLOAD_IMAGE_FILE_SIZE_LIMIT', value: '10' }
  { name: 'UPLOAD_VIDEO_FILE_SIZE_LIMIT', value: '100' }
  { name: 'UPLOAD_AUDIO_FILE_SIZE_LIMIT', value: '50' }
  { name: 'SENTRY_DSN', value: '' }
  { name: 'API_SENTRY_DSN', value: apiSentryDsn }
  { name: 'API_SENTRY_TRACES_SAMPLE_RATE', value: apiSentryTracesSampleRate }
  { name: 'API_SENTRY_PROFILES_SAMPLE_RATE', value: apiSentryProfilesSampleRate }
  { name: 'WEB_SENTRY_DSN', value: '' }
  { name: 'PLUGIN_SENTRY_ENABLED', value: pluginSentryEnabled }
  { name: 'PLUGIN_SENTRY_DSN', value: pluginSentryDsn }
  { name: 'NOTION_INTEGRATION_TYPE', value: 'public' }
  { name: 'NOTION_CLIENT_SECRET', value: '' }
  { name: 'NOTION_CLIENT_ID', value: '' }
  { name: 'NOTION_INTERNAL_SECRET', value: '' }
  { name: 'MAIL_TYPE', value: 'resend' }
  { name: 'MAIL_DEFAULT_SEND_FROM', value: '' }
  { name: 'RESEND_API_URL', value: 'https://api.resend.com' }
  { name: 'RESEND_API_KEY', value: 'your-resend-api-key' }
  { name: 'SMTP_SERVER', value: '' }
  { name: 'SMTP_PORT', value: '465' }
  { name: 'SMTP_USERNAME', value: '' }
  { name: 'SMTP_PASSWORD', value: '' }
  { name: 'SMTP_USE_TLS', value: 'true' }
  { name: 'SMTP_OPPORTUNISTIC_TLS', value: 'false' }
  { name: 'SENDGRID_API_KEY', value: '' }
  { name: 'INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH', value: indexingMaxSegmentationTokensLength }
  { name: 'INVITE_EXPIRY_HOURS', value: '72' }
  { name: 'RESET_PASSWORD_TOKEN_EXPIRY_MINUTES', value: '5' }
  { name: 'EMAIL_REGISTER_TOKEN_EXPIRY_MINUTES', value: '5' }
  { name: 'CHANGE_EMAIL_TOKEN_EXPIRY_MINUTES', value: '5' }
  { name: 'OWNER_TRANSFER_TOKEN_EXPIRY_MINUTES', value: '5' }
  { name: 'CODE_EXECUTION_ENDPOINT', value: 'http://${containerAppNameSandbox}:8194' } // 'http://sandbox:8194'
  { name: 'CODE_EXECUTION_API_KEY', value: 'dify-sandbox' }
  { name: 'CODE_EXECUTION_SSL_VERIFY', value: 'True' }
  { name: 'CODE_EXECUTION_POOL_MAX_CONNECTIONS', value: '100' }
  { name: 'CODE_EXECUTION_POOL_MAX_KEEPALIVE_CONNECTIONS', value: '20' }
  { name: 'CODE_EXECUTION_POOL_KEEPALIVE_EXPIRY', value: '5.0' }
  { name: 'CODE_MAX_NUMBER', value: '9223372036854775807' }
  { name: 'CODE_MIN_NUMBER', value: '-9223372036854775808' }
  { name: 'CODE_MAX_DEPTH', value: '5' }
  { name: 'CODE_MAX_PRECISION', value: '20' }
  { name: 'CODE_MAX_STRING_LENGTH', value: '80000' }
  { name: 'CODE_MAX_STRING_ARRAY_LENGTH', value: '30' }
  { name: 'CODE_MAX_OBJECT_ARRAY_LENGTH', value: '30' }
  { name: 'CODE_MAX_NUMBER_ARRAY_LENGTH', value: '1000' }
  { name: 'CODE_EXECUTION_CONNECT_TIMEOUT', value: '10' }
  { name: 'CODE_EXECUTION_READ_TIMEOUT', value: '60' }
  { name: 'CODE_EXECUTION_WRITE_TIMEOUT', value: '10' }
  { name: 'TEMPLATE_TRANSFORM_MAX_LENGTH', value: '80000' }
  { name: 'WORKFLOW_MAX_EXECUTION_STEPS', value: '500' }
  { name: 'WORKFLOW_MAX_EXECUTION_TIME', value: '1200' }
  { name: 'WORKFLOW_CALL_MAX_DEPTH', value: '5' }
  { name: 'MAX_VARIABLE_SIZE', value: '204800' }
  { name: 'WORKFLOW_FILE_UPLOAD_LIMIT', value: '10' }
  { name: 'GRAPH_ENGINE_MIN_WORKERS', value: '1' }
  { name: 'GRAPH_ENGINE_MAX_WORKERS', value: '10' }
  { name: 'GRAPH_ENGINE_SCALE_UP_THRESHOLD', value: '3' }
  { name: 'GRAPH_ENGINE_SCALE_DOWN_IDLE_TIME', value: '5.0' }
  { name: 'WORKFLOW_NODE_EXECUTION_STORAGE', value: 'rdbms' }
  {
    name: 'CORE_WORKFLOW_EXECUTION_REPOSITORY'
    value: 'core.repositories.sqlalchemy_workflow_execution_repository.SQLAlchemyWorkflowExecutionRepository'
  }
  {
    name: 'CORE_WORKFLOW_NODE_EXECUTION_REPOSITORY'
    value: 'core.repositories.sqlalchemy_workflow_node_execution_repository.SQLAlchemyWorkflowNodeExecutionRepository'
  }
  {
    name: 'API_WORKFLOW_RUN_REPOSITORY'
    value: 'repositories.sqlalchemy_api_workflow_run_repository.DifyAPISQLAlchemyWorkflowRunRepository'
  }
  {
    name: 'API_WORKFLOW_NODE_EXECUTION_REPOSITORY'
    value: 'repositories.sqlalchemy_api_workflow_node_execution_repository.DifyAPISQLAlchemyWorkflowNodeExecutionRepository'
  }
  { name: 'WORKFLOW_LOG_CLEANUP_ENABLED', value: 'false' }
  { name: 'WORKFLOW_LOG_RETENTION_DAYS', value: '30' }
  { name: 'WORKFLOW_LOG_CLEANUP_BATCH_SIZE', value: '100' }
  { name: 'HTTP_REQUEST_NODE_MAX_BINARY_SIZE', value: '10485760' }
  { name: 'HTTP_REQUEST_NODE_MAX_TEXT_SIZE', value: '1048576' }
  { name: 'HTTP_REQUEST_NODE_SSL_VERIFY', value: 'True' }
  { name: 'RESPECT_XFORWARD_HEADERS_ENABLED', value: 'false' }
  { name: 'SSRF_PROXY_HTTP_URL', value: 'http://${containerAppNameSsrfProxy}:3128' } // http://ssrf_proxy:3128
  { name: 'SSRF_PROXY_HTTPS_URL', value: 'http://${containerAppNameSsrfProxy}:3128' } // http://ssrf_proxy:3128
  { name: 'LOOP_NODE_MAX_COUNT', value: loopNodeMaxCount }
  { name: 'MAX_TOOLS_NUM', value: maxToolsNum }
  { name: 'MAX_PARALLEL_LIMIT', value: maxParallelLimit }
  { name: 'MAX_ITERATIONS_NUM', value: maxIterationsNum }
  { name: 'TEXT_GENERATION_TIMEOUT_MS', value: textGenerationTimeoutMs }
  { name: 'ALLOW_UNSAFE_DATA_SCHEME', value: allowUnsafeDataScheme }
  { name: 'MAX_TREE_DEPTH', value: maxTreeDepth }
  { name: 'POSTGRES_USER', value: dbUserName }
  { name: 'POSTGRES_PASSWORD', value: dbPassword }
  { name: 'POSTGRES_DB', value: dbDatabase }
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
  { name: 'CHROMA_SERVER_AUTHN_CREDENTIALS', value: 'difyai123456' }
  { name: 'CHROMA_SERVER_AUTHN_PROVIDER', value: 'chromadb.auth.token_authn.TokenAuthenticationServerProvider' }
  { name: 'CHROMA_IS_PERSISTENT', value: 'TRUE' }
  { name: 'ORACLE_PWD', value: 'Dify123456' }
  { name: 'ORACLE_CHARACTERSET', value: 'AL32UTF8' }
  { name: 'ETCD_AUTO_COMPACTION_MODE', value: 'revision' }
  { name: 'ETCD_AUTO_COMPACTION_RETENTION', value: '1000' }
  { name: 'ETCD_QUOTA_BACKEND_BYTES', value: '4294967296' }
  { name: 'ETCD_SNAPSHOT_COUNT', value: '50000' }
  { name: 'MINIO_ACCESS_KEY', value: 'minioadmin' }
  { name: 'MINIO_SECRET_KEY', value: 'minioadmin' }
  { name: 'ETCD_ENDPOINTS', value: 'etcd:2379' }
  { name: 'MINIO_ADDRESS', value: 'minio:9000' }
  { name: 'MILVUS_AUTHORIZATION_ENABLED', value: 'true' }
  { name: 'PGVECTOR_PGUSER', value: 'postgres' }
  { name: 'PGVECTOR_POSTGRES_PASSWORD', value: 'difyai123456' }
  { name: 'PGVECTOR_POSTGRES_DB', value: 'dify' }
  { name: 'PGVECTOR_PGDATA', value: '/var/lib/postgresql/data/pgdata' }
  { name: 'OPENSEARCH_DISCOVERY_TYPE', value: 'single-node' }
  { name: 'OPENSEARCH_BOOTSTRAP_MEMORY_LOCK', value: 'true' }
  { name: 'OPENSEARCH_JAVA_OPTS_MIN', value: '512m' }
  { name: 'OPENSEARCH_JAVA_OPTS_MAX', value: '1024m' }
  { name: 'OPENSEARCH_INITIAL_ADMIN_PASSWORD', value: 'Qazwsxedc!@#123' }
  { name: 'OPENSEARCH_MEMLOCK_SOFT', value: '-1' }
  { name: 'OPENSEARCH_MEMLOCK_HARD', value: '-1' }
  { name: 'OPENSEARCH_NOFILE_SOFT', value: '65536' }
  { name: 'OPENSEARCH_NOFILE_HARD', value: '65536' }
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
  { name: 'CERTBOT_EMAIL', value: 'your_email@example.com' }
  { name: 'CERTBOT_DOMAIN', value: certbotDomain }
  { name: 'CERTBOT_OPTIONS', value: '' }
  { name: 'SSRF_HTTP_PORT', value: ssrfHttpPort }
  { name: 'SSRF_COREDUMP_DIR', value: ssrfCoredumpDir }
  { name: 'SSRF_REVERSE_PROXY_PORT', value: ssrfReverseProxyPort }
  { name: 'SSRF_SANDBOX_HOST', value: ssrfSandboxHost }
  { name: 'SSRF_DEFAULT_TIME_OUT', value: '5' }
  { name: 'SSRF_DEFAULT_CONNECT_TIME_OUT', value: '5' }
  { name: 'SSRF_DEFAULT_READ_TIME_OUT', value: '5' }
  { name: 'SSRF_DEFAULT_WRITE_TIME_OUT', value: '5' }
  { name: 'SSRF_POOL_MAX_CONNECTIONS', value: '100' }
  { name: 'SSRF_POOL_MAX_KEEPALIVE_CONNECTIONS', value: '20' }
  { name: 'SSRF_POOL_KEEPALIVE_EXPIRY', value: '5.0' }
  { name: 'EXPOSE_NGINX_PORT', value: '80' }
  { name: 'EXPOSE_NGINX_SSL_PORT', value: '443' }
  { name: 'POSITION_TOOL_PINS', value: '' }
  { name: 'POSITION_TOOL_INCLUDES', value: '' }
  { name: 'POSITION_TOOL_EXCLUDES', value: '' }
  { name: 'POSITION_PROVIDER_PINS', value: '' }
  { name: 'POSITION_PROVIDER_INCLUDES', value: '' }
  { name: 'POSITION_PROVIDER_EXCLUDES', value: '' }
  { name: 'CSP_WHITELIST', value: cspWhitelist }
  { name: 'CREATE_TIDB_SERVICE_JOB_ENABLED', value: 'false' }
  { name: 'MAX_SUBMIT_COUNT', value: '100' }
  { name: 'TOP_K_MAX_VALUE', value: topKMaxValue }
  { name: 'DB_PLUGIN_DATABASE', value: dbPluginDatabase }
  { name: 'EXPOSE_PLUGIN_DAEMON_PORT', value: '5002' }
  { name: 'PLUGIN_DAEMON_PORT', value: pluginDaemonPort }
  { name: 'PLUGIN_DAEMON_KEY', value: pluginDaemonKey }
  { name: 'PLUGIN_DAEMON_URL', value: 'http://${containerAppNamePluginDaemon}:5002' } // 'http://plugin_daemon:5002'
  { name: 'PLUGIN_MAX_PACKAGE_SIZE', value: pluginMaxPackageSize }
  { name: 'PLUGIN_PPROF_ENABLED', value: pluginPprofEnabled }
  { name: 'PLUGIN_DEBUGGING_HOST', value: pluginDebuggingHost }
  { name: 'PLUGIN_DEBUGGING_PORT', value: pluginDebuggingPort }
  { name: 'EXPOSE_PLUGIN_DEBUGGING_HOST', value: exposePluginDebuggingHost }
  { name: 'EXPOSE_PLUGIN_DEBUGGING_PORT', value: exposePluginDebuggingPort }
  { name: 'PLUGIN_DIFY_INNER_API_KEY', value: pluginDifyInnerApiKey }
  { name: 'PLUGIN_DIFY_INNER_API_URL', value: pluginDifyInnerApiUrl }
  { name: 'ENDPOINT_URL_TEMPLATE', value: 'http://localhost/e/{hook_id}' }
  { name: 'MARKETPLACE_ENABLED', value: 'true' }
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
  { name: 'PLUGIN_STORAGE_OSS_BUCKET', value: '' }
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
  { name: 'ENABLE_OTEL', value: 'false' }
  { name: 'OTLP_TRACE_ENDPOINT', value: '' }
  { name: 'OTLP_METRIC_ENDPOINT', value: '' }
  { name: 'OTLP_BASE_ENDPOINT', value: 'http://localhost:4318' }
  { name: 'OTLP_API_KEY', value: '' }
  { name: 'OTEL_EXPORTER_OTLP_PROTOCOL', value: '' }
  { name: 'OTEL_EXPORTER_TYPE', value: 'otlp' }
  { name: 'OTEL_SAMPLING_RATE', value: '0.1' }
  { name: 'OTEL_BATCH_EXPORT_SCHEDULE_DELAY', value: '5000' }
  { name: 'OTEL_MAX_QUEUE_SIZE', value: '2048' }
  { name: 'OTEL_MAX_EXPORT_BATCH_SIZE', value: '512' }
  { name: 'OTEL_METRIC_EXPORT_INTERVAL', value: '60000' }
  { name: 'OTEL_BATCH_EXPORT_TIMEOUT', value: '10000' }
  { name: 'OTEL_METRIC_EXPORT_TIMEOUT', value: '30000' }
  { name: 'ALLOW_EMBED', value: allowEmbed }
  { name: 'QUEUE_MONITOR_THRESHOLD', value: '200' }
  { name: 'QUEUE_MONITOR_ALERT_EMAILS', value: '' }
  { name: 'QUEUE_MONITOR_INTERVAL', value: '30' }
  { name: 'SWAGGER_UI_ENABLED', value: 'true' }
  { name: 'SWAGGER_UI_PATH', value: '/swagger-ui.html' }
  { name: 'DSL_EXPORT_ENCRYPT_DATASET_ID', value: 'true' }
  { name: 'ENABLE_CLEAN_EMBEDDING_CACHE_TASK', value: 'false' }
  { name: 'ENABLE_CLEAN_UNUSED_DATASETS_TASK', value: 'false' }
  { name: 'ENABLE_CREATE_TIDB_SERVERLESS_TASK', value: 'false' }
  { name: 'ENABLE_UPDATE_TIDB_SERVERLESS_STATUS_TASK', value: 'false' }
  { name: 'ENABLE_CLEAN_MESSAGES', value: 'false' }
  { name: 'ENABLE_MAIL_CLEAN_DOCUMENT_NOTIFY_TASK', value: 'false' }
  { name: 'ENABLE_DATASETS_QUEUE_MONITOR', value: 'false' }
  { name: 'ENABLE_CHECK_UPGRADABLE_PLUGIN_TASK', value: 'true' }
]

resource containerAppDb 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameDb
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 5432
        exposedPort: 5432
        transport: 'tcp'
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
          name: containerAppNameDb
          image: 'docker.io/postgres:15-alpine'
          imageType: 'ContainerImage'
          env: [
            { name: 'POSTGRES_USER', value: dbUserName }
            { name: 'POSTGRES_PASSWORD', value: dbPassword }
            { name: 'POSTGRES_DB', value: dbDatabase }
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
          storageType: 'EmptyDir' // Azure File Share(SMB/NFS)と相性が悪いので一旦emptyDir(永続化を諦める)
        }
      ]
    }
  }
}

resource containerAppRedis 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameRedis
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 6379
        exposedPort: 6379
        transport: 'tcp'
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
          name: containerAppNameRedis
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
          storageType: 'EmptyDir' // redisはそもそも永続化不要
        }
      ]
    }
  }
}

resource containerAppWeaviate 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameWeaviate
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 8080
        exposedPort: 8080
        transport: 'tcp'
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
          name: containerAppNameWeaviate
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
          storageType: 'EmptyDir' // weaviateも一旦永続化を諦める
        }
      ]
    }
  }
}

resource containerAppSsrfProxy 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameSsrfProxy
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 3128
        exposedPort: 3128
        transport: 'tcp'
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
          name: containerAppNameSsrfProxy
          image: 'docker.io/ubuntu/squid:latest'
          imageType: 'ContainerImage'
          command: [
            'sh'
            '-c'
            'cp /etc/ssrf_proxy/squid.conf.template /etc/squid/squid.conf.template&& cp /etc/ssrf_proxy/docker-entrypoint.sh /docker-entrypoint-mount.sh && cp /docker-entrypoint-mount.sh /docker-entrypoint.sh && sed -i \'s/\r$$//\' /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh && /docker-entrypoint.sh'
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
              volumeName: storageNameSsrfProxy
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
        {
          name: storageNameSsrfProxy
          storageType: 'AzureFile'
          storageName: storageNameSsrfProxy
        }
      ]
    }
  }
}

resource containerAppSandbox 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameSandbox
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 8194
        exposedPort: 8194
        transport: 'tcp'
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
          name: containerAppNameSandbox
          image: 'docker.io/langgenius/dify-sandbox:0.2.12'
          imageType: 'ContainerImage'
          command: [
            'sh'
          ]
          args: [
            '-c'
            'cp -rf /etc/volume-dify-sandbox/* / && /main'
          ]
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
          volumeMounts: [
            {
              volumeName: storageNameDifySandbox
              mountPath: '/etc/volume-dify-sandbox'
            }
          ]
        }
      ]
      volumes: [
        {
          name: storageNameDifySandbox
          storageType: 'AzureFile'
          storageName: storageNameDifySandbox
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

resource containerAppApi 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameApi
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 5001
        exposedPort: 5001
        transport: 'tcp'
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
          name: containerAppNameApi
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
              volumeName: storageNameDifyApi
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
          name: storageNameDifyApi
          storageType: 'AzureFile'
          storageName: storageNameDifyApi
        }
      ]
    }
  }
}

resource containerAppWorker 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameWorker
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {}
    template: {
      containers: [
        {
          name: containerAppNameWorker
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
              volumeName: storageNameDifyApi
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
          name: storageNameDifyApi
          storageType: 'AzureFile'
          storageName: storageNameDifyApi
        }
      ]
    }
  }
}

resource containerAppBeat 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameBeat
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {}
    template: {
      containers: [
        {
          name: containerAppNameBeat
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

param difyWebImageName string = 'docker.io/langgenius/dify-web:1.9.0'
param centryDsn string = ''
resource containerAppWeb 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameWeb
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 3000
        exposedPort: 3000
        transport: 'tcp'
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
          name: containerAppNameWeb
          image: difyWebImageName
          imageType: 'ContainerImage'
          env: [
            { name: 'CONSOLE_API_URL', value: consoleApiUrl }
            { name: 'APP_API_URL', value: appApiUrl }
            { name: 'SENTRY_DSN', value: centryDsn }
            { name: 'NEXT_TELEMETRY_DISABLED', value: '0' }
            { name: 'TEXT_GENERATION_TIMEOUT_MS', value: textGenerationTimeoutMs }
            { name: 'CSP_WHITELIST', value: cspWhitelist }
            { name: 'ALLOW_EMBED', value: allowEmbed }
            { name: 'ALLOW_UNSAFE_DATA_SCHEME', value: allowUnsafeDataScheme }
            { name: 'MARKETPLACE_API_URL', value: marketplaceApiUrl }
            { name: 'MARKETPLACE_URL', value: 'https://marketplace.dify.ai' }
            { name: 'TOP_K_MAX_VALUE', value: topKMaxValue }
            { name: 'INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH', value: indexingMaxSegmentationTokensLength }
            { name: 'PM2_INSTANCES', value: '2' }
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

resource containerAppPluginDaemon 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNamePluginDaemon
  location: resourceGroup().location
  kind: 'containerapps'
  properties: {
    environmentId: containerAppsEnvironment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: {
        external: false
        targetPort: 5002
        exposedPort: 5002
        transport: 'tcp'
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
          name: containerAppNamePluginDaemon
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
            { name: 'PLUGIN_STORAGE_OSS_BUCKET', value: '' }
            { name: 'S3_USE_AWS_MANAGED_IAM', value: pluginS3UseAwsManagedIam }
            { name: 'S3_USE_AWS', value: pluginS3UseAws }
            { name: 'S3_ENDPOINT', value: pluginS3Endpoint }
            { name: 'S3_USE_PATH_STYLE', value: pluginS3UsePathStyle }
            { name: 'AWS_ACCESS_KEY', value: pluginAwsAccessKey }
            { name: 'AWS_SECRET_KEY', value: pluginAwsSecretKey }
            { name: 'AWS_REGION', value: pluginAwsRegion }
            { name: 'AZURE_BLOB_STORAGE_CONNECTION_STRING', value: pluginAzureBlobStorageConnectionString }
            { name: 'AZURE_BLOB_STORAGE_CONTAINER_NAME', value: pluginAzureBlobStorageContainerName }
            { name: 'TENCENT_COS_SECRET_KEY', value: pluginTencentCosSecretKey }
            { name: 'TENCENT_COS_SECRET_ID', value: pluginTencentCosSecretId }
            { name: 'TENCENT_COS_REGION', value: pluginTencentCosRegion }
            { name: 'ALIYUN_OSS_REGION', value: pluginAliyunOssRegion }
            { name: 'ALIYUN_OSS_ENDPOINT', value: pluginAliyunOssEndpoint }
            { name: 'ALIYUN_OSS_ACCESS_KEY_ID', value: pluginAliyunOssAccessKeyId }
            { name: 'ALIYUN_OSS_ACCESS_KEY_SECRET', value: pluginAliyunOssAccessKeySecret }
            { name: 'ALIYUN_OSS_AUTH_VERSION', value: pluginAliyunOssAuthVersion }
            { name: 'ALIYUN_OSS_PATH', value: pluginAliyunOssPath }
            { name: 'VOLCENGINE_TOS_ENDPOINT', value: pluginVolcengineTosEndpoint }
            { name: 'VOLCENGINE_TOS_ACCESS_KEY', value: pluginVolcengineTosAccessKey }
            { name: 'VOLCENGINE_TOS_SECRET_KEY', value: pluginVolcengineTosSecretKey }
            { name: 'VOLCENGINE_TOS_REGION', value: pluginVolcengineTosRegion }
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
              volumeName: storageNameDifyPluginDaemon
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
          name: storageNameDifyPluginDaemon
          storageType: 'AzureFile'
          storageName: storageNameDifyPluginDaemon
        }
      ]
    }
  }
}

resource containerAppNginx 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: containerAppNameNginx
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
          name: containerAppNameNginx
          image: nginxImageName
          imageType: 'ContainerImage'
          command: [
            'sh'
            '-c'
            'cp -rf /etc/volume-nginx/* /etc/nginx/ && nginx -g "daemon off;"'
          ]
          env: [
            { name: 'NGINX_SERVER_NAME', value: nginxServerName }
            { name: 'NGINX_HTTPS_ENABLED', value: nginxHttpsEnabled }
            { name: 'NGINX_SSL_PORT', value: nginxSslPort }
            { name: 'NGINX_PORT', value: nginxPort }
            { name: 'NGINX_SSL_CERT_FILENAME', value: nginxSslCertFilename }
            { name: 'NGINX_SSL_CERT_KEY_FILENAME', value: nginxSslCertKeyFilename }
            { name: 'NGINX_SSL_PROTOCOLS', value: nginxSslProtocols }
            { name: 'NGINX_WORKER_PROCESSES', value: nginxWorkerProcesses }
            { name: 'NGINX_CLIENT_MAX_BODY_SIZE', value: nginxClientMaxBodySize }
            { name: 'NGINX_KEEPALIVE_TIMEOUT', value: nginxKeepaliveTimeout }
            { name: 'NGINX_PROXY_READ_TIMEOUT', value: nginxProxyReadTimeout }
            { name: 'NGINX_PROXY_SEND_TIMEOUT', value: nginxProxySendTimeout }
            { name: 'NGINX_ENABLE_CERTBOT_CHALLENGE', value: nginxEnableCertbotChallenge }
            { name: 'CERTBOT_DOMAIN', value: certbotDomain }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: storageNameNginx
              mountPath: '/etc/volume-nginx'
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
          name: storageNameNginx
          storageType: 'AzureFile'
          storageName: storageNameNginx
        }
      ]
    }
  }
}
