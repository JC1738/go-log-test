package main

import (
	log "github.com/Sirupsen/logrus"
	"github.com/rogierlommers/logrus-redis-hook"
)

func init() {
	hook, err := logredis.NewHook("logging-qa-uswest2.otenv.com", 6379, "logstash", "v1", "jc_test_app")
	if err == nil {
		log.AddHook(hook)
	} else {
		log.Error(err)
	}
}

func main() {
	// when hook is injected succesfully, logs will be send to redis server
	log.Info("let's see the logs")
}

/*
{
  "_index": "logstash-2016.05.23",
  "_type": "%{type}",
  "_id": "AVTe7cJLCMkUZKUbYVYe",
  "_score": null,
  "_source": {
    "@timestamp": "2016-05-23T18:43:20.587Z",
    "host": "JCMac",
    "message": "let's see the logs",
    "application": "jc_test_app",
    "file": "",
    "level": "info",
    "@version": "1",
    "@uuid": "bb5d67bd-ff8f-45cd-92f8-f3e1eca9357a",
    "@received_at": "2016-05-23T18:43:20.765Z",
    "@region": "uswest2"
  },
  "sort": [
    1464029000587,
    1464029000587
  ]
}
*/