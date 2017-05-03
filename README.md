# rest1

service below rest api:

url base: https://localhost:8000

1. end point 1, query all users with uid >= 100. ep = `/users`   (https://localhost/users)
2. end point 2, query user by user id or group id, ep = `/user?uid=<UID>&gid=<GID>` (return list of users)

return json object

```haskell
data User = User {
    username :: String
  , userid   :: Int
  , groupid  :: Int
  , shell    :: String
}
```

userdb should read from `/etc/passwd` satisfy [1.]

(optional) Client: query server with similar manor, although using a web browser is also sufficient.
