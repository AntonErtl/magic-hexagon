\ constraint satisfaction problem semi-general stuff

\ failure on a branch of the search tree is indicated by an exception

"no (more) solutions" exception constant failure

\ value trail stack (records original value of changed cells)

[undefined] trail-elements [if] 10000 constant trail-elements [then]

trail-elements 2* cells allocate throw constant trail-stack
variable tsp trail-stack tsp !

: !bt ( x addr -- )
    \ like !, but records the old value on the trail stack
    dup @ over ( x addr old-x addr )
    tsp @ 2 cells + dup tsp ! 2! ( x addr )
    ! ;

: undo ( addr -- )
    \ undo everything on the trail stack above addr, starting from the top
    tsp @ 2 cells - over 2 cells - u-do
        i 2@ !
    2 cells -loop
    tsp ! ;

\ linked list of constraints

0
field: list-next
field: list-constraint \ xt of constraint
constant list-size

: instconstraints {: u var list -- :}
    list begin {: l :}
        l while
            u var l list-constraint @ execute
            l list-next @
    repeat ;

: insert-constraint {: xt listp -- :}
    \ insert xt at in the list pointed to by listp
    list-size allocate throw {: l :}
    listp @ l list-next !
    xt l list-constraint !
    l listp ! ;

\ variable in a constraint satisfaction problem
0
field: var-val  \ value 0-63 if instantiated, negative if not
field: var-bits \ potential values
field: var-wheninst \ linked list of constraints woken up when instantiated
constant var-size

: domain {: u1 u2 -- :}
    \ generate a constraint variable name ( -- var )
    \ with potential values [u1,u2]
    create here {: var :} var-size allot
    -1 var var-val !
    1 u2 1+ lshift 1- 1 u1 lshift 1- xor var var-bits !
    0 var var-wheninst ! ;

: !var {: u var -- :}
    \ instantiate var to u; throws iff var cannot be instantiated to u
    \ (not in the remaining values, or a constraint is not
    \ satisfiable)
    assert( u 64 u< )
    var var-val @ dup 0>= swap u <> and failure and throw
    var var-bits @ 1 u lshift and 0= failure and throw
    u var var-val !bt
    u var var var-wheninst @ instconstraints ;

: constraint! ( xt var -- )
    var-wheninst insert-constraint ;

\ labeling support

: label {: var xt -- :}
    \ try out the first possible value for var; on CATCHing FAILURE,
    \ try the next, and so on; when no value is left, throw FAILURE.
    var var-val @ 0< if
        var var-bits @ 64 0 do ( x )
            dup 1 and if ( x )
                tsp @ xt i var [: !var execute ;] catch >r 2drop drop undo
                r@ failure <> r> and throw then
            1 rshift
        loop
        drop failure throw
    then ;

\ some constraints:

: array-constraint! {: xt addr u -- :}
    \ make xt a wheninst constraint action for all variables in addr u
    u 0 +do
        xt addr i th constraint!
    loop ;

\ alldifferent

: alldifferent-c {: u var addr1 u1 -- :}
    \ in the variables in addr1 u1, var has been instantiated to u
    addr1 u1 th addr1 u+do
        i @ {: vari :}
        vari var <> if
            vari var-val @ dup u = failure and throw ( val )
            0< if ( ) \ not yet instantiated
                1 u lshift vari var-bits @ 2dup and 0= failure and throw
                xor dup pow2? if ( x ) \ only one bit set
                    ctz vari !var
                else
                    vari var-bits !bt
                then ( )
            then
        then
    1 cells +loop ;    

: alldifferent ( addr u -- )
    2dup [d:d alldifferent-c ;]
    rot rot array-constraint! ;

\ ...sum

: arraysum-c {: u var addr1 u1 usum -- :}
    0 0 u1 0 +do ( usum1 var1 )
        addr1 i th @ {: vari :}
        vari var-val @ dup 0< if ( usum1 var1 vali )
            drop if ( usum1 ) \ constraint has >1 free variables, do nothing
                drop unloop exit then
            vari
        else
            rot + swap
        then
    loop
    usum rot - swap !var ;

: arraysum ( addr u usum -- )
    >r 2dup r> [{: addr u usum :}d addr u usum arraysum-c ;]
    rot rot array-constraint! ;

: 3sum ( v1 v2 v3 usum -- )
    align here 2>r , , , 2r> 3 rot arraysum ;

: 4sum ( v1 v2 v3 v4 usum -- )
    align here 2>r , , , , 2r> 4 rot arraysum ;

: 5sum ( v1 v2 v3 v4 v5 usum -- )
    align here 2>r , , , , , 2r> 5 rot arraysum ;

\ Magic Hexagon specific stuff

\ Newsgroups: comp.lang.forth
\ Date: Sun, 12 Feb 2023 02:43:44 -0800 (PST)
\ Message-ID: <7e7a9acd-81f6-4022-b12a-753f3b418308n@googlegroups.com>
\ Subject: Magic Hexagon
\ From: "minf...@arcor.de" <minforth@arcor.de>

\ Another while-away-your-afternoon-teatime puzzle:

\ Place the integers 1..19 in the following Magic Hexagon of rank 3 
\ __A_B_C__
\ _D_E_F_G_
\ H_I_J_K_L
\ _M_N_O_P_
\ __Q_R_S__
\ so that the sum of all numbers in a straight line (horizontal and diagonal)
\ is equal to 38.
\ [...]


1 19 domain A
1 19 domain B
1 19 domain C
1 19 domain D
1 19 domain E
1 19 domain F
1 19 domain G
1 19 domain H
1 19 domain I
1 19 domain J
1 19 domain K
1 19 domain L
1 19 domain M
1 19 domain N
1 19 domain O
1 19 domain P
1 19 domain Q
1 19 domain R
1 19 domain S

create vars
A , B , C , D , E , F , G , H , I , J , K , L , M , N , O , P , Q , R , S ,
vars 19 alldifferent

A B C 38 3sum
Q R S 38 3sum
A D H 38 3sum
L P S 38 3sum
C G L 38 3sum
H M Q 38 3sum
D E F G 38 4sum
M N O P 38 4sum
B E I M 38 4sum
G K O R 38 4sum
B F K P 38 4sum
D I N R 38 4sum
H I J K L 38 5sum
C F H N Q 38 5sum
A E J O S 38 5sum

: .var ( var -- )
    var-val @ 4 .r ;

: printsolution ( -- )
    cr ."     " A .var B .var C .var
    cr ."   " D .var E .var F .var G .var
    cr      H .var I .var J .var K .var L .var
    cr ."   " M .var N .var O .var P .var
    cr ."     " Q .var R .var S .var cr ;

: labeling ( -- )
    \ start with the corner variables in 3sums
    \ B G P R N D follow from the 3sum constraints
    \ then label one other 4sum variable: E
    \ I N O K F J follow from the constraints
    A
    [: C
        [: L
            [: S
                [: Q
                    [: H
                        [: E
                            [: printsolution failure throw ;]
                            label ;]
                        label ;]
                    label ;]
                label ;]
            label ;]
        label ;]
    label ;

\ : test ( -- )
\    A [: A .var failure throw ;] label ;

