
module Main where

import Control.Monad
import Control.Monad.Trans.Class
import Control.Monad.Trans.Maybe
import Web.HackerNews -- (getTopStories, hackerNews)

(<<) :: Monad m => m a -> m b -> m a
(<<) = flip (>>)

getStoriesList :: MaybeT IO [Int]
getStoriesList = do
    lift $ putStrLn "Starting"
    result <- lift $ hackerNews getTopStories
    lift $ putStrLn "Got response from api..."
    case result of
        Left _ -> fail "failed to get a response" -- MaybeT $ return Nothing
        Right (TopStories storiesList) -> return storiesList

downloadStory :: Int -> IO ()
downloadStory storyInt = do
    print =<< hackerNews (getStory (StoryId storyInt))


downloadStories :: [Int] -> MaybeT IO ()
downloadStories storiesList = do
    lift $ forM_ (take 2 storiesList) downloadStory

main :: IO ()
main = void $ runMaybeT $ do
    maybeStoriesList <- getStoriesList
    lift $ print maybeStoriesList
    downloadStories maybeStoriesList


