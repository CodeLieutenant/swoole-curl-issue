# Swoole issue on PHP 8.3 with CURL

Content of `composer.json` is Laravel application with `Octane`
and `Dockerfile` is exact copy used in development of the application where the issue was first found (BASE IMAGE).
I haven't checked if this issue can be reproduced on "bare metal" php instalation, as app only uses docker for development and production.

One more note, `Octane` works fine when vendor is installed, and this issue (as found) was reproducable only with composer.

When compiling Swoole with `--enable-swoole-curl` on PHP 8.3 causes CURL to SEGFAULT

This repository provides `Makefile` with commands to reproduce the issue.

## Steps to reproduce

#### Build images

```sh
# Optional argument PHP_VERSION=8.x -> provide different PHP version
# Default is 8.3
make build
```

This command will create TWO docker images -> one with `--enable-swoole-curl` and one without it

#### Other Makefile command

> also supported argument PHP_VERSION

1. `install-without-curl`
2. `install-with-curl`
3. `update-with-curl`
4. `update-without-curl`
5. `php-ri`

#### Running

```sh
make install-with-curl
```

Dumps `core` file for futher examanation

### Affected versions

1. PHP 8.3

### NOT Affected versions

2. PHP 8.2

-> NO FURTHER TESTING DONE

My assumption is that everything works fine for `php < 8.3` as PHP 8.2 works fine (testing done with the same docker image, installing PHP 8.2)
