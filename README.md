<img src="https://avatars3.githubusercontent.com/u/12463357?v=3" />
# docker-kibi
Docker compose stack running `ES 2.4.2` + `Kibi 4.5.4`

## About
Kibi enhances Kibana with features for complex "relational" data.<br>
To demonstrate this, this instance is loaded with 4 kinds of interconnected entities:

`Articles (n---1) Companies (1---n) Investments (n---1) Investors`

Kibi allows set to set navigation. One can start from a set (e.g., Articles this month that mentions "hadoop") , then rotate to the "companies mentioned here" then again rotate to the "investments they have received" (and see the total), and finally see the "investors who backed these" (revealing where they're mostly located), and so on.

#### Building the stack

The kibi image can be pulled from docker hub as an automated build. If a new build needs to be done, 
then use following commands in this folder `docker build . -t <tagname>`

```
ENV http_proxy http://<username>:<password>@proxy:80
ENV https_proxy http://<username>:<password>@proxy:80
```

#### Usage

Start docker compose using `docker-compose up`. Next head for localhost:5606 to start kibi.

#### Delete data in elasticsearch

Use following command to delete all data in elasticsearch indices 

* `curl -XDELETE 'http://localhost:9200/*/'`
* `curl -XDELETE 'http://localhost:9200/detail*/'`

This first command will delete all data in indexes starting with check*. Second will delete all details that are linked to it.

#### Set string type fields to not_analyzed
String fields are marked as 'analyzed' by default in elasticsearch. This has the effect that strings will be tokenized using - or _ characters. 
To make indexes not_analyzed following curl command has to be executed. This will make string mapping types not_analyzed for total_per_file type for all indexes.

```
curl -XPUT 'localhost:9200/*/_mapping/total_per_file?pretty' -d'
{
  "properties" : {
    "tag" : {
      "type" :    "string",
      "index":    "not_analyzed"
    }
  }
}'
```
