SERVER_DIR=app
TEST_DIR=test
VENV=$(TEST_DIR)/.venv
LOCUST=$(VENV)/bin/locust

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
	-e MIN_USERS=10 \
	-e MAX_USERS=200 \
	-e CYCLE_TIME=60 \
  	-e SPAWN_RATE=20 \
	-e TOTAL_RUN_TIME=30 \
	-e UPDATE_INTERVAL=2 \
  	my-locust -f /mnt/locust/test/locustfile.py --host http://host.docker.internal:3001