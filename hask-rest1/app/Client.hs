module Main where

import Control.Monad.IO.Class

import Servant.Client
import Servant.API
import Data.Proxy

import Options.Applicative
import Control.Applicative
import Data.Monoid
import Data.Maybe

import Network.HTTP.Client (newManager, defaultManagerSettings, Manager)

import API

url = BaseUrl Http "localhost" 8000 ""

listUsers :<|> queryUser = client userAPI

queries uid gid = case (uid, gid) of
  (Nothing, Nothing) -> listUsers
  _                  -> queryUser uid gid

clientApp uid gid = do
  mgr <- newManager defaultManagerSettings
  runClientM (queries uid gid) (ClientEnv mgr url)

data Cmdline = Cmdline {
    uid :: Maybe Int
  , gid :: Maybe Int
  } deriving Show

cmdlineOpts = Cmdline
         <$> (optional $ option auto $ long "userid"  <> short 'u' <> metavar "USERID" <> help "user id")
         <*> (optional $ option auto $ long "groupid" <> short 'g' <> metavar "GROUPID" <> help "group id")

opts = info (cmdlineOpts <**> helper)
            ( fullDesc
           <> progDesc "query rest api by optional userid or groupid"
           <> header "hask-rest1-client" )

main :: IO ()
main = execParser opts >>= \(Cmdline uid gid) -> clientApp uid gid >>= either print (mapM_ print)
