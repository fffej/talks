% Types and Tests
% Jeff Foster
% Lightning talk for RedGate

# Types and Tests!

A type system is a syntactic method for proving the absence of certain program behaviors by classifying phrases according to the kinds of values they compute.  (Benjamin Pierce, Types and Programming Languages, MIT Press, 2002)

A test is a strategy for classifying program behaviour (but note "Program testing can be used to show the presence of bugs, but never to show their absence!" (Dijkstra, 1970))

You can think of a type as a compile-time test for some properties of your program

Strong type systems help move more invariants to compile time safety

# Making best use of the type system 

Make the type signature document the function

Write total functions

Avoid side-effects

Avoid type casting

Use the language features (e.g. polymorphism instead of enum's, type providers in F# 3.0)

# Property Based Testing

Once you have total functions, think in terms of invariants of the result

Use an adversarial opponent to disprove your theories

Opponent generates arbitrary data to attempt to falsify your invariants

Allows easy model based testing (e.g. invariant is the result of the Oracle implementation)

# Example of property based testing (Haskell)

Write predicates expressing the invariant.  QuickCheck generates data to try to falsify

~~~~ {.haskell}
-- |Reversing a list twice returns the original list
prop_RevIdentity :: [Int] -> Bool
prop_RevIdentity xs = xs == (reverse . reverse) xs
~~~~

Now try to get the opponent to beat it

~~~~ {.haskell}
*QuickCheckExample> quickCheck prop_RevIdentity 
+++ OK, passed 100 tests.
~~~~

Woot, that property holds.

# Finding bugs with property based testing

Let's try a very slightly more complicated example.  Write a integer comparison function using only subtraction.

~~~~ {.haskell}
-- What could possibly go wrong?
compareIntsBadly :: Int32 -> Int32 -> Ordering
compareIntsBadly a b
  | subs < 0  = LT
  | subs == 0 = EQ
  | otherwise = GT
    where
      subs = a - b
~~~~

We can assert that this comparison operator works the same as the default one:

~~~~ {.haskell}
prop_MyCompareFunctionWorks :: Int32 -> Int32 -> Bool
prop_MyCompareFunctionWorks a b = (compare a b) == (compareIntsBadly a b)

*** Failed! Falsifiable (after 82 tests and 17 shrinks):     
-853137079
1294346570
~~~~

D'oh.  Underflow.  The "shrinks" are QuickCheck reducing the failing test case down to the smallest example it could find.

# Dependent Types example

Dependent types allow types to depend on a value.  Example languages include ATS, Coq and Isabelle

Allow you to take the invariants in your property-based testing and verify them at compile-time

Define exactly what what the Fibonacci sequence is 

~~~~ {.ats}
dataprop FIB (int, int) =
  | FIB_bas_0 (0, 0) // Fib 0 = 0
  | FIB_bas_1 (1, 1) // Fib 1 = 1
  | {i:nat} {r0,r1:int}
    // fib i + 2 = (fib i) + fib (i + 1)
    FIB_ind (i+2, r0+r1) of (FIB (i, r0), FIB (i+1, r1))
~~~~ 

The type FIB now encodes the properties of the Fibonacci sequence

Any implementation of this is now compile-time checked to implement these properties.  

A bug in the implementation manifests itself at compile-time, not run-time

# Summary

Types and tests are very closely related

Thinking about the type system as you write code can push more invariants to compile-time safety

Use tools that are available (Pex and Code Contracts look interesting for C#, I would be interested to hear any experiences with them)

Property based testing is a neat testing paradigm (anyone want to work on a C# version?)
