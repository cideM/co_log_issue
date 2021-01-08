{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE NoImplicitPrelude #-}

import Colog
  ( HasLog (..),
    LogAction,
    Message,
    Msg (..),
    WithLog,
    cmap,
    log,
    richMessageAction,
    withLog,
    pattern D,
    pattern I,
  )
import qualified Data.Text.Lazy as TL
import Relude
import qualified Web.Scotty.Internal.Types as Scotty
import qualified Web.Scotty.Trans as Scotty

data AppEnv m = AppEnv {logAction :: !(LogAction m Message)}

instance HasLog (AppEnv m) Message m where
  getLogAction = logAction
  {-# INLINE getLogAction #-}

  setLogAction newLogAction env = env {logAction = newLogAction}
  {-# INLINE setLogAction #-}

newtype App a = App {unApp :: AppEnv App -> IO a}
  deriving
    ( Applicative,
      Functor,
      Monad,
      MonadIO,
      MonadReader (AppEnv App)
    )
    via ReaderT (AppEnv App) IO

handler :: (WithLog (AppEnv App) Message m, MonadIO m) => Scotty.ActionT TL.Text m ()
handler = withLog (cmap (\(msg :: Message) -> msg {msgText = "foo"})) $ do
  log I "Hi"
  Scotty.html $ mconcat ["<h1>Scotty, beam me up!</h1>"]

main = do
  let appEnv = AppEnv {logAction = richMessageAction}

  Scotty.scottyT 3123 (`unApp` appEnv) do
    Scotty.get "/" handler
