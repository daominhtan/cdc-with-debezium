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


# REMOVE MYSQL CONNECTOR
curl --location --request DELETE 'http://localhost:8083/connectors/mysql-connector'

# REMOVE ES Connector
curl --location --request DELETE 'http://localhost:8083/connectors/elasticsearch-sink'
