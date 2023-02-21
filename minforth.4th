\ Newsgroups: comp.lang.forth
\ Date: Sun, 19 Feb 2023 12:18:10 -0800 (PST)
\ Message-ID: <41079f81-6d7b-4d2e-97e1-94ed0f358a94n@googlegroups.com>
\ Subject: Re: Magic Hexagon
\ From: "minf...@arcor.de" <minforth@arcor.de>

\ minf...@arcor.de schrieb am Sonntag, 12. Februar 2023 um 11:43:46 UTC+1:
\ > Another while-away-your-afternoon-teatime puzzle: 
\ > 
\ > Place the integers 1..19 in the following Magic Hexagon of rank 3 
\ > __A_B_C__ 
\ > _D_E_F_G_ 
\ > H_I_J_K_L 
\ > _M_N_O_P_ 
\ > __Q_R_S__ 
\ > so that the sum of all numbers in a straight line (horizontal and diagonal) 
\ > is equal to 38. 
\ > 
\ > It is said that this puzzle is almost impossibly hard to solve manually. 
\ > But with the techniques developed in the SEND+MORE=MONEY thread 
\ > it should be easy in Forth. 
\ > 
\ > One solution is 
\ > __3_17_18__ 
\ > _19_7_1_11_ 
\ > 16_2_5_6_9 
\ > _12_4_8_14_ 
\ > __10_13_15__

\ Here's the obvious SOLUTION IMPOSSIBLE  :o)

DECIMAL

CREATE HXG
1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 ,
11 , 12 , 13 , 14 , 15 , 16 , 17 , 18 , 19 ,

: H@ cells hxg + @ ;

: EXCHANGE  ( i j -- )  
  cells hxg + swap cells hxg + \ aj ai
  dup @ >r swap dup @  \ ai aj fj r: fi
  rot ! r> swap ! ;

: A 0 h@ ;  : B 1 h@ ;  : C 2 h@ ;
: D 3 h@ ;  : E 4 h@ ;  : F 5 h@ ;  : G 6 h@ ;  
: H 7 h@ ;  : _I 8 h@ ;  : _J 9 h@ ;  : K 10 h@ ;  : L 11 h@ ;
: M 12 h@ ;  : N 13 h@ ;  : O 14 h@ ;  : P 15 h@ ; 
: Q 16 h@ ;  : R 17 h@ ;  : S 18 h@ ; 

: CHECK-CONSTRAINTS
  false
  \ rows:
  A B C + + 38 <> IF EXIT THEN 
  D E F G + + + 38 <> IF EXIT THEN 
  H _I _J K L + + + + 38 <> IF EXIT THEN 
  M N O P + + + 38 <> IF EXIT THEN 
  Q R S + + 38 <> IF EXIT THEN 
  \ rot1:
  C G L + + 38 <> IF EXIT THEN 
  B F K P + + + 38 <> IF EXIT THEN 
  A E _J O S + + + + 38 <> IF EXIT THEN 
  D _I N R + + + 38 <> IF EXIT THEN 
  H M Q + + 38 <> IF EXIT THEN 
  \ rot2:
  A D H + + 38 <> IF EXIT THEN 
  B E _I M + + + 38 <> IF EXIT THEN 
  C F _J N Q + + + + 38 <> IF EXIT THEN 
  G K O R + + + 38 <> IF EXIT THEN 
  L P S + + 38 <> IF EXIT THEN 
  drop true ;

: SHOW-HEXAGON
  19 0 DO i h@ . LOOP ;

VARIABLE CT 0 ct !

: USE-PERM
  \ cr ct @ . space 1 ct +! show-hexagon  
  check-constraints IF show-hexagon ABORT THEN ;

\ Heap's algorithm code thanks to Gerry Jackson
: PERMUTE  ( n -- ) \ n assumed > 0
  1- ?dup 0= IF use-perm EXIT THEN
  dup 0 DO dup recurse
    dup over 1 and negate i and exchange
  LOOP recurse ;

: MAGIC  ( -- ) \ check constraints
  19 permute ;

MAGIC
