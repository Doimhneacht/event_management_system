# README

**Register a User**
----

* **POST /api/users**
  
* **URL Params**

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
    
  * **URL Params**
  
    **Required: none**
     
    **Optional: none**
  
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
  
    `curl -X POST -H "Content-Type: application/json" -d '{"user": {"email":"xyz","password":"xyz","password_confirmation":"xyz"}}' http://localhost:3000/api/users
  `
  * **Notes:**
  
    To use API user needs to have access token. To get one, post to /oauth/token (see the endpoint description below)
  
**Get an access token for a User**
----

* **POST /oauth/token**
  
* **URL Params**

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
 
**Create an Event**
----

* **POST /api/events**
  
* **URL Params**

  * **Required:**
  
    Content-Type: application/json <br />
    Authorization: Bearer [access token]
   
  * **Optional: none**

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
  
**Show an Event**
----

* **GET /api/events/:id**
  
**Update an Event**
----

**Delete an Event**
----

**Attach a file to an Event**
----

**Delete a file from an Event**
----

**Invite other Users to an Event**
----
