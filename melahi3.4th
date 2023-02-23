\ Newsgroups: comp.lang.forth
\ Date: Wed, 22 Feb 2023 09:00:45 -0800 (PST)
\ Message-ID: <29ace813-b44e-4591-bbc0-9ddfb0e6f542n@googlegroups.com>
\ Subject: Re: Magic Hexagon
\ From: Ahmed MELAHI <ahmed.melahi@univ-bejaia.dz>

\ HI, thanks for testing
\ Here, The last version of the program, I removed superfluous consecutive unmarks and and marks that consumed time.
\ I tested it on my PC:  Intel(R) Celeron(R) CPU 3867U @ 1.80GHz   1.80 GHz, 12GB: 
\            - gforth-fast: 
\                    - 1 solution: about 2.3 ms (the same result if I use A<C,...)
\                    - 12 solutions (all): 70 ms
\            - gforth:
\                    - 1 solution: 5 ms
\                    - 12 solutions: 146 ms

\ The listing begins here:

\ Place the integers 1..19 in the following Magic Hexagon of rank 3
\ __A_B_C__
\ _D_E_F_G_
\ H_I_J_K_L
\ _M_N_O_P_
\ __Q_R_S__
\ so that the sum of all numbers in a straight line (horizontal and diagonal)
\ is equal to 38.

\ here begins the application

0 value vA
0 value vB
0 value vC 
0 value vD
0 value vE
0 value vF 
0 value vG
0 value vH
0 value vI 
0 value vJ
0 value vK
0 value vL 
0 value vM
0 value vN
0 value vO 
0 value vP
0 value vQ
0 value vR 
0 value vS

0 value nth_ABC
0 value nth_GL
0 value nth_PS
0 value nth_RQ
0 value nth_MH
0 value nth_EF

0 value vD_ok
0 value vK_ok
0 value vO_ok
0 value vN_ok
0 value vI_ok
0 value vJ_ok

0 value n_sol

create marked 20 allot
marked 20 erase

create solutions 20 20 * allot

create ABC 19 18 * 3 * allot
create GL  16      2 * allot
create PS  14      2 * allot
create RQ  12      2 * allot
create MH  10      2 * allot
create EF   7      2 * allot

