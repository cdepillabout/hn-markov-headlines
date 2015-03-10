module Main where

import Control.Monad (forM_)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.MarkovChain (runMulti)
import Data.Serialize (decode)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (decodeUtf8)
import System.Random (getStdGen)


-- makeSomeStories :: [Text] -> IO ()
-- makeSomeStories storiesList = do
--         stdGen <- getStdGen
--         runMulti
makeSomeStories :: [(Int, ByteString)] -> IO ()
makeSomeStories storiesList = do
        let byteStringTitles = fmap snd storiesList
            stringTitles = fmap (Text.unpack . decodeUtf8) byteStringTitles
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
