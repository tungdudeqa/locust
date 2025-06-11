from locust import HttpUser, task, between
from random import randint

class WebsiteUser(HttpUser):
    wait_time = between(1, 5)

    @task
    def get_all_user(self):
        self.client.get(url="/user/all")
    
    @task
    def get_id_user(self):
        user_id = randint(1, 5)
        self.client.get(url=f"/user/id/{user_id}")
    
    @task
    def get_all_user_slow(self):
        self.client.get(url="/user/slow")