module Main (main) where

import Control.Monad
import Data.Char
import Data.List
import Data.List.Split
import System.Exit
import System.IO

import TTT.AI
import TTT.Game
import TTT.Utils

main :: IO ()
main = do
  putStr "-----------------"
  putStrLn "\n Tic Taskell Toe \n"
  putStrLn help

  gs <- initGame
  loop gs

  where
    nextState p gs
      | isAI p = return $ playFor p gs
      | otherwise = interactive p gs

    loop gs = do
        putStrLn $ renderPrettyBoard $ board gs
        ns <- nextState (currentPlayer gs) gs

        let bs = checkBoard $ board ns
        case bs of
          Playable -> loop ns
          _        -> (putStrLn $ renderWinner bs $ board ns) >> exitSuccess

interactive :: Player -> GameState -> IO GameState
interactive p gs = do
  putStr $ promptPlayer p
  hFlush stdout

  l <- getLine
  let c = maybeRead l

  case c of
    Just i
      | (\d -> d `elem` [1..9]) i -> do
          either
            (\s -> putStrLn ("\n" ++ s) >> return gs)
            (\ns -> return ns)
            (playTurn p gs (i-1))
      | otherwise -> (putStrLn "Invalid choice!\n") >> return gs
    Nothing -> if l == "q"
                then (putStrLn help) >> return gs
                else (putStrLn "Invalid choice!\n") >> return gs

initGame :: IO GameState
initGame = do
  putStrLn "What game configuration would you like?"
  putStrLn "  1) Player(X) vs. Player(O)"
  putStrLn "  2) Player(X) vs. AI(O)"
  putStrLn "  3) AI(X) vs. Player(O)"

  putStr "\n  Choose configuration: "
  hFlush stdout

  c <- getLine
  let a = maybeRead c

  case a of
    Just 1  -> return (GameState initBoard (Player 1 False) (Player 2 False))
    Just 2  -> return (GameState initBoard (Player 1 False) (Player 2 True))
    Just 3  -> return (GameState initBoard (Player 1 True) (Player 2 False))
    Nothing -> do
      putStrLn "Invalid choice!"
      initGame
