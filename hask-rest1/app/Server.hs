module Main where

import Control.Monad.IO.Class

import Network.HTTP.Media ((//), (/:))
import Network.Wai
import Network.Wai.Handler.Warp

import Servant.Server
import Servant.API
import Data.Proxy

import API

server1 :: [User] -> Server API
server1 users = listUsers users
           :<|> queryUser users

listUsers users = return users
queryUser users uid_ gid_ = return $! case (uid_, gid_) of
  (Nothing, Nothing)   -> []
  (Just uid, Just gid) -> filter (\x -> userid x == uid && groupid x == gid) users
  (Just uid, Nothing) -> filter (\x -> userid x == uid) users
  (Nothing, Just gid) -> filter (\x -> groupid x == gid) users

app1 :: [User] -> Application
app1 db = serve userAPI (server1 db)

main :: IO ()
main = userdb >>= \db -> run 8000 (app1 db)
