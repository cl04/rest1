{-# LANGUAGE OverloadedStrings, FlexibleContexts, DataKinds, TypeFamilies, TypeOperators, DeriveGeneric, MultiParamTypeClasses #-}

module API (
    User (..)
  , API (..)
  , userAPI
  ) where

import Servant.Server
import Servant.Client
import Servant.API
import Data.Proxy
import Data.Aeson
import GHC.Generics

-- User from /etc/passwd where uid >= 100
data User = User {
    username :: String
  , userid   :: Int
  , groupid  :: Int
  , shell    :: String
  } deriving (Show, Generic)

instance FromJSON User
instance ToJSON User

type API = "users" :> Get '[JSON] [User]
      :<|> "user" :> QueryParam "uid" Int :> QueryParam "gid" Int :> Get '[JSON] [User]

userAPI :: Proxy API
userAPI = Proxy
