PHP_VERSION ?= "8.3"

.PHONY: build
build:
	@docker build \
		--file ./Dockerfile \
		--target with-curl \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--tag ghcr.io/dmalusev/swoole-issue:$(PHP_VERSION)-with-curl \
		.
	@docker build \
		--file ./Dockerfile \
		--target without-curl \
		--tag ghcr.io/dmalusev/swoole-issue:$(PHP_VERSION)-without-curl \
		.

.PHONY: install-with-curl
install-with-curl:
	@rm -rf vendor
	@docker run --rm \
		-u "$(shell id -u):$(shell id -g)" \
		-v "$(shell pwd):/var/www/html" \
		ghcr.io/dmalusev/swoole-issue:$(PHP_VERSION)-with-curl \
		composer install -vvv --ignore-platform-reqs

.PHONY: update-with-curl
update-with-curl:
	@docker run --rm \
		-u "$(shell id -u):$(shell id -g)" \
		-v "$(shell pwd):/var/www/html" \
		ghcr.io/dmalusev/swoole-issue:$(PHP_VERSION)-with-curl \
		composer update -vvv --ignore-platform-reqs

.PHONY: install-without-curl
install-without-curl:
	@rm -rf vendor
	@docker run --rm \
		-u "$(shell id -u):$(shell id -g)" \
		-v "$(shell pwd):/var/www/html" \
		ghcr.io/dmalusev/swoole-issue:$(PHP_VERSION)-without-curl \
		composer install -vvv --ignore-platform-reqs

.PHONY: update-without-curl
update-without-curl:
	@docker run --rm \
		-u "$(shell id -u):$(shell id -g)" \
		-v "$(shell pwd):/var/www/html" \
		ghcr.io/dmalusev/swoole-issue:$(PHP_VERSION)-without-curl \
		composer update -vvv --ignore-platform-reqs

.PHONY: php-ri
php-ri:
	@docker run --rm \
		ghcr.io/dmalusev/swoole-issue:$(PHP_VERSION)-with-curl \
		php --ri swoole