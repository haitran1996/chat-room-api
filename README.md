# Chat Room API

## Sample response:

```
# format
{
    "code": <http status code>,
    "message": <String>,
    "data": <Array Object/Object>,
    "errors": <Array String>
}

# Success
{
    "code": 200,
    "message": <String>,
    "data": {
        "email": "user_3@gmail.com",
        "provider": "email",
        "uid": "user_3@gmail.com",
        "image": {
            "url": null
        },
        "id": 3,
        "allow_password_change": false,
        "name": null,
        "description": null,
        "device_token": null
    },
    "errors": null
}

# Error
{
    "code": 401,
    "message": null,
    "data": null,
    "errors": [
        "Invalid login credentials. Please try again."
    ]
}

# unexpected error
{
    "status": 404,
    "error": "Not Found",
    "exception": "#<ActiveRecord::RecordNotFound: Couldn't find User with 'id'=10>",
    "traces": {
        "Application Trace": [
            {
                "exception_object_id": 49460,
                "id": 1,
                "trace": "app/controllers/api/v1/users_controller.rb:7:in `show'"
            }
        ],
        "Framework Trace": [
            {
                "exception_object_id": 49460,
                "id": 0,
                "trace": "activerecord (6.1.7.6) lib/active_record/core.rb:353:in `find'"
            },
            ....
        ],
        "Full Trace": [
            {
                "exception_object_id": 49460,
                "id": 0,
                "trace": "activerecord (6.1.7.6) lib/active_record/core.rb:353:in `find'"
            },
            ....
        ]
    }
}
```

## Authenticate
### Login
endpoint: `POST` `/api/v1/auth/sign_in`

params: `email`, `password`, `device_token` (device_token is required to push notifications)

sample response:
```
{
    "code": 200,
    "message": null,
    "data": {
        "email": "user_3@gmail.com",
        "provider": "email",
        "uid": "user_3@gmail.com",
        "image": {
            "url": null
        },
        "id": 3,
        "allow_password_change": false,
        "name": null,
        "description": null,
        "device_token": null
    },
    "errors": null
}
```

**NOTICE**:
After logging in or signing up, the response will return the values ​​in the header used to attach headers in subsequent requests, those values ​​are: `access-token`,  `client`, `uid`

Sample:
```
access-token:_vG4Nybdk6ejVt6hPvFKHg
client:eYT7CGm09cICrHDZ9a8POQ
uid:user_01@gmail.com
```

If the token expires, a new token will be reset in the headers. Save the new `access-token`, `client` and `uid`` for the next requests.

### Sign up
endpoint: `POST` `/api/v1/auth`

params: `name`, `email`, `password`, `device_token` (device_token is required to push notifications)

sample response:
```
{
    "code": 200,
    "message": null,
    "data": {
        "id": 4,
        "email": "user_05@gmail.com",
        "created_at": "2024-01-21T12:16:53.588Z",
        "updated_at": "2024-01-21T12:16:53.638Z",
        "provider": "email",
        "uid": "user_05@gmail.com",
        "allow_password_change": false,
        "name": "Takeuchi",
        "image": {
            "url": null
        },
        "description": null,
        "device_token": "xxx"
    },
    "errors": null
}
```

### Logout

endpoint: `DELTE` `/api/v1/auth/sign_out`

sample response:
```
{
    "code": 200,
    "message": null,
    "data": null,
    "errors": null
}
```

### Forgot password
The process will take place as follows:
  - Submit email form to reset password. A mail will send to user.
  - User get tokens from mail
  - Submit password reset form with the token

1. API confirm mail

endpoint: `POST` `/api/v1/auth/password`

params: `email`

sample response:
```
{
    "code": 200,
    "message": "An email has been sent to 'user_3@gmail.com' containing instructions for resetting your password.",
    "data": null,
    "errors": null
}
```
2. API reset password
endpoint: `PUT` `/api/v1/auth/password`

params: `password`, `password_confirmation`, `reset_password_token`

sample response:
```
{
    "code": 200,
    "message": "Your password has been successfully updated.",
    "data": {
        "email": "user_05@gmail.com",
        "provider": "email",
        "uid": "user_05@gmail.com",
        "image": {
            "url": null
        },
        "id": 4,
        "created_at": "2024-01-21T12:16:53.588Z",
        "updated_at": "2024-01-21T12:44:56.989Z",
        "allow_password_change": false,
        "name": "Takeuchi",
        "description": null,
        "device_token": "xxx"
    },
    "errors": null
}
```

## Chat Room
### List room
endpoint: `GET` `/api/v1/chat_rooms`

