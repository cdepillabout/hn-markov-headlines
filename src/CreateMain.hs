module Main where

import Control.Monad.Error (ErrorT, runErrorT)
import Control.Monad.Trans.Class
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.Either
import Data.Serialize (decode)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (decodeUtf8)
import System.IO (hPutStrLn, stderr)
import Web.HackerNews -- (getTopStories, hackerNews)


makeSomeStories :: [(Int, Text)] -> IO ()
makeSomeStories storiesList = print $ length storiesList

main :: IO ()
main = do
    serializedList <- BS.getContents
    let decodedList = decode serializedList
    case decodedList of
        Left err ->
            putStrLn $
                "ERROR: Failed to decode the input string with the " ++
                "following error: " ++ err
        Right storiesList -> makeSomeStories $ map (fmap decodeUtf8) storiesList
