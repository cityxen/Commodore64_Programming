0 rem strobe light by deadline
1 rem (not xamfear)
10 print "{cls}":rem (shift clr/home)
20 poke 53280,0
30 poke 53281,0
40 for i =0to60
50 next
60 poke 53280,1
70 poke 53281,1
80 goto 20

