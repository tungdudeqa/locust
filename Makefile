SERVER_DIR=app
TEST_DIR=test
VENV=$(TEST_DIR)/.venv
LOCUST=$(VENV)/bin/locust
mnu ?= 10
mxu ?= 300
ct ?= 30
spr ?= 10
trt ?= 30
ui ?= 5
worker ?= 4

server:
	cd $(SERVER_DIR) && bun start

install-server:
	cd $(SERVER_DIR) && bun install

venv:
	python3 -m venv $(VENV)

install-test:
	source $(VENV)/bin/activate && pip3 install -r $(TEST_DIR)/requirements.txt

test-add-pkg:
	source $(VENV)/bin/activate && pip3 install $(PKG) && pip3 freeze > $(TEST_DIR)/requirements.txt

locust:
	$(LOCUST) -f $(TEST_DIR)/locustfile.py --headless --host=http://localhost:3001 --csv=results/perf

run-test:
	@echo "Starting server in the background..." && \
	cd $(SERVER_DIR) && bun start & \
	echo "Waiting for server..." && sleep 2 && \
	make locust

docker-build:
	docker build -t my-locust .

docker-locust:
	docker run -p 8089:8089  \
	-e MIN_USERS=$(mxu) \
	-e MAX_USERS=$(mnu) \
	-e CYCLE_TIME=$(ct) \
  	-e SPAWN_RATE=$(spr) \
	-e TOTAL_RUN_TIME=$(trt) \
	-e UPDATE_INTERVAL=$(ui) \
  	my-locust -f /mnt/locust/test/locustfile.py --host http://host.docker.internal:3001 --csv=results/perf

compose-locust:
	MIN_USERS=$(mnu) MAX_USERS=$(mxu) CYCLE_TIME=$(ct) SPAWN_RATE=$(spr) TOTAL_RUN_TIME=$(trt) UPDATE_INTERVAL=$(ui) docker-compose up --scale worker=$(worker) ; docker-compose down