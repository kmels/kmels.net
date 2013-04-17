--kmels.net
{-# LANGUAGE OverloadedStrings, FlexibleInstances #-}
module Main where

import Prelude hiding (id)
import Control.Category (id)
import Control.Arrow ((>>>), (&&&), (***), (+++), (|||), arr)
import Data.Monoid (mempty, mconcat, mappend)
import Data.Either (rights)
import Data.Maybe
import Data.Time
import Data.Time.Format

import Control.Monad.IO.Class
import Hakyll
--import Text.Pandoc (HTMLMathMethod(..),WriterOptions(..), defaultWriterOptions)
--import Text.Pandoc.Shared (ObfuscationMethod(..))
import Text.Pandoc.Options(WriterOptions(..))

main :: IO ()
main = hakyll $ do
    -- Compress CSS
    match "css/*" $ route idRoute >> compile compressCssCompiler        
      
    -- Copy static files
    match ("images/**" .||. "favicon.ico" .||. "robots.txt") $ do
       route   idRoute
       compile copyFileCompiler
       
    -- match "files/**" $ do
    --   route idRoute
    --   compile copyFileCompiler 

    tags <- buildTags "posts/*" (fromCapture "tags/*.html")
        
    -- Render each project page
    match "projects/*" $ do
      route $ setExtension ".html"
      compile $ pandocCompiler
        >>= loadAndApplyTemplate "templates/project.html" (postCtx tags)
        >>= loadAndApplyTemplate  "templates/default.html" defaultContext
        >>= relativizeUrls
    
    match "projects/**" $ do
      route   idRoute
      compile copyFileCompiler
    
    match "projects/**" $ do
      route   idRoute
      compile copyFileCompiler
      
    -- Render posts
    match "posts/**" $ do
        route   $ setExtension ".html"
        compile $ do 
          pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" (postCtx tags)
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- Posts list
    create ["posts.html"] $ do
      route idRoute
      compile $ do
        list <- postList tags "posts/**" recentFirst
        makeItem list
          >>= loadAndApplyTemplate "templates/posts.html"
          (constField "title" "Posts!" `mappend`
           constField "posts" "ASDF" `mappend`
           defaultContext)
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls
                
    -- Index
    match "index.markdown" $ do
      route $ setExtension ".html"
      compile $ do
        pandocCompiler
        >>= loadAndApplyTemplate "templates/default.html" (indexCtx "list" tags)
        >>= relativizeUrls
        
    -- Read templates
    match "templates/*" $ compile templateCompiler
    
    -- Static pages
    match (fromList static_pages) $ do
      route   $ setExtension "html"
      compile $ pandocCompiler
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

  where
--    static_pages :: [String]
    static_pages = ["about.markdown","dashboard.markdown","contact.markdown","404.markdown"]
    --   renderTagList' :: Compiler (Tags String) String
    --   renderTagList' = renderTagList tagIdentifier

    --   tagIdentifier :: String -> Identifier (Page String)
    --   tagIdentifier = fromCapture "tags/*"
      
    
    
-- makeTagList :: String
--             -> [Page String]
--             -> Compiler () (Page String)
-- makeTagList tag posts =
--     constA posts
--         >>> pageListCompiler recentFirst "templates/postitem.html"
--         >>> arr (copyBodyToField "posts" . fromBody)
--         >>> arr (setField "title" ("Posts tagged " ++ tag))
--         >>> applyTemplateCompiler "templates/posts.html"
--         >>> applyTemplateCompiler "templates/default.html"
--         >>> relativizeUrlsCompiler
        
-- | Auxiliary compiler: generate a post list from a list of given posts, and
-- add it to the current page under @$posts@
--
-- addPostList :: Compiler (Item String, [Item String]) (Item String)
-- addPostList = setFieldA "posts" $
--     arr (reverse . chronological)
--         >>> require "templates/postitem.html" (\p t -> map (applyTemplate t) p)
--         >>> arr mconcat
--         >>> arr pageBody

-- from https://github.com/beastaugh/extralogical.net/blob/d96a3ecd467facc68db0c8eada784313968b6a45/site.hs#L132-142
-- | Read a page, add default fields, substitute fields and render with Pandoc.
--
--articleCompiler :: Compiler Resource (Page String)
--articleCompiler = pageCompilerWith defaultHakyllParserState articleWriterOptions

-- | Pandoc writer options for articles on Extralogical.
--
-- articleWriterOptions :: WriterOptions
-- articleWriterOptions = defaultWriterOptions
--     { writerEmailObfuscation = NoObfuscation
--     , writerHTMLMathMethod   = MathML Nothing
--     , writerLiterateHaskell  = True
--     }

postList :: Tags -> Pattern -> ([Item String] -> Compiler [Item String])
         -> Compiler String
postList tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/postitem.html"
    posts <- preprocess' =<< loadAll pattern
    applyTemplateList postItemTpl (postCtx tags) posts
    
feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle = "kmels.net - latest content"
    , feedDescription = "Articles listed in kmels.net"
    , feedAuthorName = "Carlos López-Camey"
    , feedAuthorEmail = "c.lopez@kmels.net"
    , feedRoot = "http://kmels.net"
    }
    
----------------------------------------
--               Contexts
----------------------------------------
feedCtx :: Context String
feedCtx = mconcat [ bodyField "description"
                 , defaultContext
                 ]

postCtx :: Tags -> Context String
postCtx tags = mconcat
    [ --modificationTimeField "mtime" "%U"
--      dateField "date" "%B %e, %Y"
     tagsField "tags" tags
    , defaultContext
    ]    
    
indexCtx :: String -> Tags -> Context String 
indexCtx list tags = constField "posts" list `mappend`
                field "tags" (\_ -> renderTagList tags) `mappend`
                defaultContext
----------------------------------------
--               Pandoc
----------------------------------------

--lhsExtension :: Extension
--lhsExtension = Ext_literate_haskell

