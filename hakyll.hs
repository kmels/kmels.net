--kmels.net
{-# LANGUAGE OverloadedStrings, FlexibleInstances #-}
module Main where

import Prelude hiding (id)
import Control.Category (id)
import Control.Arrow ((>>>), (&&&), (***), (+++), (|||), arr)
import Data.Monoid (mempty, mconcat)
import Data.Either (rights)
import Data.Maybe
import Data.Time
import Data.Time.Format
import Locale

import Hakyll

import Text.Pandoc (HTMLMathMethod(..),WriterOptions(..), defaultWriterOptions)
import Text.Pandoc.Shared (ObfuscationMethod(..))

main :: IO ()
main = hakyll $ do
    -- Compress CSS
    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler
	
    -- Images
    match "images/*" $ do
        route   idRoute
    	compile copyFileCompiler

    -- Render posts
    match "posts/*" $ do
        route   $ setExtension ".html"
        compile $ articleCompiler
            >>> applyTemplateCompiler "templates/post.html"
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler

    -- Render posts list
    match "posts.html" $ route idRoute
    create "posts.html" $ constA mempty
        >>> arr (setField "title" "All posts")
        >>> requireAllA "posts/*" addPostList
        >>> applyTemplateCompiler "templates/posts.html"
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

    -- Index
    match "index.html" $ route idRoute
    create "index.html" $ constA mempty
        >>> arr (setField "title" "Personal Home Page of Carlos Lopez-Camey")
        >>> requireAllA "posts/*" (id *** arr (take 5 . reverse . sortByBaseName) >>> addPostList)
        >>> applyTemplateCompiler "templates/index.html"
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

    -- Read templates
    match "templates/*" $ compile templateCompiler

    -- Render feed
    match  "feed.xml" $ route idRoute
    create "feed.xml" $
        requireAll_ "posts/*" >>> renderRss mainFeed
    
    -- Static pages
    match (list ["about.markdown","contact.markdown"]) $ do
    route   $ setExtension "html"
    compile $ pageCompiler
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

-- | Auxiliary compiler: generate a post list from a list of given posts, and
-- add it to the current page under @$posts@
--
addPostList :: Compiler (Page String, [Page String]) (Page String)
addPostList = setFieldA "posts" $
    arr (reverse . sortByBaseName)
        >>> require "templates/postitem.html" (\p t -> map (applyTemplate t) p)
        >>> arr mconcat
        >>> arr pageBody

-- from https://github.com/beastaugh/extralogical.net/blob/d96a3ecd467facc68db0c8eada784313968b6a45/site.hs#L132-142
-- | Read a page, add default fields, substitute fields and render with Pandoc.
--
articleCompiler :: Compiler Resource (Page String)
articleCompiler = pageCompilerWith defaultHakyllParserState articleWriterOptions

-- | Pandoc writer options for articles on Extralogical.
--
articleWriterOptions :: WriterOptions
articleWriterOptions = defaultWriterOptions
    { writerEmailObfuscation = NoObfuscation
    , writerHTMLMathMethod   = MathML Nothing
    , writerLiterateHaskell  = True
    }

mainFeed = FeedConfiguration
    { feedRoot         = "http://kmels.net"
    , feedTitle       = "kmels posts"
    , feedDescription = "Articles from Carlos Lopez-Camey"
    , feedAuthorName  = "Carlos Lopez-Camey"
    }

