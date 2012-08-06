dataprop FIB (int, int) =
  | FIB0 (0, 0)  // Type constructor for case fib 0 = 1
  | FIB1 (1, 1)  // Type constructor for case fib 1 = 1
    // Recursive case given fib n and fib (n + 1) then (fib n + 2) is (fib n + fib n +1)
  | {n:nat} {r0,r1:int} FIB2 (n+2, r0+r1) of (FIB (n, r0), FIB (n+1, r1))

fun fibats {n:nat}
  (n: int n): [r:int] (FIB (n, r) | int r) = let
  fun loop {i:nat | i <= n} {r0,r1:int} (
    pf0: FIB (i, r0), pf1: FIB (i+1, r1) | ni: int (n-i), r0: int r0, r1: int r1
  ) : [r:int] (FIB (n, r) | int r) =
    if ni > 0 then
     loop {i+1} (pf1, FIB2 (pf0, pf1) | ni - 1, r1, r0 + r1)
    else (pf0 | r0)
  // end of [loop]
in
  loop {0} (FIB0 (), FIB1 () | n, 0, 1)
end // end of [fibats]

implement main () = let
    val (_ | fib10) = fibats 10
    val (_ | fib20) = fibats 20
  in 
    printf("Fib 10 = %i\n", @(fib10));
    printf("Fib 20 = %i\n", @(fib20))
  end