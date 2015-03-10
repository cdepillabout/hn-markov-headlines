module Main where

import Control.Monad (forM_)
import Control.Monad.Error (ErrorT, runErrorT)
import Control.Monad.Trans.Class
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as Char8
import Data.Either
import Data.MarkovChain (runMulti)
import Data.Serialize (decode)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (decodeUtf8)
import System.IO (hPutStrLn, stderr)
import System.Random (getStdGen)
import Web.HackerNews -- (getTopStories, hackerNews)


-- makeSomeStories :: [Text] -> IO ()
-- makeSomeStories storiesList = do
--         stdGen <- getStdGen
--         runMulti
makeSomeStories :: [(Int, ByteString)] -> IO ()
makeSomeStories storiesList = do
        let byteStringTitles = fmap snd storiesList
            stringTitles = fmap (Text.unpack . decodeUtf8) byteStringTitles
        -- let byteStringTitleList = map (fmap encodeUtf8) titleList
        -- let encodedTitleList = encode byteStringTitleList
        stdGen <- getStdGen
        -- forM_ stringTitles print
        forM_ (take 100 $ runMulti 5 stringTitles 0 stdGen) print

main :: IO ()
main = do
    serializedList <- BS.getContents
    let decodedList = decode serializedList
    case decodedList of
        Left err ->
            putStrLn $
                "ERROR: Failed to decode the input string with the " ++
                "following error: " ++ err
        Right storiesList -> makeSomeStories storiesList
