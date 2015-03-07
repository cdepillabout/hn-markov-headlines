
module Main where

import Control.Monad
import Control.Monad.Trans.Class
import Control.Monad.Trans.Maybe
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.Serialize (encode)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (encodeUtf8)
import Web.HackerNews -- (getTopStories, hackerNews)

getStoriesList :: MaybeT IO [Int]
getStoriesList = do
    --lift $ putStrLn "Starting"
    result <- lift $ hackerNews getTopStories
    --lift $ putStrLn "Got response from api..."
    case result of
        Left _ -> fail "failed to get a response" -- MaybeT $ return Nothing
        Right (TopStories storiesList) -> return storiesList

downloadStory :: Int -> MaybeT IO (Int, Text)
downloadStory storyInt = do
    storyEither <- lift $ hackerNews (getStory (StoryId storyInt))
    case storyEither of
        Left _ -> fail "failed to get a response"
        Right story -> return (storyInt, storyTitle story)

downloadStories :: [Int] -> MaybeT IO [(Int, Text)]
downloadStories storiesList = forM
                                --(take 2 storiesList)
                                storiesList
                                downloadStory

serialize :: [(Int, Text)] -> IO ()
serialize titleList = do
        let byteStringTitleList = map (fmap encodeUtf8) titleList
        let encodedTitleList = encode byteStringTitleList
        BS.putStr encodedTitleList

main :: IO ()
main = void $ runMaybeT $ do
    storiesList <- getStoriesList
    titleList <- downloadStories storiesList
    lift $ serialize titleList


