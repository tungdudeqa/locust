from locust import HttpUser, task, between, LoadTestShape
from random import randint, uniform
from jsonschema import validate, ValidationError
from schema.user import users_schema, user_by_id_schema
from logger import get_logger
import os
import math

logger = get_logger()

class WebsiteUser(HttpUser):
    wait_time = between(1, 5)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    @task
    def get_all_user(self):
        res = self.client.get(url="/user/all")
        if res.status_code == 200:
            try:
                validate(instance=res.json(), schema=users_schema)
            except ValidationError as err:
                logger.error(f"All user Schema validation error: {err}")

    @task
    def get_id_user(self):
        user_id = randint(1, 5)
        res = self.client.get(url=f"/user/id/{user_id}")
        if res.status_code == 200:
            try:
                validate(instance=res.json(), schema=user_by_id_schema)
            except ValidationError as err:
                logger.error(f"Id user Schema validation error: {err}")
    
    @task
    def get_all_user_slow(self):
        res = self.client.get(url="/user/slow")
        if res.status_code == 200:
            try:
                validate(instance=res.json(), schema=users_schema)
            except ValidationError as err:
                logger.error(f"Slow user Schema validation error: {err}")

class fluctuatingLoadShape(LoadTestShape):
    total_run_time = int(os.environ.get("TOTAL_RUN_TIME", 180))
    update_interval = int(os.environ.get("UPDATE_INTERVAL", 10))

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.last_update = 0
        self.min_users = int(os.environ.get("MIN_USERS", 10))
        self.max_users = int(os.environ.get("MAX_USERS", 300))
        self.cycle_time = int(os.environ.get("CYCLE_TIME", 30))
        self.spawn_rate = int(os.environ.get("SPAWN_RATE", 10))
        self.log_initial_params()
    
    def log_initial_params(self):
        logger.info(f"[Wave Params] min: {self.min_users}, max: {self.max_users}, cycle: {self.cycle_time}s, spawn rate: {self.spawn_rate}, total run time: {self.total_run_time}, update interval: {self.update_interval}")
    
    def _randomize_wave_params(self):
        self.min_users = randint(10, 30)
        self.max_users = randint(100, 300)
        self.cycle_time = randint(5, 60)
        print(f"[Wave Params] min: {self.min_users}, max: {self.max_users}, cycle: {self.cycle_time}s")

    def tick(self):
        run_time = self.get_run_time()
        if run_time > self.total_run_time:
            return None

        if run_time - self.last_update >= self.update_interval:
            self._randomize_wave_params()
            self.last_update = run_time

        theta = 2 * math.pi * (run_time % self.cycle_time) / self.cycle_time
        sine_value = math.sin(theta)

        mid = (self.max_users + self.min_users) / 2
        amp = (self.max_users - self.min_users) / 2
        base_user_count = mid + amp * sine_value

        jitter = uniform(-0.05, 0.05) * self.max_users
        user_count = max(1, int(base_user_count + jitter))

        self.spawn_rate = randint(10, 100)

        return (user_count, self.spawn_rate)