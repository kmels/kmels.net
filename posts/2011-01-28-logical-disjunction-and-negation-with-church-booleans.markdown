---
title: Logical disjunction and negation as combinators with Church Booleans
author: Carlos López
date: January 28, 2011
lang: en
---

Going through chapter 5 of [TAPL](http://www.cis.upenn.edu/~bcpierce/tapl/ "TAPL"), I found myself dealing, for the first time, with combinators in the lambda calculus, so I’ll try to practice what I learnt doing a small exercise.

Church Booleans
---

Following Church, we can encode two values in the lambda calculus $tru$ and $fls$ as follows:

 * $tru = \lambda t. λf. t$

 * $fls = \lambda t. \lambda f. f$

The test combinator
---

As an example, Pierce introduces the $test$ combinator whose behaviour is, if applied to terms $b,v$ and $w$, returns $v$ if $b$ is the value $tru$ and returns $w$ if $b$ is the value $fls$.

$test = \lambda l. \lambda m. \lambda n. l m n$

 * Example if the applied value of $b$ is $tru$:

    * $test$ $tru$ $v$ $w$
    
    * $\rightarrow (\lambda m. \lambda n.$ $tru$ $m$ $n)$ $v$ $w$

    * $\rightarrow (\lambda .n$ $tru$ $v$ $n)$ $w$

    * $\rightarrow tru$ $v$ $w$

    * $\rightarrow (\lambda t. \lambda f. \lambda t)$ $v$ $w$

    * $\rightarrow (\lambda f. v)$ $w$ $v$

 * If $b$‘s value is $fls$, we’d have got instead in step 4, the expression

    * $fls$ $v$ $w$ = $(\lambda t.$ $\lambda f.$ $f)$ $v$ $w$
    
    * $(\lambda f.$ $f)$ $w$

    * $\rightarrow w$

We can see that the $test$ combinator meets the specifications of the behaviour we wanted it to have. I got quite excited when I first read this, later I figured, it always reduces to the expression $b$ $v$ $w$, where the definition of $tru$ and $fls$ will do their job.

Now that we've got $test$, we can define the logical conjunction, as a function (or lambda expression):

 * $and = \lambda b. \lambda c.$ $b$ $c$ $fls$

If we apply the values $v$ and $w$, the expression reduces to $v$ $w$ $fls$, that is:

 * If $and$ is applied to values $tru$ and $w$, we get: $tru$ $w$ $fls  (\lambda t. \lambda f.$ $t)$ $w$ $fls$  $(\lambda f.$ $w)$ $fls$ $w$. So, if we apply the values $tru$ and $fls$, $and$ would be reduced to $fls$; if applied to values $tru$ and $tru$ then It’d be reduced to $tru$. 

 * If $and$ is applied to values $fls$ and $w$, we get: $fls$ $w$ $fls$ $ (\lambda t. \lambda f.$ $f)$ $w$ $fls$ $(\lambda f.$ $f)$ $fls$ $fls$. This way we would get $fls$ everytime the first argument value is $fls$.

The OR and NOT combinators
------

So, as an exercise I’ll try to encode the functionality of the logical OR and NOT; this is not anything new, it is an exercise from the book.

The $or$ behaviour is similar to that of the $and$: you apply two boolean values $v$ and $w$ to it, and returns $tru$ if at least one of them is $tru$; it returns $fls$ otherwise. So, we’d like a (reduced) expression that meets the following:

   * If we apply values $tru$ and $w$, the expression reduces to $tru$.

   * If we apply values $fls$ and $w$, the expression reduces to $w$.

So, we’d like the expression $or$ $v$ $w$ to be reduced to the expression $or$ $v$ $tru$ $w$ ; so having the bounded variable $v$ replaced by $tru$, yielding $tru$, and $w$ otherwise. That is, having $or = \lambda b. \lambda c. b$ $tru$ $c$, which is equivalent to

  * $or = \lambda b. \lambda c.$ $b$ $b$ $c$

Note that it reduces to the expression we want.

  * $or$ $v$ $w$

  * $\rightarrow (\lambda b. \lambda c.$ $b$ $tru$ $c)$ $v$ $w$

  * $\rightarrow (\lambda c.$ $v$ $tru$ $c)$ $w$.

  * $\rightarrow v$ $tru$ $c$.

The $not$ function has somehow different form: it has only one bounded variable. Note that we can use the function test to define it:

  * $not = test$ $b$ $fls$ $tru$

where the only bounded variable is $b$, written as a lambda expression:

  * $not = \lambda l. l$ $fls$ $tru$

Finally, checking $not$ $tru$ and $not$ $fls$, we have:

  * $not$ $tru$

  * $\rightarrow (\lambda . l fls$ $tru)$ $tru$

  * $\rightarrow tru$ $fls$ $tru$

  * $\rightarrow fls$

and

  * $not$ $fls$

  * $\rightarrow (\lambda . l$ $fls$ $tru)$ $fls$

  * $\rightarrow fls$ $fls$ $tru$
 
  * $\rightarrow tru$
 
[1] Pierce Benjamin, Types and Programming Languages
