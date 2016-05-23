APP_NAME ?= ot-log-test
PORT0 ?= 8000
LOCALIP=$(shell ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep -v '192.168' | grep -v '172.17' | grep -v '172.16' | grep -v '10.10.22' | awk '{print $1}')
TASK_HOST ?= $(LOCALIP)
DISCO_HOST ?= discovery-ci-uswest2.otenv.com
OT_LOGGING_REDIS_HOST ?= logging-qa-uswest2.otenv.com
OT_LOGGING_REDIS_PORT ?= 6379
OT_LOGGING_REDIS_LIST ?= logstash
OT_LOGGING_REDIS_TIMEOUT_MS ?= 5000
SITE_FILE ?= ./test.json
APP_ENVIRONMENT ?= ci-uswest2
APP_HOST ?= $(shell hostname)
SHOULD_ANNOUNCE ?= true
SHOULD_SITE_CHECK ?= true
STATIC_INSTANCE ?= demo
MONGO_COLLECTION ?= tchook_qa
APP_LANG ?= spanish
DOCKER_RUN_PARAMS ?= --env="PORT0=$(PORT0)" -p="$(PORT0):$(PORT0)" --env="TASK_HOST=$(TASK_HOST)" --env="MONGO_COLLECTION=$(MONGO_COLLECTION)"  --env="STATIC_INSTANCE=$(STATIC_INSTANCE)" --env="APP_ENVIRONMENT=$(APP_ENVIRONMENT)" --env="SHOULD_ANNOUNCE=$(SHOULD_ANNOUNCE)" --dns=10.0.0.104 --dns=10.0.0.103 --dns=10.0.0.102
PWD = $(shell pwd)
DOCKERGO = docker run --rm -e CGO_ENABLED=0 -v $(PWD):/usr/src/myapp -v $(PWD):/go -w /usr/src/myapp golang:1.5



print-%  : ; @echo $* = $($*)


compile-mac:
	gox -osarch="darwin/amd64" -gcflags="-a" -verbose -output="ot-log-test"

compile-linux:
	gox -osarch="linux/amd64" -gcflags="-a" -verbose -output="ot-log-test"

compile-linux-386:
	gox -osarch="linux/386" -gcflags="-a" -verbose -output="ot-log-test"

local-run:
	TASK_HOST=$(TASK_HOST) APP_HOST=$(APP_HOST) STATIC_INSTANCE=$(STATIC_INSTANCE) APP_ENVIRONMENT=$(APP_ENVIRONMENT) APP_LANG=$(APP_LANG) ./ot-log-test

compile-run-mac: compile-mac local-run

compile-run-linux: compile-linux local-run

compile-go:
	rm -rf src
	rm -f ot-log-test
	cp -r ./Godeps/_workspace/src .
	$(DOCKERGO) go build -a -installsuffix cgo -o ot-log-test .

compile-run: compile-go

.PHONY: compile-mac compile-linux compile-linux-386 local-run compile-go compile-run compile-run-mac compile-run-linux 
