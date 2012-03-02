module Main (main) where

import Control.Monad
import Data.Char
import Data.List
import Data.List.Split
import System.Exit
import System.IO

import TTT.Game

main :: IO ()
main = do

  putStr "-----------------"
  putStrLn "\n Tic Taskell Toe \n"
  putStrLn help

  loop initBoard

  where 
    loop b = do
        s <- interactive b
        loop s

interactive :: Board -> IO Board
interactive b = do 
  putStr "Enter index: "
  hFlush stdout

  c <- getChar
  l <- getLine -- chew up any reamining character

  case c of 
    i | i == 'q' -> exitSuccess
      | i == '?' -> (putStr help) >> return b
      | (\d -> d `elem` ['1'..'9']) i -> do
          -- todo: stepgame using input 
          putStrLn $ "\n **Board State**\n\n" ++ renderBoard b ++ "\n"
          return b
      | otherwise -> (putStrLn "Invalid choice! Type '?' for help...") >> return b
  
renderBoard :: Board -> String
renderBoard b = 
    intercalate "\n_____|_____|_____\n" $ 
             map (intercalate "|") $
             splitEvery 3 $ 
             map (\x -> "  " ++ (renderTile x) ++ "  ") b
    

renderTile :: TileContents -> String
renderTile c = 
  case c of
    X     -> "X"
    O     -> "O"
    Empty -> "-"
    
help :: String
help = "   **Indexes**\n\n" ++
    "  1  |" ++ "  2  |" ++"  3" ++
    "\n_____|_____|_____\n" ++
    "  4  |" ++ "  5  |" ++"  6" ++
    "\n_____|_____|_____\n" ++
    "  7  |" ++ "  8  |" ++"  9" ++
    "\n     |     |     \n" 