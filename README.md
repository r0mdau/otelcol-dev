# Otelcol-dev

My lab for developing a Fluent Forward exporter in Opentelemetry-Collector.

Official documentation: [Building a custom collector](https://opentelemetry.io/docs/collector/custom-collector/).

## Getting started

Clone the repo and the submodule

```bash
git clone --recurse-submodules git@github.com:r0mdau/otelcol-dev.git
```

### Starting your dev journey

Run a [Fluent Bit](https://fluentbit.io/) instance that will receive messages over TCP port 24224 through the [fluent-forward](https://docs.fluentbit.io/manual/pipeline/outputs/forward) protocol and send the messages to stdout interface in JSON format every second, but if you want to work with `shared_key`, TLS and mTLS, see subcommands to start fluentd

```bash
make run-fluentbit
# for fluentd with tls
make run-fluentd
# for fluentd with mutual tls authentication (mtls)
make run-fluentd-mtls
```

Build & start the custom collector

```bash
make run
# with tls
make run-tls
# with mtls
make run-mtls
```

Generate 100 log lines

```bash
bash scripts/generate-logs.sh 100 >> testdata/access.log
```

Look at Fluent logs

```bash
docker logs fluentbit
# for fluentd with tls/mtls
docker logs fluentd
```

### Customize the otel modules

A replace instruction is set to use local code in the `go.mod` file: `replace github.com/r0mdau/fluentforwardexporter => ./fluentforwardexporter`.

Add the module to the good factory map in the `components.go` file.

## Profiling

On the `pprof` branch, the collector exposes the pprof endpoints.

### CPU

```bash
make run
go tool pprof http://localhost:1777/debug/pprof/profile\?seconds\=30

# example generate multiple files
i=1; while [ $i -ne 1000 ]; do dd if=/dev/urandom bs=1000 count=1 | base64 > testdata/log/$i.log; i=$(($i+1)); done
```


## Misc

How-to generate the `otelcol-dev` content the first time ([doc](https://opentelemetry.io/docs/collector/custom-collector/))

```bash
ocb --config scripts/builder-config.yaml
```

Vscode debug config `.vscode/launch.json`

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch Package",
            "type": "go",
            "request": "launch",
            "mode": "auto",
            "program": "${workspaceRoot}",
            "args": ["--config", "${workspaceRoot}/testdata/config.yaml"]
        }
    ]
}
```
