# README

**Register User**
----

* **POST /api/users**
  
* **Headers**

  * **Required: Content-Type: application/json**
    
* **Data Params**

  ```json
  {
      "user": {
          "email": [string],
          "password": [string],
          "password_confirmation": [string]
      }
  }
  ```


* **Success Response:**
  
  * **Code:** 201 CREATED <br />
    **Content:** `{"data":{"id":[integer],"type":"users","attributes":{"email":[string]}}}`
 
* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ "errors" : ["Email has already been taken"] }`

* **Sample Call:**

  `curl -X POST -H "Content-Type: application/json" -d '{"user": {"email": "xyz","password":"xyz"}}' http://localhost:3000/api/users
`
* **Notes:**
  To use API user needs to have access token. To get one, post to /oauth/token (see the endpoint description below)
  **Register a User**
  ----
  
* **POST /api/users**

* **Headers**

  * **Required: Content-Type: application/json**
 

* **Data Params**
    
    ```json
    {
        "user": {
            "email": [string],
            "password": [string],
            "password_confirmation": [string]
        }
    }
    ```


* **Success Response:**

  * **Code:** 201 CREATED <br />
    **Content:** `{"data":{"id":[integer],"type":"users","attributes":{"email":[string]}}}`

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ "errors" : ["Email has already been taken"] }`

* **Sample Call:**

  `curl -X POST -H "Content-Type: application/json" -d '{"user": {"email":"xyz","password":"xyz","password_confirmation":"xyz"}}' http://localhost:3000/api/users`

* **Notes:**

  To use API user needs to have access token. To get one, post to /oauth/token (see the endpoint description below)

**Get access token for User**
----

* **POST /oauth/token**
  
* **Headers**

  * **Required: Content-Type: application/json**

* **Data Params**

  ```
  {
    "grant_type": "password",
    "email": [string],
    "password": [string]
  }
  ```

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    ```json
    {
        "access_token": [string],
        "token_type": "bearer",
        "expires_in": [integer],
        "refresh_token": [string],
        "created_at": [integer]
    }
    ```
 
* **Error Response:**

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** <br />
    ```json
    {
        "error": "invalid_grant",
        "error_description": "The provided authorization grant is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client."
    }
    ```
  
* **Sample Call:**

  `curl -X POST -H "Content-Type: application/json" -d '{"grant_type":"password","email":"xyz","password":"xyz"}' http://localhost:3000/oauth/token
`
* **Notes:**
  The access token needs to be included in headers 
  in every request other than user registration in order to 
  access API resources.
 
**Create Event**
----

* **POST /api/events**
  
* **Headers**

  * **Required:**
  
    Content-Type: application/json <br />
    Authorization: Bearer [access token]

* **Data Params**

  ```json
  {
      "event": {
          "time": [datetime],
          "place": [string],
          "purpose": [string]
      }
  }
  ```

* **Success Response:**
  
  * **Code:** 201 CREATED <br />
    **Content:** <br />
    ```json
    {
        "data": {
            "id": [integer],
            "type": "events",
            "attributes": {
                "time": [datetime],
                "place": [string],
                "purpose": [string]
            }
        }
    }
    ```
 
* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:**
    `{"error": "Time should be in the future"}`
  
* **Sample Call:**

  `curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" -d '{"event":{"time":"2018-01-25 06:34:13 UTC","purpose":"wedding"}}' http://localhost:3000/api/events`
  
**Show closest Events**
----

* **GET /api/events**
  
* **Headers**

  * **Required: none**
  
* **URL Params**

  * **Required:**
  
    due: [datetime in iso8601 format]

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    ```json
    {
        "data": [
            {
                "id": [integer],
                "type": "events",
                "attributes": {
                    "time": [datetime],
                    "place": [string],
                    "purpose": [string]
                }
            }
        ]
    }
    ```
 
