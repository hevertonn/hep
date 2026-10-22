module Main (main) where

import System.Directory (doesDirectoryExist, doesFileExist)
import System.Directory.Extra (listFilesRecursive)
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs

  case args of
    [] -> putStrLn helpText
    [pattern] -> do
      files <- listFiles ["."]
      putStrLn ("Pattern: " ++ pattern ++ " - Files: " ++ show files)
    (pattern : paths) -> do
      files <- listFiles paths
      putStrLn ("Pattern: " ++ pattern ++ " - Files: " ++ show files)

helpText :: String
helpText =
  "Hep - A grep tool written in Haskell.\n"
    ++ "\n"
    ++ "Usage: hep PATTERN [FILES]"

listFiles :: [FilePath] -> IO [FilePath]
listFiles [] = pure []
listFiles (x : xs) = do
  isFile <- doesFileExist x
  isDirectory <- doesDirectoryExist x

  fileList <- (if isFile then pure [x] else if isDirectory then listFilesRecursive x else pure [])
  otherFiles <- listFiles xs

  pure (fileList ++ otherFiles)
