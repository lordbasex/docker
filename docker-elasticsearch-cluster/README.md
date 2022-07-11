# Elastic Search Cluster

DOC: https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docker.html

## Using the Docker images in productionedit
The following requirements and recommendations apply when running Elasticsearch in Docker in production.
  
```
sudo sysctl -w vm.max_map_count=262144
```

## HelloWorld
```
curl -X GET "localhost:9200" | jq
```

```json
{
  "name": "es01",
  "cluster_name": "es-docker-cluster",
  "cluster_uuid": "eQnOaTqCT7W6PSaEuI9JJw",
  "version": {
    "number": "7.17.5",
    "build_flavor": "default",
    "build_type": "docker",
    "build_hash": "8d61b4f7ddf931f219e3745f295ed2bbc50c8e84",
    "build_date": "2022-06-23T21:57:28.736740635Z",
    "build_snapshot": false,
    "lucene_version": "8.11.1",
    "minimum_wire_compatibility_version": "6.8.0",
    "minimum_index_compatibility_version": "6.0.0-beta1"
  },
  "tagline": "You Know, for Search"
}
```


```
curl -X GET "localhost:9200/_cat/nodes?v=true&pretty"
```