sample response:
```
{
    "code": 200,
    "message": null,
    "data": [
        {
        "id": 4,
        "name": "Room 1",
        "created_at": "2024-01-20T15:15:52.144Z",
        "updated_at": "2024-01-20T15:15:52.144Z",
        "users": [
            {
                "id": 1,
                "email": "user_01@gmail.com",
                "created_at": "2024-01-20T04:31:12.484Z",
                "updated_at": "2024-01-21T12:32:32.515Z",
                "provider": "email",
                "uid": "user_01@gmail.com",
                "allow_password_change": true,
                "name": "Nakajima",
                "image": {
                    "url": "/uploads/user/image/1/avatar.jpg"
                },
                "description": "Hello world!!",
                "device_token": null
            },
            {
                "id": 2,
                "email": "user_02@gmail.com",
                "created_at": "2024-01-20T05:20:15.132Z",
                "updated_at": "2024-01-20T05:20:15.450Z",
                "provider": "email",
                "uid": "user_02@gmail.com",
                "allow_password_change": false,
                "name": "Nightmare",
                "image": {
                    "url": null
                },
                "description": null,
                "device_token": "xxx"
            }
        ],
        "last_message": {
            "id": 15,
            "content": "i miss you",
            "user_id": 1,
            "chat_room_id": 4,
            "created_at": "2024-01-21T12:51:54.444Z",
            "updated_at": "2024-01-21T12:51:54.444Z",
            "reply_to_message_id": null
        }
    }
    ],
    "errors": null
}
```
### Create room
endpoint: `POST` `/api/v1/chat_rooms/`

params: `name`, `chat_participants_attributes`

sample params:
```
{
  name: 'Room A',
  chat_participants_attributes: [
    { user_id: 1 },
    { user_id: 2 }
  ]
}
```

sample response:
```
{
    "code": 200,
    "message": null,
    "data": {
        "id": 2,
        "name": "Room C",
        "created_at": "2024-02-01T15:52:56.123Z",
        "updated_at": "2024-02-01T15:52:56.123Z"
    },
    "errors": null
}
```

## Chat Message
### Create Message
endpoint: `POST` `/api/v1/chat_rooms/<room_id>/chat_messages`

params: `content`, `reply_to_message_id` (optional)

sample response:
```
{
    "code": 200,
    "message": null,
    "data": {
        "id": 2,
        "content": "i miss you",
        "user_id": 3,
        "chat_room_id": 2,
        "created_at": "2024-02-01T15:53:45.779Z",
        "updated_at": "2024-02-01T15:53:45.779Z",
        "reply_to_message_id": null
    },
    "errors": null
}
```

### List messages
endpoint: `GET` `/api/v1/chat_rooms/<room_id>/chat_messages`

sample response:
```
{
    "code": 200,
    "message": null,
    "data": [
        {
            "id": 2,
            "content": "i miss you",
            "user_id": 3,
            "chat_room_id": 2,
            "created_at": "2024-02-01T15:53:45.779Z",
            "updated_at": "2024-02-01T15:53:45.779Z",
            "reply_to_message_id": null
        }
    ],
    "errors": null
}
```

## User
### List/Find users
endpoint: `GET` `/api/v1/users`

params: `name`

sample response:
```
{
    "code": 200,
    "message": null,
    "data": [
        {
            "id": 1,
            "email": "user1111@gmail.com",
            "created_at": "2024-01-27T16:10:49.353Z",
            "updated_at": "2024-01-27T16:27:25.084Z",
            "provider": "email",
            "uid": "user1111@gmail.com",
            "allow_password_change": false,
            "name": "Nakajima",
            "image": {
                "url": null
            },
            "description": null,
            "device_token": null
        },
        {
            "id": 2,
            "email": "user_2@gmail.com",
            "created_at": "2024-01-27T16:13:58.491Z",
            "updated_at": "2024-01-27T18:27:55.169Z",
            "provider": "email",
            "uid": "user_2@gmail.com",
            "allow_password_change": false,
            "name": "Nakajima",
            "image": {
                "url": null
            },
            "description": null,
            "device_token": null
        }
    ],
    "errors": null
}
```
### Profile

endpoint: `GET` `/api/v1/users/<id>`

sample response:
```
Success:
{
    "code": 200,
    "message": null,
    "data": {
        "id": 3,
        "email": "user_3@gmail.com",
        "created_at": "2024-01-27T16:18:25.118Z",
        "updated_at": "2024-02-01T15:51:30.690Z",
        "provider": "email",
        "uid": "user_3@gmail.com",
        "allow_password_change": false,
        "name": null,
        "image": {
            "url": null
        },
        "description": null,
        "device_token": null
    },
    "errors": null
}
```

### Update Profile
endpoint: `PUT/PATCH` `/api/v1/users`

params: `name`, `description`, `image`

sample response:
```
{
    "code": 200,
    "message": null,
    "data": {
        "id": 3,
        "email": "user_3@gmail.com",
        "created_at": "2024-01-27T16:18:25.118Z",
        "updated_at": "2024-02-01T15:51:30.690Z",
        "provider": "email",
        "uid": "user_3@gmail.com",
        "allow_password_change": false,
        "name": null,
        "image": {
            "url": null
        },
        "description": null,
        "device_token": null
    },
    "errors": null
}
```