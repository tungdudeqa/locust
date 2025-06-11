user_schema = {
    "type": "object",
    "properties": {
        "id": {
            "type": "integer"
        },
        "name": {
            "type": "string"
        }
    },
    "required": ["id", "name"]
}

users_schema = {
    "type": "array",
    "items": user_schema
}

user_by_id_schema = {
    "type": "object",
    "properties": {
        "name": {
            "type": "string"
        }
    },
    "required": ["name"]
}