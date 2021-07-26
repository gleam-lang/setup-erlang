# setup-erlang

[![](https://github.com/gleam-lang/setup-erlang/workflows/Test/badge.svg)](https://github.com/gleam-lang/setup-erlang/actions)

A GitHub action that installs Erlang/OTP for use in your CI workflow.

At present it supports Ubuntu Linux and Windows.

Note: without specifying rebar3-version, the default rebar3 version will be the
one from ubuntu-latest.

## Usage

### Basic example with fixed OTP

```yaml
on: push

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.0.0
      - uses: gleam-lang/setup-erlang@v1.1.2
        with:
          otp-version: "23.2"
      - run: erlc hello_world.erl
```

### Matrix example

```yaml
on: push

jobs:
  test:
    runs-on: ubuntu-latest
    name: OTP ${{matrix.otp}}
    strategy:
      matrix:
        otp: ["23.1", "23.2"]
    steps:
      - uses: actions/checkout@v2.0.0
      - uses: gleam-lang/setup-erlang@v1.1.2
        with:
          otp-version: ${{matrix.otp}}
      - run: erlc hello_world.erl
```

### Postgresql example

```yaml
on: push

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      db:
        image: postgres:11
        ports: ['5432:5432']
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v2.0.0
      - uses: gleam-lang/setup-erlang@v1.1.2
        with:
          otp-version: "23.2"
      - run: erlc hello_world.erl
```

### Windows example

```yaml
on: push

jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v2.0.0
      - name: Install Erlang/OTP
        uses: gleam-lang/setup-erlang@v1.1.2
        with:
          otp-version: "23.2"
        id: install_erlang
      - name: Run erl
        # Print the Erlang version
        run: |
          $env:PATH = "${{ steps.install_erlang.outputs.erlpath }}\bin;$env:PATH"
          & erlc.exe hello_world.erl
```

### Including a specific Rebar3 version

```yaml
on: push

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.0.0
      - uses: gleam-lang/setup-erlang@v1.1.2
        with:
          otp-version: "23.2"
          rebar3-version: 3.16.1
      - run: rebar3 version
```

### Using the included Rebar3 from ubuntu-latest

```yaml
on: push

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.0.0
      - uses: gleam-lang/setup-erlang@v1.1.2
        with:
          otp-version: "23.2"
      - run: rebar3 version
```

### Including Rebar3 with the Matrix example

```yaml
on: push

jobs:
  test:
    runs-on: ubuntu-latest
    name: OTP ${{matrix.otp}}
    strategy:
      matrix:
        otp: ["23.1", "23.2"]
    steps:
      - uses: actions/checkout@v2.0.0
      - uses: gleam-lang/setup-erlang@v1.1.2
        with:
          otp-version: ${{matrix.otp}}
          rebar3-version: true
      - run: rebar3 version
```
