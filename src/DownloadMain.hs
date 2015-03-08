
module Main where

import Control.Monad.Error (ErrorT, runErrorT)
import Control.Monad.Trans.Class
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.Either
import Data.Serialize (encode)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (encodeUtf8)
import System.IO (hPutStrLn, stderr)
import Web.HackerNews -- (getTopStories, hackerNews)

getStoriesList :: ErrorT String IO [Int]
getStoriesList = do
    --lift $ putStrLn "Starting"
    result <- lift $ hackerNews getTopStories
    --lift $ putStrLn "Got response from api..."
    case result of
        Left _ -> fail "failed to get a response" -- MaybeT $ return Nothing
        Right (TopStories storiesList) -> return storiesList

downloadStory :: Int -> (Int, Int) -> ErrorT String IO (Int, Text)
downloadStory tryNum@5 (storyInt, index) = do
    let msg = "Warning: failed to get a response from downloadStory for story " ++
                show storyInt ++ " at index " ++ show index ++
                " after trying " ++ show tryNum ++ " times."
    lift $ hPutStrLn stderr msg
    fail msg
downloadStory tryNum (storyInt, index) = do
    -- lift $ putStrLn $ "Downloading story " ++ show index
    storyEither <- lift $ hackerNews (getStory (StoryId storyInt))
    case storyEither of
        Left _ -> downloadStory (tryNum + 1) (storyInt, index)
        Right story -> return (storyInt, storyTitle story)

downloadStories :: [Int] -> IO [(Int, Text)]
downloadStories storiesList = do
        let storyWithIndexList = zip storiesList [1..]
        let downloadedListErrorT = map (downloadStory 0)
                                       -- (take 20 storyWithIndexList)
                                       storyWithIndexList
        downloadedList <- mapM runErrorT downloadedListErrorT
        return $ rights downloadedList

serialize :: [(Int, Text)] -> IO ()
serialize titleList = do
        let byteStringTitleList = map (fmap encodeUtf8) titleList
        let encodedTitleList = encode byteStringTitleList
        -- print titleList
        BS.putStr encodedTitleList

downloadAndSerialize :: IO (Either String ())
downloadAndSerialize =
    runErrorT $ do
        storiesList <- getStoriesList
        titleList <- lift $ downloadStories storiesList
        lift $ serialize titleList

main :: IO ()
main = do
    result <- downloadAndSerialize
    case result of
        Left err -> print $ "ERROR: " ++ show err
        Right _ -> print "SUCCESS"
