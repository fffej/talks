module QuickCheckExample where

import Data.Maybe
import Data.Char
import Control.Monad
import Test.QuickCheck

import Data.List (sort,sortBy)
import Data.Map (Map, elems, empty, insertWith)
import Data.Int (Int32)

-- |Reversing a list twice returns the original list
prop_ReverseIdentity :: [Int] -> Bool
prop_ReverseIdentity list = list == (reverse . reverse) list

-- |Subtracting a couple of integers is a good way to compare them right?
compareIntsBadly :: Int32 -> Int32 -> Ordering
compareIntsBadly a b
  | subs < 0  = LT
  | subs == 0 = EQ
  | otherwise = GT
    where
      subs = a - b
                
prop_MyCompareFunctionWorks :: Int32 -> Int32 -> Bool
prop_MyCompareFunctionWorks a b = (compare a b) == (compareIntsBadly a b)



