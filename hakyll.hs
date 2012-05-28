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

import Hakyll

import Text.Pandoc (HTMLMathMethod(..),WriterOptions(..), defaultWriterOptions)
import Text.Pandoc.Shared (ObfuscationMethod(..))

main :: IO ()
main = hakyll $ do
    -- Compress CSS
    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler        
      
    -- Copy static files, list of glob's doesn't work now, leaving several blocks
    match "robots.txt" $ do
        route   idRoute
    	compile copyFileCompiler
    
    match "images/*" $ do
      route   idRoute
      compile copyFileCompiler
      
    match "files/*" $ do
      route   idRoute
      compile copyFileCompiler
      
    -- Render posts
    match "posts/*/*" $ do
        route   $ setExtension ".html"
        compile $ articleCompiler
            >>> applyTemplateCompiler "templates/post.html"
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler

    -- Render posts list
    match "posts.html" $ route idRoute
    create "posts.html" $ constA mempty
        >>> arr (setField "title" "All posts")
        >>> requireAllA "posts/*/*" addPostList
        >>> renderTagsField "prettytags" (fromCapture "tags/*")
        >>> applyTemplateCompiler "templates/posts.html"
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler 

    -- Index
    match "index.markdown" $ do
      route $ setExtension ".html"
      compile $ articleCompiler
       -- >>> arr (setField "title" "All posts")
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

    -- Tags
    create "tags" $
        requireAll "posts/*" (\_ ps -> readTags ps :: Tags String)

    -- Add a tag list compiler for every tag
    match "tags/*" $ route $ setExtension ".html"
    metaCompile $ require_ "tags"
        >>> arr tagsMap
        >>> arr (map (\(t, p) -> (tagIdentifier t, makeTagList t p)))
        
    -- Read templates
    match "templates/*" $ compile templateCompiler

    -- Render feed
    match  "feed.xml" $ route idRoute
    create "feed.xml" $
        requireAll_ "posts/*" >>> renderRss mainFeed
    
    -- Static pages
    match (list ["about.markdown","contact.markdown","404.markdown"]) $ do
    route   $ setExtension "html"
    compile $ pageCompiler
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

    where       
      renderTagList' :: Compiler (Tags String) String
      renderTagList' = renderTagList tagIdentifier

      tagIdentifier :: String -> Identifier (Page String)
      tagIdentifier = fromCapture "tags/*"
      
    
    
makeTagList :: String
            -> [Page String]
            -> Compiler () (Page String)
makeTagList tag posts =
    constA posts
        >>> pageListCompiler recentFirst "templates/postitem.html"
        >>> arr (copyBodyToField "posts" . fromBody)
        >>> arr (setField "title" ("Posts tagged " ++ tag))
        >>> applyTemplateCompiler "templates/posts.html"
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler
        
-- | Auxiliary compiler: generate a post list from a list of given posts, and
-- add it to the current page under @$posts@
--
addPostList :: Compiler (Page String, [Page String]) (Page String)
addPostList = setFieldA "posts" $
    arr (reverse . chronological)
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