* **Error Responses:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:**
    `{"error": "Time interval should be in ISO8601 format"}`

  * **Code:** 400 BAD REQUEST <br />
    **Content:**
    `{"error": "No time interval provided"}`
  
* **Sample Call:**

  `curl -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" http://localhost:3000/api/events?due=2019-01-01T04:05:06`

**Show Event**
----

* **GET /api/events/:id**

* **Headers**

  * **Required:**
  
    Authorization: Bearer [access token]

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    ```json
    {
        "id": [integer],
        "time": [datetime],
        "place": [string],
        "purpose": [string],
        "created_at": [datetime],
        "updated_at": [datetime],
        "owner": [integer]
    }
    ```
 
* **Error Responses:**

  * **Code:** 404 NOT FOUND <br />
    **Content:**
    `{"error": "The event does not exist"}`
  
* **Sample Call:**

  `curl -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" http://localhost:3000/api/events/3`

**Update Event**
----

* **PUT or PATCH /api/events/:id**

* **Headers**

  * **Required:**
  
    Content-Type: application/json <br />
    Authorization: Bearer [access token]

* **Data Params**

  ```json
  {
      "event": {
          "time": [datetime],
          "place": [string],
          "purpose": [string]
      }
  }
  ```

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    ```json
    {
        "data": {
            "id": [integer],
            "type": "events",
            "attributes": {
                "time": [datetime],
                "place": [string],
                "purpose": [string]
            }
        }
    }
    ```
 
* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:**
    `{"error": "Time should be in the future"}`
  
* **Sample Call:**

  `curl -X UPDATE -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" -d '{"event":{"time":"2018-01-25 06:34:13 UTC","purpose":"wedding"}}' http://localhost:3000/api/events/3`

**Delete Event**
----

* **DELETE /api/events/:id**

* **Headers**

  * **Required:**
  
    Authorization: Bearer [access token]

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    `{"message": "The event has been deleted"}`
 
* **Error Response:**

  * **Code:** 404 NOT FOUND <br />
    **Content:**
    `{"error": "The event does not exist"}`
  
* **Sample Call:**

  `curl -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" http://localhost:3000/api/events/3`

**Invite other Users to Event**
----

* **POST /api/events/:id/invite**
  
* **Headers**

  * **Required:**
  
    Content-Type: application/json <br />
    Authorization: Bearer [access token]

* **Data Params**

  ```json
  {
      "users": {
          "emails": [
              [string]  
          ]
      }
  }
  ```

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    `{"message": "Users have been successfully invited"}`
 
* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:**
    ```json
    {
        "error": [
            "<email> is not among registered users"
        ]
    }
    ```
  
* **Sample Call:**

  `curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" http://localhost:3000/api/events/3/invite`
  
**Show event's feed**
----

* **GET /api/events/:id/feed**
  
* **Headers**

  * **Required:**
  
    Content-Type: application/json <br />
    Authorization: Bearer [access token]

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    ```json
    [{
          "id":[integer],
          "type":"attachments",
          "attributes": {
              "filename":[string],
              "content_type":[string],
              "file_contents":[string],
              "event_id":[integer],
              "created_at":[datetime],
              "updated_at":[datetime],
              "user_id":[integer]}
     },
     {
          "id":[integer],
          "type":"comments",
          "attributes": {
              "text":[string],
              "created_at":[datetime],
              "updated_at":[datetime],
              "user_id":[integer],
              "event_id":[integer]
      }
      ...
     }]
    ```
 
* **Error Response:**

  * **Code:** 403 FORBIDDEN <br />
    **Content:**
    `{errors: 'User cannot modify this resource'}`
  
* **Sample Call:**

  `curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" http://localhost:3000/api/events/3/feed`
  
  
**Attach file to Event**
----

* **POST /api/events/:event_id/attachments**
  
* **Headers**

  * **Required:**
  
    Content-Type: application/json <br />
    Authorization: Bearer [access token]

