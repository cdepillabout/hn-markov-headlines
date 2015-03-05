
module Main where

import Web.HackerNews -- (getTopStories, hackerNews)

main :: IO ()
main = do
    result <- hackerNews getTopStories
    case result of
        Left err -> return () -- print err
        Right (TopStories storiesList) -> return ()

