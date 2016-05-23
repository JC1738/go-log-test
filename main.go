package main

import (
	log "github.com/Sirupsen/logrus"
	"github.com/rogierlommers/logrus-redis-hook"
	"github.com/jc1738/lfshook"
)

func init() {
	hook, err := logredis.NewHook("logging-qa-uswest2.otenv.com", 6379, "logstash", "v1", "jc_test_app")
	if err == nil {
		log.AddHook(hook)
	} else {
		log.Error(err)
	}
	
    log.AddHook(lfshook.NewHook(lfshook.PathMap{
        log.InfoLevel : "./info.log",
		log.DebugLevel : "./debug.log",
        log.ErrorLevel : "./error.log",
		log.FatalLevel : "./fatal.log",
		log.PanicLevel : "./panic.log",		
    }))	
		
}

func main() {
	// when hook is injected succesfully, logs will be send to redis server
	log.WithFields(log.Fields{
		"animal": "wolf",
	}).Info("let's see the logs")

	log.WithFields(log.Fields{
		"animal": "walrus",
	}).Info("A walrus appears")

}