* **Data Params**

  ```json
  {
      "attachment": {
          "filename": [string],
          "content_type": [string],
          "file_contents": [string]
      }
  }
  ```

* **Success Response:**
  
  * **Code:** 201 CREATED <br />
    **Content:** <br />
    `{"message": "File has been saved"}`
 
* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{"error": "No files to attach"}`
    
  * **Code:** 404 NOT FOUND <br />
    **Content:** `{"error": "No such event or attachment"}`

  * **Code:** 403 FORBIDDEN <br />
    **Content:** `{"message": "User cannot modify this resource"}`

* **Sample Call:**

  `curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" http://localhost:3000/api/events/3/attachments`
  

**Delete file from Event**
----

* **DELETE /api/events/:event_id/attachments/:id**
  
* **Headers**

  * **Required:**
  
    Authorization: Bearer [access token]

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    `{"data": {"message": "File has been deleted"}}`
 
* **Error Response:**
    
  * **Code:** 404 NOT FOUND <br />
    **Content:** `{"errors": "No such event or attachment"}`

  * **Code:** 403 FORBIDDEN <br />
    **Content:** `{"data":{"message": "User cannot modify this resource"}}`

* **Sample Call:**

  `curl -X DELETE -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" http://localhost:3000/api/events/3/attachments/1`
  
**Show all Comments**
----

* **GET /api/events/:event_id/comments**
  
* **Headers**

  * **Required:**
  
    Authorization: Bearer [access token]

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    ```json
    {
        "data": [{
            "id": [integer],
            "type": "comments",
            "attributes": {
                "text": [string]
            }
        }]
    }
    ```
 
* **Error Response:**

  * **Code:** 403 FORBIDDEN <br />
  * **Code:** 400 BAD REQUEST <br />
  
* **Sample Call:**

  `curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" http://localhost:3000/api/events/3/comments`
    
  
**Create Comment**
----

* **POST /api/events/:event_id/comments**
  
* **Headers**

  * **Required:**
  
    Content-Type: application/json <br />
    Authorization: Bearer [access token]

* **Data Params**

  `{ "text": [string] }`

* **Success Response:**
  
  * **Code:** 201 CREATED <br />
    **Content:** <br />
    ```json
    {
        "data": {
            "id": [integer],
            "type": "comments",
            "attributes": {
                "text": [string]
            }
        }
    }
    ```
 
* **Error Response:**

  * **Code:** 403 FORBIDDEN <br />
  * **Code:** 400 BAD REQUEST <br />
  
* **Sample Call:**

  `curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" -d '{"text":"hello world"}' http://localhost:3000/api/events/3/comments`
  
**Update Comment**
----

* **PUT or PATCH /api/events/:event_id/comments/:id**

* **Headers**

  * **Required:**
  
    Content-Type: application/json <br />
    Authorization: Bearer [access token]

* **Data Params**

  `{ "text": [string] }`

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    ```json
    {
      data: {
        message: 'The comment has been updated'
      }
    }
    ```
 
* **Error Response:**

  * **Code:** 403 FORBIDDEN <br />
    **Code:** 400 BAD REQUEST
  
* **Sample Call:**

  `curl -X UPDATE -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" -d '{"text":"something new"}' http://localhost:3000/api/events/3/comments/1`

**Delete Comment**
----

* **DELETE /api/events/:event_id/comments/:id**

* **Headers**

  * **Required:**
  
    Authorization: Bearer [access token]

* **Success Response:**
  
  * **Code:** 200 OK <br />
    **Content:** <br />
    `{data: {message: 'The comment has been deleted'}}`
 
* **Error Response:**

  * **Code:** 403 FORBIDDEN <br />
  * **Code:** 404 NOT FOUND
    **Content:**
    `{"errors": "The comment does not exist"}`
  
* **Sample Call:**

  `curl -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer ab5847534f519d4fd5caa7424f27a471e9aa50c9c7d6a9ce543c18c87a7032f0" http://localhost:3000/api/events/3/comments/1`
