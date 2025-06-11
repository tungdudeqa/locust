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

locust:
	$(LOCUST) -f $(TEST_DIR)/locustfile.py --headless -u 1000 -r 50 -t 30s --host=http://localhost:3001 --csv=results/perf

run-test:
	@echo "Starting server in the background..." && \
	cd $(SERVER_DIR) && bun start & \
	echo "Waiting for server..." && sleep 2 && \
	make locust