
IMAGE_NAME = docker-registry-default.apps.ocppoc.woodmen.net/esp-test/s2i

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
