{- |
   Module      : Text.Highlighting.Kate
   Copyright   : Copyright (C) 2008-2011 John MacFarlane
   License     : GNU GPL, version 2 or above

   Maintainer  : John MacFarlane <jgm@berkeley.edu>
   Stability   : alpha
   Portability : portable

This helper module exports the main highlighting and formatting
functions.

A typical application will combine a highlighter and a formatter:

> import Text.Highlighting.Kate
> import Text.Blaze.Renderer.String
>
> main = do
>   code <- getContents
>   putStrLn $ renderHtml
>            $ formatAsHtml [OptNumberLines] "ruby"
>            $ highlightAs "ruby" code

-}

module Text.Highlighting.Kate ( highlightAs
                              , languages
                              , languagesByExtension
                              , languagesByFilename
                              , formatAsHtml
                              , formatAsLaTeX
                              , FormatOption (..)
                              , defaultHighlightingCss
                              , defaultLaTeXMacros
                              , highlightingCss
                              , highlightingLaTeXMacros
                              , SourceLine
                              , Token
                              , TokenType (..)
                              , TokenStyle (..)
                              , Color (..)
                              , Style (..)
                              , highlightingKateVersion
                              , pygments
                              , espresso
                              , tango
                              , kate
                              ) where
import Text.Highlighting.Kate.Format
import Text.Highlighting.Kate.Styles
import Text.Highlighting.Kate.Syntax
import Text.Highlighting.Kate.Definitions
import Data.Version (showVersion)
import Paths_highlighting_kate (version)

highlightingKateVersion = showVersion version
