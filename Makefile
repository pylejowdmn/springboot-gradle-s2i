# do `make && make test`
SRC = Dockerfile $(shell ls .s2i/bin/*)
IMAGE_NAME = springboot-gradle-s2i

.PHONY: all
all: build

.PHONY: build
build: $(SRC)
	sudo docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	sudo docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
