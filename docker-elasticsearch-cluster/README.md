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

##  Show Nodes
```
curl -X GET "localhost:9200/_cat/nodes?v=true&pretty"
```
```
ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role   master name
172.20.0.2           60          14   6    1.51    1.90     1.88 cdfhilmrstw *      es02
172.20.0.4           34          14   6    1.51    1.90     1.88 cdfhilmrstw -      es01
172.20.0.3           71          14   6    1.51    1.90     1.88 cdfhilmrstw -      es03
```

## Show Endpoints
```
curl -X GET "localhost:9200/_cat"
```

```
=^.^=
/_cat/allocation
/_cat/shards
/_cat/shards/{index}
/_cat/master
/_cat/nodes
/_cat/tasks
/_cat/indices
/_cat/indices/{index}
/_cat/segments
/_cat/segments/{index}
/_cat/count
/_cat/count/{index}
/_cat/recovery
/_cat/recovery/{index}
/_cat/health
/_cat/pending_tasks
/_cat/aliases
/_cat/aliases/{alias}
/_cat/thread_pool
/_cat/thread_pool/{thread_pools}
/_cat/plugins
/_cat/fielddata
/_cat/fielddata/{fields}
/_cat/nodeattrs
/_cat/repositories
/_cat/snapshots/{repository}
/_cat/templates
/_cat/ml/anomaly_detectors
/_cat/ml/anomaly_detectors/{job_id}
/_cat/ml/trained_models
/_cat/ml/trained_models/{model_id}
/_cat/ml/datafeeds
/_cat/ml/datafeeds/{datafeed_id}
/_cat/ml/data_frame/analytics
/_cat/ml/data_frame/analytics/{id}
/_cat/transforms
/_cat/transforms/{transform_id}
```

## Show Health (cluster state)
```
curl -X GET "localhost:9200/_cat/health?v"
```
```
epoch      timestamp cluster           status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
1657555267 16:01:07  es-docker-cluster green           3         3     16   8    0    0        0             0                  -                100.0%
```


## Show Indices

```
curl -X GET "localhost:9200/_cat/indices?v"
```

```
health status index                           uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases                HkDaPw1FT46QPrsBcv6xwg   1   1         40            0     75.4mb         37.7mb
green  open   .kibana_7.17.5_001              aHS11RI9Seu4fT1JOqKMOA   1   1         16            0      4.7mb          2.3mb
green  open   .apm-custom-link                5aHgaZ8TRPa6nR-QLYlAvQ   1   1          0            0       452b           226b
green  open   .apm-agent-configuration        s9__Fw1oRAamwQ8c4rfptw   1   1          0            0       452b           226b
green  open   .kibana_task_manager_7.17.5_001 bcMMJPAcQLeQxnXjIPhqQw   1   1         17        78912       15mb          7.5mb
```
