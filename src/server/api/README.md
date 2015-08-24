API
===

This file documents the different components of the API. The API is used primarily to communicate with the Angular.js frontend and other 3rd-party applications.


File naming convention
----------------------
Each of the files here follow a simple naming convention. Each sub-folder represent a part of the url and the filename inside the folder will represent for which type of method the controller will be called.


For example:
```
GET   /api/users    -> /api/users/get.coffee
POST  /news/stories -> /news/stories/post.coffee
```

File contents
-------------
Each file gets initialized by `eletrolyte (IoC)` and not `require`. The object returned by each file should be an object that has a `routes` and `controller` parameter (see a [sample file](./users/get.coffee) for an example).

The `routes` parameter should contain an array of all the possible routes the controller should match for. The `controller` parameter is the actual controller itself. Keep in mind that all routes get appended with a `/api` in the [route file](../routes/api.coffee).