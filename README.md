# Integration Basics with Ballerina - Advanced

## Training Objective

Cover some integration scenarios with the Ballerina Forum application.

## Areas Covered

- Scheduling tasks
- Consuming and producing events using NATS
- Reading a file
- Using gmail connector to send emails

## Prerequisites

- Install the latest version of Ballerina
- Set up VS code by installing the Ballerina extension
- Install Docker
- Complete the `Integration Basics with Ballerina` training.

## Extended Scenario

The Ballerina Forum application is a simple forum application that allows users to create posts and comment on them. The application is written using the Ballerina language and exposes a REST API. The application uses a MySQL database to store the data.

The forum REST service exposes the following resources:

| Resource                       | Description                            |
|--------------------------------|----------------------------------------|
| `POST api/users`               | Create a new user                      |
| `POST api/login`               | Login as with user credentials         |
| `POST api/users/{id}/posts`    | Create a new forum post                |
| `GET api/posts`                | Get all the forum posts                |
| `GET api/posts/{id}`           | Get the forum post specified by the id |
| `POST api/posts/{id}/likes`    | Like a forum post                      |
| `POST api/posts/{id}/comments` | Comment on a post                      |

> **Note:** The service should be started in port **4000** to test with the frontend application.

For testing, the MySQL database can be started using the docker-compose. The database is configured with the following properties:

| Property | Value          |
|----------|----------------|
| Host     | localhost      |
| Port     | 3306           |
| Username | forum_user     |
| Password | dummypassword  |
| Database | forum_database |

Following is the entity relationship diagram:

![Entity Relationship Diagram](images/bal-forum-erd.png)

This training will extend the Ballerina Forum application with the following features:

1. Schedule a one-time task to creat a new forum post
2. Produce a NATS event when a new user is registered
3. Consume the above event and send an email to the user with the welcome note provided in a file

![Component Diagram](images/bal-forum.png)

## Task 1 - Schedule a one-time task to create a new forum post

The Post creation resource can now accept a query parameter named `schedule` which specify the timestamp to schedule the post creation. This query parameter is **optional** and if not provided, the post will be created immediately.

Example:

- Request URL : `http://localhost:4000/api/users/1/posts?schedule=2023-12-08T10:00:00Z`
- Request Body :
  
  ```json
  {
    "title": "This is a sample title",
    "description": "This is a sample description",
    "timestamp": "2023-12-05T10:15:30.00Z"
  }
  ```

- SuccessResponse - `202 Accepted`:
  
  ```json
  {
    "message": "Post creation scheduled successfully"
  }
  ```

- FailureResponse - `400 Bad Request`:
  
  ```json
  {
    "message": "Invalid post schedule request"
  }
  ```

> **Hint:** Refer to [Schedule one time job](https://ballerina.io/learn/by-example/task-one-time-job-execution/) example in the Ballerina by Example guide.

## Task 2 - Produce a NATS event when a new user is registered

When a new user is registered, a NATS event should be produced to the subject `ballerina.forum.new.user` with the following payload:

```json
{
  "email": "john@gmail.com"
} 
```

> **Note:** For testing, the NATS server can be started using the docker-compose. Connect the NATS client to `nats://localhost:4222`.

> **Hint:** Refer to [NATS client - Publish message](https://ballerina.io/learn/by-example/nats-basic-pub/) example in the Ballerina by Example guide.

## Task 3 - Consume the above event and send an email to the user with the welcome note provided in a file

A Ballerina NATS server is defined in the `backend/nats-mail-notifier` directory. This server is configured to consume the NATS event produced in the previous task.

Add a [Gmail connector](https://central.ballerina.io/ballerinax/googleapis.gmail/4.0.0) to send an email to the user with the welcome note provided in `resources` directory. The email should be sent to the email address provided in the NATS event payload.

> **Hints:**
>
> - Refer to the Setup Gmail API section to obtain the credentials and configure the connector.
>
> - Refer to the [send mails example](https://github.com/ballerina-platform/module-ballerinax-googleapis.gmail/blob/master/examples/send-mails/main.bal) to send an email using the Gmail connector.
>
> - Use [the Ballerin IO module](https://central.ballerina.io/ballerina/io/latest) to read the content of the file as string.
