# Chat Room API

## Authenticate
### Login
endpoint: `POST` `/api/v1/auth/sign_in`

params: `email`, `password`, `device_token` (device_token is required to push notifications)

sample response:
```
Success:
{
    "data": {
        "email": "user_01@gmail.com",
        "provider": "email",
        "uid": "user_01@gmail.com",
        "image": {
            "url": "/uploads/user/image/1/avatar.jpg"
        },
        "id": 1,
        "allow_password_change": true,
        "name": "Nakajima",
        "description": "Hello world!!",
        "device_token": "xxxx"
    }
}

Error:
{
    "success": false,
    "errors": [
        "Invalid login credentials. Please try again."
    ]
}
```

**NOTICE**:
After logging in, the response will return the values ​​in the header used to attach headers in subsequent requests, those values ​​are: `access-token`, `token-type`, `client`, `expiry`, `uid`

Sample:
```
access-token:_vG4Nybdk6ejVt6hPvFKHg
token-type:Bearer
client:eYT7CGm09cICrHDZ9a8POQ
expiry:1707047022
uid:user_01@gmail.com
```

### Sign up
endpoint: `POST` `/api/v1/auth`

params: `name`, `email`, `password`, `device_token` (device_token is required to push notifications)

sample response:
```
Success:
{
    "status": "success",
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
    }
}

Error:
{
    "status": "error",
    "data": {
        "id": null,
        "email": "user_01@gmail.com",
        "created_at": null,
        "updated_at": null,
        "provider": "email",
        "uid": "",
        "allow_password_change": false,
        "name": "Takeuchi",
        "image": {
            "url": null
        },
        "description": null,
        "device_token": "xxx"
    },
    "errors": {
        "email": [
            "has already been taken"
        ],
        "full_messages": [
            "Email has already been taken"
        ]
    }
}
```

### Logout

endpoint: `DELTE` `/api/v1/auth/sign_out`

sample response:
```
Success:
{
    "success": true
}

Error:
{
    "success": false,
    "errors": [
        "User was not found or was not logged in."
    ]
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
Success:
{
    "success": true,
    "message": "An email has been sent to 'user_05@gmail.com' containing instructions for resetting your password."
}

Error:
{
    "success": false,
    "errors": [
        "Unable to find user with email 'user_06@gmail.com'."
    ]
}
```
2. API reset password
endpoint: `POST` `/api/v1/auth/password`

params: `email`

sample response:
```
Success:
{
    "success": true,
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
    "message": "Your password has been successfully updated."
}

Error:
{
    "success": false,
    "errors": [
        "You must fill out the fields labeled 'Password' and 'Password confirmation'."
    ]
}
```

## Chat Room
### List room
endpoint: `GET` `/api/v1/chat_rooms`

sample response:
```
Success:
[
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
]
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
Success:
{
    "data": {
        "id": 6,
        "name": "Room B",
        "created_at": "2024-01-21T13:16:15.551Z",
        "updated_at": "2024-01-21T13:16:15.551Z"
    }
}

Errors:
{
  error: 'xxx'
}
```
## Chat Message
### Create Message
endpoint: `POST` `/api/v1/chat_rooms/<room_id>/chat_messages`

params: `content`, `reply_to_message_id` (optional)

sample response:
```
Success:
{
    "data": {
        "id": 14,
        "content": "i miss you",
        "user_id": 1,
        "chat_room_id": 4,
        "created_at": "2024-01-21T12:49:49.116Z",
        "updated_at": "2024-01-21T12:49:49.116Z",
        "reply_to_message_id": null
    }
}

Error:
{
    "errors": [
        "xxx"
    ]
}
```

### List messages
endpoint: `GET` `/api/v1/chat_rooms/<room_id>/chat_messages`

sample response:
```
Success:
{
  "data": [
      {
          "id": 3,
          "content": "Hello!!",
          "user_id": 1,
          "chat_room_id": 4,
          "created_at": "2024-01-20T15:34:52.485Z",
          "updated_at": "2024-01-20T15:34:52.485Z",
          "reply_to_message_id": null
      },
      {
          "id": 4,
          "content": "Hello!!",
          "user_id": 2,
          "chat_room_id": 4,
          "created_at": "2024-01-20T15:35:06.841Z",
          "updated_at": "2024-01-20T15:35:06.841Z",
          "reply_to_message_id": 1
      },
  ]
}
```

## User
### Find users
endpoint: `GET` `/api/v1/users`

params: `name`

sample response:
```
Success:
{
    "data": [
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
        }
    ]
}
```
### Profile

endpoint: `GET` `/api/v1/users/<id>`

sample response:
```
Success:
{
    "data": {
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
    }
}
```

### Update Profile
endpoint: `PUT/PATCH` `/api/v1/users`

params: `name`, `description`, `image`

sample response:
```
Success:
{
    "data": {
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
    }
}

Error:
{
    "errors": [
        "xxx"
    ]
}
```