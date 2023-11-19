.DEFAULT_GOAL := build

fmt:
	go fmt ./...
.PHONY:fmt

lint: fmt
	golint ./...
.PHONY:lint

vet: fmt
	go vet ./...
.PHONY:vet

build: vet
	@echo ">> building otelcol-dev binary"
	mkdir -p build
	go build -o build/otelcol-dev
.PHONY:build

test:
	go test -cover ./...
.PHONY:test

verify: fmt test
.PHONY:verify

run: build
	./build/otelcol-dev --config testdata/config.yaml
.PHONY:run

generate-logs:
	@echo ">> generating logs"
	./scripts/generate-logs.sh 100 >> testdata/access.log
.PHONY:generate-logs

run-fluentbit:
	docker run --name fluentbit --rm -p 127.0.0.1:24224:24224 fluent/fluent-bit /fluent-bit/bin/fluent-bit -i forward -o stdout -p format=json_lines -f 1
.PHONY:run-fluentbit

run-fluentd:
	docker run --name fluentd --rm -p 127.0.0.1:24224:24224 -v ./testdata/fluentd.conf:/fluentd/etc/fluentd.conf:ro fluent/fluentd:v1.16-debian-amd64-1 -c /fluentd/etc/fluentd.conf -v
.PHONY:run-fluentd