: solve
    marked 20 erase
    0 to n_sol 
    0 to nth_ABC
    0 to nth_GL
    0 to nth_PS 
    0 to nth_RQ
    0 to nth_MH
    0 to nth_EF

    \ ABC    fill ABC
    20 1 
    do
      i to vA
      1 vA marked + c!
      20 1 
      do 
        i to vB
        vB marked + c@ 0= 
        if 
          1 vB marked + c!

          38 vA vB + - to vC
          vC marked + c@ 0=
          vC 0> and
          vC 20 < and
          if 
            vA 0 nth_ABC 3 * + ABC +  c!
            vB 1 nth_ABC 3 * + ABC +  c!
            vC 2 nth_ABC 3 * + ABC +  c!
            nth_ABC 1+ to nth_ABC
          then
        then
        0 vB marked + c!
      loop
      0 vA marked + c!
    loop

    \ begin search: cycling and filling
      marked 20 erase

    \ cycle through ABC
    nth_ABC 0 
    do
      0 to nth_GL
      0 i 3 * + ABC + c@ to vA
      1 i 3 * + ABC + c@ to vB
      2 i 3 * + ABC + c@ to vC
      
      1 vA marked + c!
      1 vB marked + c!
      1 vC marked + c!

      \ GL
      20 1 
      do
        i to vG
        vG marked + c@ 0=
        if 
          1 vG marked + c! 

          38 vC vG + - to vL
          vL marked + c@ 0=
          vL 0> and
          vL 20 < and
          if 
            vG 0 nth_GL 2 * + GL +  c!
            vL 1 nth_GL 2 * + GL +  c!
            nth_GL 1+ to nth_GL
          then
          0 vG marked + c!
        then
      loop

      \ cycle through GL     
      nth_GL 0 
      ?do
        0 to nth_PS
        0 i 2 * + GL + c@ to vG
        1 i 2 * + GL + c@ to vL
 
        1 vG marked + c!
        1 vL marked + c!

        \ PS
        20 1 
        do
          i to vP
          vP marked + c@ 0=
          if 
            1 vP marked + c!

            38 vL vP + - to vS
            vS marked + c@ 0=
            vS 0> and
            vS 20 < and
            if 
              vP 0 nth_PS 2 * + PS +  c!
              vS 1 nth_PS 2 * + PS +  c!
              nth_PS 1+ to nth_PS
            then
            0 vP marked + c! 
          then
        loop

        \ cycle through PS
        nth_PS 0 
        ?do
          0 to nth_RQ
          0 i 2 * + PS + c@ to vP 
          1 i 2 * + PS + c@ to vS

          1 vP marked + c!
          1 vS marked + c!

          \ RQ
          20 1 
          do
            i to vR
            vR marked + c@ 0=
            if 
              1 vR marked + c! 

              38 vS vR + - to vQ
              vQ marked + c@ 0=
              vQ 0> and
              vQ 20 < and
              if 
                vR 0 nth_RQ 2 * + RQ +  c!
                vQ 1 nth_RQ 2 * + RQ +  c!
                nth_RQ 1+ to nth_RQ
              then
              0 vR marked + c!
            then
          loop

          \ cycle through RQ
          nth_RQ 0 
          ?do
            0 to nth_MH
            0 i 2 * + RQ + c@ to vR
            1 i 2 * + RQ + c@ to vQ
            1 vR marked + c!
            1 vQ marked + c!

            \ MH
            20 1 
            do
              i to vM
              vM marked + c@ 0=
              if 
                1 vM marked + c!

                38 vQ vM + - to vH
                vH marked + c@ 0=
                vH 0> and
                vH 20 < and
                if 
                  vM 0 nth_MH 2 * + MH +  c! 
                  vH 1 nth_MH 2 * + MH +  c! 
                  nth_MH 1+ to nth_MH
                then
                0 vM marked + c! \ cr vM .
              then
            loop

            \ cycle through MH
            nth_MH 0 
            ?do
              0 i 2 * + MH + c@ to vM 
              1 i 2 * + MH + c@ to vH 
     
              1 vM marked + c!
              1 vH marked + c!

              \ calculate D (38-A-H = D)
              0 to vD_ok
              38 vA vH + - to vD 
              vD marked + c@ 0= 
              vD 0> and
              vD 20 < and
              if
                1 to vD_ok
              then

              0 to nth_EF
              vD_ok 
              if
                \ EF
                1 vD marked + c!

                20 1 
                do
                  i to vE
                  vE marked + c@ 0=
                  if 
                    
                    1 vE marked + c!

                    38 vD vE + vG + - to vF 
                    vF marked + c@ 0=
                    vF 0> and
                    vF 20 < and
                    if 
                      vE 0 nth_EF 2 * + EF +  c! 
                      vF 1 nth_EF 2 * + EF +  c!
                      nth_EF 1+ to nth_EF
                    then
                    0 vE marked + c!
                  then
                 
                loop \ EF
                nth_EF 0
                ?do
                  0 i 2 * + EF + c@ to vE   
                  1 i 2 * + EF + c@ to vF
     
                  1 vE marked + c!
                  1 vF marked + c!
     
                  \ calculate K (K = 38-B-F-P)
                  0 to vK_ok 
                  38 vB vF + vP + - to vK 
                  vK marked + c@ 0=
                  vK 0> and
                  vK 20 < and
                  if
                    1 to vK_ok
                  then
                 
                  vK_ok
                  if 
                    \ calculate O (O = 38-G-K-R)
                    1 vK marked + c! 

                    0 to vO_ok
                    38 vG vK + vR + - to vO
                    vO marked + c@ 0=
                    vO 0> and
                    vO 20 < and
                    if 
                      1 to vO_ok
                    then

                    vO_ok
                    if
                      \ calculate N (N = 38-P-O-M)
                      1 vO marked + c!

                      0 to vN_ok
                      38 vP vO + vM + - to vN
                      vN marked + c@ 0= 
                      vN 0> and
                      vN 20 < and
                      if
                        1 to vN_ok
                      then

                      vN_ok 
                      if 
                        \ calculate I (I = 38-R-N-D)
                        1 vN marked + c!

                        0 to vI_ok
                        38 vR vN + vD + - to vI
                        vI marked + c@ 0=
                        vI 0> and
                        vI 20 < and
                        if 
                          1 to vI_ok
                        then

                        vI_ok 
                        if 
                          \ calculate J (J = 38-H-I-K-L)
                          1 vI marked + c!

                          0 to vJ_ok
                          38 vH vI + vK + vL + - to vJ
                          vJ marked + c@ 0=
                          vJ 0> and
                          vJ 20 < and
                          if
                            1 to vJ_ok 
                          then              

                          vJ_ok
                          if
                            1 vJ marked + c!
                            n_sol 1+ to n_sol
                            vA  0 n_sol 20 * + solutions + c!
                            vB  1 n_sol 20 * + solutions + c!
                            vC  2 n_sol 20 * + solutions + c!
                            vD  3 n_sol 20 * + solutions + c!
                            vE  4 n_sol 20 * + solutions + c!
                            vF  5 n_sol 20 * + solutions + c!
                            vG  6 n_sol 20 * + solutions + c!
                            vH  7 n_sol 20 * + solutions + c!
                            vI  8 n_sol 20 * + solutions + c!
                            vJ  9 n_sol 20 * + solutions + c!
                            vK 10 n_sol 20 * + solutions + c!
                            vL 11 n_sol 20 * + solutions + c!
                            vM 12 n_sol 20 * + solutions + c!
                            vN 13 n_sol 20 * + solutions + c!
                            vO 14 n_sol 20 * + solutions + c!
                            vP 15 n_sol 20 * + solutions + c!
                            vQ 16 n_sol 20 * + solutions + c!
                            vR 17 n_sol 20 * + solutions + c!
                            vS 18 n_sol 20 * + solutions + c!
 
