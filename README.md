# Locust Performance Testing

This project provides a simple setup for performance testing a Node.js (Bun) server using [Locust](https://locust.io/).

## Project Structure

- `app/` - The Bun/Node.js server application.
- `test/` - Python virtual environment and Locust test scripts.
- `Makefile` - Automation commands for setup and running tests.

## Prerequisites

- [Bun](https://bun.sh/) installed
- [Python 3](https://www.python.org/) installed
- [pip](https://pip.pypa.io/en/stable/) installed
- [Make](https://www.gnu.org/software/make/) installed

## Setup

1. **Install server dependencies:**
```sh
make install-server
```

2. **Set up Python virtual environment:**
```sh
make venv
```

3. **Install test dependencies:**

```sh
make install-test
```

## Running Performance Tests

To start the server and run Locust tests:

```sh
make run-test
```

This will:

- Start the Bun server in the background
- Wait for the server to be ready
- Run Locust in headless mode with 1000 users, 50 users spawned per second, for 30 seconds
Results will be saved in the results/perf CSV files.

### Customizing Locust

Edit `test/locustfile.py` to change user behavior or test endpoints.

### Useful Make Commands

`make server` — Start the server only

`make locust` — Run Locust tests only

`make test-add-pkg PKG={your_packages}` - Install python package for the test directory

#### Using Docker

1. Build the image

```sh
make docker-build
```

2. Run

```sh
make docker-locust
```