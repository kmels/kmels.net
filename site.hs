--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}
import Data.Monoid ((<>),mappend,mconcat)
import Hakyll

--------------------------------------------------------------------------------
import Control.Monad(liftM)
import Control.Monad.IO.Class
import Data.List(sortBy)
import Data.Ord(comparing)
import System.Locale
import Data.Map (lookup)
import Control.Applicative ((<$>))

--------------------------------------------------------------------------------
import Hakyll.Core.Metadata(getMetadataField')
--------------------------------------------------------------------------------
import Text.Pandoc (WriterOptions (..), HTMLMathMethod (MathJax))
--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match ("images/**" .||. "favicon.ico" .||. "robots.txt") $ do
      route   idRoute      
      compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.markdown", "dashboard.markdown","contact.markdown","404.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls
            
    tags <- buildTags "posts/**" (fromCapture "tags/*.html")

    --  -- Render posts
    -- match "posts/*" $ do
    --     route $ setExtension ".html"
    --     compile $ do
    --         pandocCompilerWith defaultHakyllReaderOptions pandocOptions
    --         >>= saveSnapshot "content" -- ^ For RSS
    --         >>= loadAndApplyTemplate "templates/post.html"
    --                 (postCtx tags <> defaultContext)
    --         >>= finish "Blog"
            
    match "posts/**" $ do
        route $ setExtension "html"
        compile $ 
          pandocCompilerWith defaultHakyllReaderOptions pandocOptions
            >>= loadAndApplyTemplate "templates/post.html"    (postCtx tags)
            >>= loadAndApplyTemplate "templates/default.html" (postCtx tags)
            >>= relativizeUrls    
    
    -- Render posts page
    create ["posts.html"] $ do
        route idRoute
        compile $ postPage tags "All Posts" "posts/**"
        
    -- create ["posts.html"] $ do
    --     route idRoute
    --     compile $ do
    --         let archiveCtx =
    --                 field "posts" (\_ -> postList byDateField) `mappend`
    --                 constField "title" "All posts"             `mappend`
    --                 defaultContext

    --         makeItem ""
    --             >>= loadAndApplyTemplate "templates/posts.html" archiveCtx
    --             >>= loadAndApplyTemplate "templates/default.html" archiveCtx
    --             >>= relativizeUrls


    match "index.markdown" $ do
        route $ setExtension ".html"
        compile $ do                    
          pandocCompiler
          >>= loadAndApplyTemplate "templates/default.html" indexCtx
          >>= relativizeUrls
          
    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
indexCtx :: Context String 
indexCtx = defaultContext
                     
--------------------------------------------------------------------------------
postCtx :: Tags -> Context String
postCtx tags = mconcat
    [ dateField "date" "%B %e, %Y"
    , tagsField "tags" tags
    , defaultContext
    ]

--------------------------------------------------------------------------------
-- Stolen from brianshourd.com
postPage :: Tags -> String -> Pattern -> Compiler (Item String)
postPage tags title pattern = do
    list <- postList tags pattern byDateField
    makeItem ""
        >>= loadAndApplyTemplate "templates/posts.html"
                (constField "posts" list <> constField "title" title <>
                    defaultContext)
        >>= finish title
        
-- postList' :: Tags -> Pattern -> ([Item String] -> [Item String]) -> Compiler String
-- postList' tags pattern preprocess' = do
--     postItemTpl <- loadBody "templates/postitem.html"
--     posts <- preprocess' <$> loadAll pattern
--     applyTemplateList postItemTpl (postCtx tags) posts
    
-- ===================
-- Auxiliary Functions
-- ===================
postList :: Tags -> Pattern -> ([Item String] -> [Item String]) -> Compiler String
postList tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/postitem.html"
    posts <- preprocess' <$> loadAll pattern
    applyTemplateList postItemTpl (postCtx tags) posts
    
-- postList :: Tags -> Pattern -> ([Item String] -> [Item String]) -> Compiler String
-- postList tags pattern reorder = do
--     posts  <- reorder <$> loadAll pattern 
--     --sorted_posts <- sort' posts
--     itemTpl <- loadBody "templates/postitem.html"
--     applyTemplateList itemTpl postCtx posts

--------------------------------------------------------------------------------
-- | Sort pages chronologically. Uses the same method as 'dateField' for
-- extracting the date.
byDateField :: [Item a] -> [Item a]
byDateField = id

--------------------------------------------------------------------------------
-- Stolen from brianshourd.com
finish :: String -> Item String -> Compiler (Item String)
finish title item = loadAndApplyTemplate
        "templates/default.html" (topCtx title `mappend` defaultContext) item
    >>= relativizeUrls

--------------------------------------------------------------------------------
-- Stolen from brianshourd.com
topCtx :: String -> Context String
topCtx title = mconcat
    [ field "mathjax" mathjax
    , constField "siteTitle" title
    ]
    
--------------------------------------------------------------------------------
-- Stolen from brianshourd.com
mathjax :: Item String -> Compiler String
mathjax item = do
    metadata <- getMetadata (itemIdentifier item)
    return $ case Data.Map.lookup "math" metadata of
        Just "true" -> "<script type=\"text/javascript\" src=\"http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\" />"
        otherwise -> ""

--------------------------------------------------------------------------------
pandocOptions :: WriterOptions
pandocOptions = defaultHakyllWriterOptions
    { writerHTMLMathMethod = MathJax ""
    }