\ +---------------------------------------------------------------------------------------------------------------+
\ | to get just one solution uncomment out the line hereafter, to get all solutions (12) comment out the line hereafter.  |
\ +---------------------------------------------------------------------------------------------------------------+
                            unloop unloop unloop unloop unloop unloop exit

                            0 vJ marked + c! 
                          then                   \ vJ_ok
                          0 vI marked + c!   
                        then                     \ vI_ok
                        0 vN marked + c! 
                      then                       \ vN_ok
                      0 vO marked + c!   
                    then                         \ vO_ok
                    0 vK marked + c!    
                  then                           \ vK_ok
                  0 vE marked + c!  
                  0 vF marked + c! 
                loop                             \ EF
                0 vD marked + c!        
              then                               \ vD_ok
              0 vM marked + c! 
              0 vH marked + c!   
            loop                                 \ MH
            0 vR marked + c! 
            0 vQ marked + c!      
          loop                                   \ RQ
          0 vP marked + c!  
          0 vS marked + c!  
        loop                                     \ PS
        0 vG marked + c!  
        0 vL marked + c!  
      loop                                        \ GL
      0 vA marked + c!  
      0 vB marked + c!  
      0 vC marked + c!
    loop                                          \ ABC
;

: .solution 
  cr n_sol . ." solutions found."
  n_sol 1+ 1 
  ?do
      0 i 20 * + solutions + c@ to vA
      1 i 20 * + solutions + c@ to vB
      2 i 20 * + solutions + c@ to vC
      3 i 20 * + solutions + c@ to vD
      4 i 20 * + solutions + c@ to vE
      5 i 20 * + solutions + c@ to vF
      6 i 20 * + solutions + c@ to vG
      7 i 20 * + solutions + c@ to vH
      8 i 20 * + solutions + c@ to vI
      9 i 20 * + solutions + c@ to vJ
     10 i 20 * + solutions + c@ to vK
     11 i 20 * + solutions + c@ to vL
     12 i 20 * + solutions + c@ to vM
     13 i 20 * + solutions + c@ to vN
     14 i 20 * + solutions + c@ to vO
     15 i 20 * + solutions + c@ to vP
     16 i 20 * + solutions + c@ to vQ
     17 i 20 * + solutions + c@ to vR
     18 i 20 * + solutions + c@ to vS

     cr                       
     ." A=" vA 2 .r space
     ." B=" vB 2 .r space
     ." C=" vC 2 .r space
     ." D=" vD 2 .r space
     ." E=" vE 2 .r space
     ." F=" vF 2 .r space
     ." G=" vG 2 .r space
     ." H=" vH 2 .r space
     ." I=" vI 2 .r space
     ." J=" vJ 2 .r space
     ." K=" vK 2 .r space
     ." L=" vL 2 .r space
     ." M=" vM 2 .r space
     ." N=" vN 2 .r space
     ." O=" vO 2 .r space
     ." P=" vP 2 .r space
     ." Q=" vQ 2 .r space
     ." R=" vR 2 .r space
     ." S=" vS 2 .r 
  loop 

;


: -- 2 .r 2 spaces ;
: .mag_hex
cr n_sol . ." solutions found."
  n_sol 1+ 1 
  ?do
      0 i 20 * + solutions + c@ to vA
      1 i 20 * + solutions + c@ to vB
      2 i 20 * + solutions + c@ to vC
      3 i 20 * + solutions + c@ to vD
      4 i 20 * + solutions + c@ to vE
      5 i 20 * + solutions + c@ to vF
      6 i 20 * + solutions + c@ to vG
      7 i 20 * + solutions + c@ to vH
      8 i 20 * + solutions + c@ to vI
      9 i 20 * + solutions + c@ to vJ
     10 i 20 * + solutions + c@ to vK
     11 i 20 * + solutions + c@ to vL
     12 i 20 * + solutions + c@ to vM
     13 i 20 * + solutions + c@ to vN
     14 i 20 * + solutions + c@ to vO
     15 i 20 * + solutions + c@ to vP
     16 i 20 * + solutions + c@ to vQ
     17 i 20 * + solutions + c@ to vR
     18 i 20 * + solutions + c@ to vS

    cr
    cr 
    4 spaces       vA -- vB -- vC -- cr 
    2 spaces    vD -- vE -- vF -- vG -- cr 
         vH -- vI -- vJ -- vK -- vL -- cr 
    2 spaces    vM -- vN -- vO -- vP -- cr 
    4 spaces       vQ -- vR -- vS -- 
    cr
  loop
;

: timing_1000 
    utime 
    1000 0 
    do 
      solve 
    loop 
    utime 
    d>f d>f f- 1000e f/ 
    cr cr ." Mean execution time : " f. ." micro seconds."  
; 

utime solve utime d>f d>f f- cr cr ." execution time : " f. ."  micro seconds." cr cr .solution cr cr .mag_hex
\ timing_10000
