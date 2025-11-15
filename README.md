# Otelcol-dev

My lab for developing a Fluent Forward exporter in Opentelemetry-Collector.

Official documentation: [Building a custom collector](https://opentelemetry.io/docs/collector/custom-collector/).

## Getting started

Clone the repo and the submodule

```bash
git clone --recurse-submodules git@github.com:r0mdau/otelcol-dev.git
```

### Use the reproducible Nix dev shell

The repository exposes a `flake.nix` that brings in Go, `golint`, `golangci-lint`, `docker`, `protobuf`, `make`, and other helpers required by the Makefiles.

1. Install Nix ≥ 2.18 with the `nix-command` and `flakes` experimental features enabled.
2. From the repo root, start the shell (this configures `GOPATH` under `.gopath` so tools like `go install` remain scoped to the repo):

    ```bash
    nix develop
    ```

    If you prefer `direnv`, run `direnv allow` once and it will automatically enter/leave the shell.
3. Run the usual `make build`, `make lint`, etc. All tooling, including Docker CLI for the fluent* helpers, is already on `PATH`.

> **Heads up:** the shell currently pins `pkgs.go_1_23` because Go 1.24 (the version declared in `go.mod`) is not yet packaged in nixpkgs 24.05. As soon as nixpkgs ships Go 1.24, bump the `go` binding in `flake.nix` to keep the versions aligned.

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
