# List ALL CONNECTORS
curl --location 'http://localhost:8083/connectors'


# Register MYSQL CONNECTOR
curl --location 'http://localhost:8083/connectors' \
--header 'Content-Type: application/json' \
--data '{
    "name": "mysql-connector",
    "config": {
      "connector.class": "io.debezium.connector.mysql.MySqlConnector",
      "database.hostname": "mysql",
      "database.port": "3306",
      "database.user": "debezium",
      "database.password": "debezium",
      "database.server.id": "184054",
      "database.server.name": "dbserver1",
      "database.include.list": "inventory",
      "include.schema.changes": "true",
      "topic.prefix": "mysql",
      "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
      "schema.history.internal.kafka.topic": "schema-changes.testdb",
      "transforms": "unwrap",
      "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
      "transforms.unwrap.delete.handling.mode": "rewrite", 
      "tombstones.on.delete": "true"
    }
  }'


# Regsiter ES Sink connector
curl --location 'http://localhost:8083/connectors' \
--header 'Content-Type: application/json' \
--data '{
  "name": "elasticsearch-sink",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "topics": "mysql.inventory.category",  
    "connection.url": "http://elasticsearch:9200",
    "key.ignore": "false",
    "schema.ignore": "true",
    "type.name": "_doc",
    "behavior.on.null.values": "delete",
    "transforms": "ExtractField",
    "transforms.ExtractField.type": "org.apache.kafka.connect.transforms.ExtractField$Key",
    "transforms.ExtractField.field": "id"
  }
}'

# Register MongoDB Sink Connector
curl --location 'http://localhost:8083/connectors' \
--header 'Content-Type: application/json' \
--data-raw '{
  "name": "mongo-sink",
  "config": {
    "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
    "tasks.max": "1",
    "topics": "mysql.inventory.category",
    "connection.uri": "mongodb://root:root@mongo:27017",
    "database": "mysql_inventory",
    "collection": "category",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "false",
    "key.ignore": "true",
    "document.id.strategy": "com.mongodb.kafka.connect.sink.processor.id.strategy.PartialValueStrategy",
    "document.id.strategy.partial.value.projection.list": "id",
    "document.id.strategy.partial.value.projection.type": "AllowList"
    }
}'

# REMOVE MYSQL CONNECTOR
curl --location --request DELETE 'http://localhost:8083/connectors/mysql-connector'

# REMOVE ES Connector
curl --location --request DELETE 'http://localhost:8083/connectors/elasticsearch-sink'

# Remove Mongo Connector
curl --location --request DELETE 'http://localhost:8083/connectors/mongo-sink'


# Check Source Connector status
curl -X GET http://localhost:8083/connectors/mysql-connector/status

# Check Sync Connector status
curl -X GET http://localhost:8083/connectors/elasticsearch-sink/status
