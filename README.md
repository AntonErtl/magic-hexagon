# Magic Hexagon solvers in Forth

This project contains a number of solutions for the magic hexagon
puzzle in Forth.  The puzzle has been described by minforth as
follows:

```
Place the integers 1..19 in the following Magic Hexagon of rank 3 
__A_B_C__
_D_E_F_G_
H_I_J_K_L
_M_N_O_P_
__Q_R_S__
so that the sum of all numbers in a straight line (horizontal and diagonal)
is equal to 38.
```

## Files

## `postings.txt`

Some postings by Anton Ertl about his programs and about performance
comparisons of his and Ahmed Melahi's programs.

## `ertl-simple.4th`

A program that attacks the problem directly, setting each variable to
a possible value, and then explicitly checking the constraints for
which all variables are now set.  The constraints eliminate rotated
and mirrored solutions, leaving only one solution, but the program
explores the whole search space to prove that the solution is unique.
There is code that terminates after finding one solution, but it is
commented out.

## `ertl-simple-all.4th`

A variant of `ertl-simple.4th` where the constraints that suppress
rotated and mirrored solutions are commented out, resulting in twelve
solutions.

## `magichex.4th`

A program by Anton Ertl that first builds a semi-general framework for
dealing with constraint satisfaction problems, and then uses it to
solve the problem.  Does not suppress rotated and mirrored solutions,
and explores the whole search space.

The last several (mostly relatively hard) bug fixes before the program
worked each have their own commit (but they are polluted by debugging
scaffolding).

## `melahi.4th`

A program by Ahmed Melahi.  Stops after the first solution.

## `melahi2.4th`

An improved program by Ahmed Melahi.  Stops after the first solution,
but you can comment that part out.  Does not contain code for
suppressing rotated and mirrored solutions.

## minforth.4th

A program by minforth that first generates a permutation before
testing any part of it.  Marcel Hendrix estimated that this program
takes 120000h to find a solution.
