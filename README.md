# Otelcol-dev

My lab for developing a Fluent Forward exporter in Opentelemetry-Collector.

Official documentation: [Building a custom collector](https://opentelemetry.io/docs/collector/custom-collector/).

## Getting started

Clone the repo and the submodule

```bash
git clone --recurse-submodules git@github.com:r0mdau/otelcol-dev.git
```

### Starting your dev journey

Run a [Fluent Bit](https://fluentbit.io/) instance that will receive messages over TCP port 24224 through the [fluent-forward](https://docs.fluentbit.io/manual/pipeline/outputs/forward) protocol and send the messages to stdout interface in JSON format every second

```bash
docker run --name fluent --rm -p 127.0.0.1:24224:24224 fluent/fluent-bit /fluent-bit/bin/fluent-bit -i forward -o stdout -p format=json_lines -f 1
```

Build the custom collector

```bash
make build
```

Start the collector

```bash
./build/otelcol-dev --config testdata/config.yaml
```

Generate 100 log lines

```bash
bash scripts/generate-logs.sh 100 >> testdata/access.log
```

Look at Fluentbit logs

```bash
docker logs fluent
```

### Customize the otel modules

A replace instruction is set to use local code in the `go.mod` file: `replace github.com/r0mdau/fluentforwardexporter => ./fluentforwardexporter`.

Add the module to the good factory map in the `components.go` file.

## Misc

How-to generate the `otelcol-dev` content the first time ([doc](https://opentelemetry.io/docs/collector/custom-collector/))

```bash
ocb --config scripts/builder-config.yaml
```
