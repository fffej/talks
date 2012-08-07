% Learning About Other Languages
% Jeff Foster
% 7th August 2011

# Why learn a different language?
- Sapir-Whorf Hypothesis - Language constrains thought
- "A language that doesn't affect the way you think about programming, is not worth knowing." - Alan J. Perlis, Epigrams in Programming

# Lisp's Macro System
- Homoiconicity
    - (+ 1 1) applies the function + to the numbers 1 and 1
    - (+ 1 1) is a list of three elements
- Syntax of Lisp is extensible, add new control structures yourself!

~~~~ {#mycode .lisp}
    (defmacro while (test &rest body)
        "Repeat body while test is true."
        (list* 'loop
            (list 'unless test '(return nil))
            body)) 
~~~~

- Can capture syntactic duplication
- Code-generation

# Haskell's Type System
- Haskell is a strongly typed language
    - If it compiles, it will not crash
    - Bugs at compile-time, not runtime!

- Strong types encode information properly (no documentation getting out of date)

~~~~ {#mycode .haskell}
    first :: (a,b) -> a -- Can only do one thing!
~~~~

~~~~ {#mycode .haskell}
    readFromFile :: Path -> IO String -- aha, touches the disk
~~~~    

- What can you tell me about this function?

~~~~ {#mycode .haskell}
    badly-named-func :: (a -> b) -> [a] -> [b] -- what do I do?
~~~~

# Clojure's STM Implementation
- Unchecked mutable state is the cause of a HUGE number of bugs
- Clojure only allow mutation within a synchronized region.  No locks required

<!-- example taken from http://sw1nn.com/sw1nn.com/blog/2012/04/11/clojure-stm-what-why-how/ -->

~~~~ {#mycode .clojure}
    (def account1 (ref 100))
    (def account2 (ref 0))
    
    (defn transfer 
        "Transfers money from one account to the other"
        [amount from to]
        (dosync
          (alter from - amount)
          (alter to + amount)))
~~~~

- `alter` has to take place within a transaction.  STM composes

~~~~ {#mycode .clojure}
    (def *all-accounts* (take 50000 
    	 (repeatedly #(ref (rand-int 100)))))
    (defn total
       "Sum all accounts"
       [accounts]
       (dosync 
           (reduce + (map deref accounts))))
~~~~

- If any references within the account change during the calculation, STM automatically retries

