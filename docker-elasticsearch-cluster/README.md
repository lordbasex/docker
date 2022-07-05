# Elastic Search Cluster

DOC: https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docker.html

## Using the Docker images in productionedit
The following requirements and recommendations apply when running Elasticsearch in Docker in production.
  
```
sudo sysctl -w vm.max_map_count=262144

```

```
curl -X GET "localhost:9200/_cat/nodes?v=true&pretty"
```
