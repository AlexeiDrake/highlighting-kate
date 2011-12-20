{-# LANGUAGE TypeSynonymInstances, FlexibleInstances #-}
{- |
   Module      : Text.Highlighting.Kate.Definitions
   Copyright   : Copyright (C) 2008 John MacFarlane
   License     : GNU GPL, version 2 or above 

   Maintainer  : John MacFarlane <jgm@berkeley.edu>
   Stability   : alpha 
   Portability : portable

Definitions for data structures needed by highlighting-kate.
-}

module Text.Highlighting.Kate.Definitions where
import qualified Data.Map as Map
import Text.ParserCombinators.Parsec
import Data.Word
import Text.Printf

-- | A stack of context names for each language.  (Language-specific context
-- stacks must be maintained because of IncludeRules.)
type ContextStack = Map.Map String [String]

-- | State for syntax parser.
data SyntaxState = SyntaxState
  { synStContexts             :: ContextStack -- ^ Stack of contexts
  , synStLanguage             :: String       -- ^ Language being parsed 
  , synStCurrentLine          :: String       -- ^ Contents of current line
  , synStCharsParsedInLine    :: Int          -- ^ Num characters parsed in line
  , synStPrevChar             :: Char         -- ^ Last character parsed
  , synStCaseSensitive        :: Bool         -- ^ Language is case-sensitive
  , synStKeywordCaseSensitive :: Bool         -- ^ Keywords are case-sensitive
  , synStCaptures             :: [String]     -- ^ List of regex captures from
                                              --   last capturing match
  } deriving (Read, Show)

-- | A pair consisting of a list of attributes and some text.
type Token = (TokenType, String)

data TokenType = KeywordTok
               | DataTypeTok
               | DecValTok
               | BaseNTok
               | FloatTok
               | CharTok
               | StringTok
               | CommentTok
               | OtherTok
               | AlertTok
               | FunctionTok
               | RegionMarkerTok
               | ErrorTok
               | NormalTok
               deriving (Read, Show, Eq)

-- | A line of source, list of labeled source items.
type SourceLine = [Token]

type KateParser = GenParser Char SyntaxState

data TokenFormat = TokenFormat {
    tokenColor      :: Maybe Color
  , tokenBackground :: Maybe Color
  , tokenBold       :: Bool
  , tokenItalic     :: Bool
  , tokenUnderline  :: Bool
  } deriving (Show, Read)

format :: TokenFormat
format = TokenFormat {
    tokenColor      = Nothing
  , tokenBackground = Nothing
  , tokenBold       = False
  , tokenItalic     = False
  , tokenUnderline  = False
  }

data Color = RGB Word8 Word8 Word8 deriving (Show, Read)

class ToColor a where
  toColor :: a -> Maybe Color

instance ToColor String where
  toColor ['#',r1,r2,g1,g2,b1,b2] =
     case reads ['(','0','x',r1,r2,',','0','x',g1,g2,',','0','x',b1,b2,')'] of
           ((r,g,b),_) : _ -> Just $ RGB r g b
           _                                         -> Nothing
  toColor _        = Nothing

instance ToColor (Word8, Word8, Word8) where
  toColor (r,g,b) = Just $ RGB r g b

instance ToColor (Double, Double, Double) where
  toColor (r,g,b) | r >= 0 && g >= 0 && b >= 0 && r <= 1 && g <= 1 && b <= 1 =
          Just $ RGB (floor $ r * 255) (floor $ g * 255) (floor $ b * 255)
  toColor _ = Nothing

class FromColor a where
  fromColor :: Color -> a

instance FromColor String where
  fromColor (RGB r g b) = printf "#%02x%02x%02x" r g b

instance FromColor (Double, Double, Double) where
  fromColor (RGB r g b) = (fromIntegral r / 255, fromIntegral g / 255, fromIntegral b / 255)

instance FromColor (Word8, Word8, Word8) where
  fromColor (RGB r g b) = (r, g, b)

data Format = Format {
    tokenFormats    :: [(TokenType, TokenFormat)]
  , defaultColor    :: Maybe Color
  , backgroundColor :: Maybe Color
  }

