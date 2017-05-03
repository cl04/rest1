{-# LANGUAGE OverloadedStrings, FlexibleContexts, DataKinds, TypeFamilies, TypeOperators, DeriveGeneric, MultiParamTypeClasses #-}

module API (
    User (..)
  , userdb
  , API (..)
  , userAPI
  ) where

import Servant.Server
import Servant.Client
import Servant.API
import Data.Proxy
import Data.Aeson
import GHC.Generics
import System.Posix.User

-- User from /etc/passwd where uid >= 100
data User = User {
    username :: String
  , userid   :: Int
  , groupid  :: Int
  , shell    :: String
  } deriving (Show, Generic)

instance FromJSON User
instance ToJSON User

fromUserEnt :: UserEntry -> User
fromUserEnt (UserEntry name pass uid gid gecos homedir sh) = User name (fromIntegral uid) (fromIntegral gid) sh

userdb :: IO [User]
userdb = getAllUserEntries >>= \ents -> return . map fromUserEnt . filter (\ent -> ((fromIntegral . userID) ent) >= 100) $ ents

type API = "users" :> Get '[JSON] [User]
      :<|> "user" :> QueryParam "uid" Int :> QueryParam "gid" Int :> Get '[JSON] [User]

userAPI :: Proxy API
userAPI = Proxy
