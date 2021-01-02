# setup-erlang

[![](https://github.com/gleam-lang/setup-erlang/workflows/Test/badge.svg)](https://github.com/gleam-lang/setup-erlang/actions)

A GitHub action that installs Erlang/OTP for use in your CI workflow.

At present it supports Ubuntu Linux and Windows.

## Usage

### Basic example

```yaml
on: push

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.0.0
      - uses: gleam-lang/setup-erlang@v1.1.2
        with:
          otp-version: 22.1
      - run: rebar3 eunit
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
        otp: [22.1, 21.3]
    steps:
      - uses: actions/checkout@v2.0.0
      - uses: gleam-lang/setup-erlang@v1.1.2
        with:
          otp-version: ${{matrix.otp}}
      - run: rebar3 eunit
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
          otp-version: 22.1
      - run: rebar3 eunit
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
          otp-version: 22.2
        id: install_erlang
      - name: Run erl
        # Print the Erlang version
        run: |
          $env:PATH = "${{ steps.install_erlang.outputs.erlpath }}\bin;$env:PATH"
          & erl.exe -eval 'erlang:display({otp_release, erlang:system_info(otp_release)}), halt().' -noshell
```
