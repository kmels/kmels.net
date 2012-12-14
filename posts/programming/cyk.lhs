---
title: CYK Algorithm in Haskell
author: Carlos López
date: Dec 10th, 2012
lang: en
tags: parsing,O(n^3),cyk,algorithm,dynamic programming
---

This page was generated from a literall haskell file. You can download it and run it yourself: [cyk.lhs](http://hub.darcs.net/kmels/haskell-gym/algorithms/cyk.lhs)

LICENSE
---
 Public domain

Description
----
This program solves the word problem using the [CYK algorithm](http://en.wikipedia.org/wiki/CYK_algorithm). It takes a grammar $G$ and a word $w$ as input and outputs a matrix $M$ from which it can be decided if $w \in L(G)$.

> import Data.List
> import Data.Maybe

Data Structures
----
A Symbol $S$ in a CNF context free grammar can be a either a non terminal, a terminal or the concatenation of two non terminal symbols. 

**Note**: The type system lets us build the concatenation of two terminals, such construct however is not allowed in a CNF grammar.

> data Symbol = T Char | NT String | C Symbol Symbol 
>             deriving Eq

 * The constructor T represents Terminal
 * The constructor NT represents a non terminal
 * The constructor C represents a concatenation of two symbols

> instance Show Symbol where
>   show (T c) = [c]
>   show (NT s) = s
>   show (C s s2) = show s ++ show s2

> type Production = (Symbol,Symbol) 
> type Grammar = ([Production],Symbol)

**Note**: Again, we can have a Grammar whose start symbol is not a non terminal, but that is not allowed.

Algorithm
----
   
> cyk :: String -> Grammar -> Bool
> cyk word g@(productions,startSymbol) = let
>   matrix = g `cykMatrix` word  
>   setOfSymbols = matrix !! i !! j
>   i = 0 -- position, the start of the string
>   j = length word -1  --length of the word 
>   in any (== startSymbol) setOfSymbols 

> type SymbolSet = [Symbol]
> type Cell = (Int,Int)
> type Matrix = [[SymbolSet]]

> cykMatrix :: Grammar -> String -> [[SymbolSet]]
> cykMatrix grammar word = let
>   productions = fst grammar
>   firstRow :: [SymbolSet]
>   firstRow = [productions `findT` w | w <- word]
>   symbolsIn :: Matrix -> Int -> Int -> SymbolSet
>   symbolsIn matrix row column = nonTerminals where 
>     cmbs :: [(Cell,Cell)]
>     cmbs = [((column,k),(column+k,row-k) )| k <- [1..row-1]]
>     getSymbolSetAt (c,r) = matrix !! (r-1) !! (c-1)
>     buildConcat :: (Cell,Cell) -> [Symbol] --all concatenations
>     buildConcat (cell1,cell2) = [C s1 s2 | 
>         s1 <- getSymbolSetAt cell1, 
>         s2 <- getSymbolSetAt cell2]
>     concatenations :: [Symbol] --possible concatenation symbols
>     concatenations = concatMap buildConcat cmbs
>     nonTerminals = catMaybes $ map (getNTSymbolFor grammar) concatenations
>   row :: Matrix -> Int -> Matrix
>   row m j = m ++ [[symbolsIn m j c | c <- [1 .. (length word) - j + 1]]]
>   in foldl row [firstRow] [2 .. length word] --j

Helper functions 
---

Given a production $A$ symbol $S$. This function returns true if and only if $S$ is of the form $A {\Rightarrow_G}^* S$ where $S = BC$

> isConcatenation :: Production -> Symbol -> Bool
> production@(NT a,C b c)  `isConcatenation` (C b' c') = b == b' && c == c'
> _ `isConcatenation` _ = False

Checks a list of productions and returns the non terminal symbol that matches the argument `production`

> getNTSymbolFor :: Grammar -> Symbol -> Maybe Symbol
> getNTSymbolFor g concat = (find (\production -> production `isConcatenation` concat) $ (productionsOfGrammar g)) >>= Just . leftSideOf

Given a list of productions and a symbol from an alphabet, this function returns a non terminal symbol that produces that terminal.

> findT :: [Production] -> Char -> [Symbol]
> prods `findT` c = let
>   prods' = filter (\p -> c `isTerminalIn` p) prods
>   in map leftSideOf prods'

> isTerminalIn :: Char -> Production -> Bool
> c `isTerminalIn` prod = snd prod == T c

Returns a non symbol

> leftSideOf :: Production -> Symbol
> leftSideOf = fst 

> rightSideOf :: Production -> Symbol
> rightSideOf = snd

Example grammars
---

A Grammar for the language of palyndromes with alphabet={a,b,c} encoded in Chomsky Normal Form.

> productionsOfGrammar :: Grammar -> [Production]
> productionsOfGrammar = fst

> palyndromes = (palyndromesP,pstartSymbol)
> pstartSymbol = NT "S"

After it should be type Production = Symbol -> Symbol?

> palyndromesP :: [Production]
> palyndromesP = [
>    (NT "S",(C (NT "P") (NT "A")))
>  , (NT "S",(C (NT "Q") (NT "B")))
>  , (NT "S",(C (NT "R") (NT "C")))
>  , (NT "S",T 'a')
>  , (NT "S",T 'b')
>  , (NT "S",T 'c')
>  , (NT "P",(C (NT "A") (NT "S")))
>  , (NT "Q",(C (NT "B") (NT "S")))
>  , (NT "R",(C (NT "C") (NT "S")))
>  , (NT "A",T 'a')
>  , (NT "B",T 'b')
>  , (NT "C",T 'c')
>   ]

> concatSymbols :: String -> String -> Symbol
> concatSymbols s1 s2 = C (NT s1) (NT s2)

> g' :: Grammar
> g' = ([
>          (NT "S", concatSymbols "P" "Z")
>       , (NT "P", concatSymbols "P" "Z")
>       , (NT "W", concatSymbols "A" "X")
>       , (NT "W", T 'a')
>       , (NT "W", T 'b')
>       , (NT "A", T 'a')
>       , (NT "B", T 'b')
>       , (NT "C", T 'c')
>       , (NT "X", concatSymbols "Q" "B")
>       , (NT "Q", concatSymbols "W" "W")
>       , (NT "Y", concatSymbols "B" "C")
>       , (NT "Y", concatSymbols "B" "Z")
>       , (NT "Z", concatSymbols "Y" "C")
>       ], NT "S")